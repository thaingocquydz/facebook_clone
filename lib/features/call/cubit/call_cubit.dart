import 'dart:async';
import 'dart:convert';

import 'package:facebook_clone/features/call/cubit/call_state.dart';
import 'package:facebook_clone/features/call/models/call_models.dart';
import 'package:facebook_clone/services/chat_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallCubit extends Cubit<CallState> {
  final ChatService _chat = ChatService();
  final String? currentUserId;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  late final Future<void> _renderersReady;

  String? _callLogId;
  final _peerIds = <String>{};
  bool _isInitiator = false;
  CallType _callType = CallType.audio;
  String? _calleeName;

  // Queued signals that arrive before peer connection is ready
  final _pendingIceCandidates = <RTCIceCandidate>[];
  bool _remoteDescSet = false;
  CallSignal? _pendingOfferSignal;

  StreamSubscription<CallEvent>? _callEventSub;
  StreamSubscription<CallSignal>? _callSignalSub;

  static const _iceConfig = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
    ],
  };

  CallCubit({this.currentUserId}) : super(const CallIdle()) {
    _renderersReady = Future.wait([
      localRenderer.initialize(),
      remoteRenderer.initialize(),
    ]);
    _callEventSub = _chat.onCallEvent.listen(_handleCallEvent);
    _callSignalSub = _chat.onCallSignal.listen(_handleCallSignal);
  }

  // ─── Public actions ────────────────────────────────────────────────────────

  void initiateCall({
    required String conversationId,
    required CallType callType,
    required String calleeName,
  }) {
    _isInitiator = true;
    _callType = callType;
    _calleeName = calleeName;
    _chat.initiateCall(
      conversationId: conversationId,
      callType: callType == CallType.video ? 'VIDEO' : 'AUDIO',
    );
    // State transitions when server echoes INCOMING_CALL back to us
  }

  Future<void> acceptCall({
    required String callLogId,
    required String remoteUserId,
  }) async {
    _callLogId = callLogId;
    if (remoteUserId.isNotEmpty) _peerIds.add(remoteUserId);
    _isInitiator = false;
    _chat.acceptCall(callLogId: callLogId);
    // State transitions when server echoes CALL_ACCEPTED
  }

  void rejectCall({required String callLogId}) {
    _chat.endCall(callLogId: callLogId);
    _cleanup();
    emit(const CallIdle());
  }

  void endCall() {
    if (_callLogId != null) {
      _chat.endCall(callLogId: _callLogId!);
    }
    _cleanup();
    emit(const CallEnded());
  }

  void toggleMute() {
    final cs = state;
    if (cs is! CallActive) return;
    final muted = !cs.isMuted;
    _localStream?.getAudioTracks().forEach((t) => t.enabled = !muted);
    emit(cs.copyWith(isMuted: muted));
  }

  void toggleCamera() {
    final cs = state;
    if (cs is! CallActive || cs.callType != CallType.video) return;
    final off = !cs.isCameraOff;
    _localStream?.getVideoTracks().forEach((t) => t.enabled = !off);
    emit(cs.copyWith(isCameraOff: off));
  }

  void switchCamera() {
    _localStream?.getVideoTracks().forEach((t) => Helper.switchCamera(t));
  }

  // ─── STOMP event handlers ──────────────────────────────────────────────────

  Future<void> _handleCallEvent(CallEvent event) async {
    debugPrint('[CALL] Event: ${event.type} | logId=${event.callLogId}');
    switch (event.type) {
      case CallEventType.incomingCall:
        _callLogId = event.callLogId;
        _callType = event.callType;
        if (_isInitiator) {
          emit(CallOutgoing(
            callLogId: event.callLogId,
            conversationId: event.conversationId,
            callType: event.callType,
            calleeName: _calleeName ?? 'Đang gọi...',
          ));
        } else {
          if (event.initiatorId != null) _peerIds.add(event.initiatorId!);
          emit(CallIncoming(
            callLogId: event.callLogId,
            conversationId: event.conversationId,
            callType: event.callType,
            callerName: event.initiatorDisplayName ?? 'Không rõ',
            callerAvatar: event.initiatorAvatarUrl,
            remoteUserId: event.initiatorId ?? '',
          ));
        }
        break;

      case CallEventType.callAccepted:
        final cs = state;
        if (cs is CallIdle || cs is CallEnded) return;
        if (_isInitiator) {
          // A nhận được CALL_ACCEPTED → biết ID của người vừa chấp nhận
          if (event.fromUserId != null) _peerIds.add(event.fromUserId!);
          await _setupAsAnswerer(event.callLogId);
        } else {
          // B đã chấp nhận → tạo OFFER gửi cho A (A's ID đã có trong _peerIds từ acceptCall)
          await _setupAsOfferer(event.callLogId);
        }
        break;

      case CallEventType.participantLeft:
      case CallEventType.callEnded:
        _cleanup();
        emit(const CallEnded());
        break;
    }
  }

  Future<void> _handleCallSignal(CallSignal signal) async {
    if (signal.callLogId != _callLogId) return;
    debugPrint('[CALL] Signal: ${signal.signalType} from ${signal.fromUserId}');

    if (signal.signalType == 'OFFER') {
      if (_peerConnection == null) {
        // PeerConnection not ready yet — queue and process after setup
        _pendingOfferSignal = signal;
      } else {
        await _handleOffer(signal);
      }
    } else if (signal.signalType == 'ANSWER') {
      await _handleAnswer(signal);
    } else if (signal.signalType == 'ICE') {
      await _handleIce(signal);
    }
  }

  // ─── WebRTC setup ──────────────────────────────────────────────────────────

  /// B (acceptor): create peer connection → OFFER → send to A
  Future<void> _setupAsOfferer(String callLogId) async {
    _callLogId = callLogId;
    emit(CallConnecting(callLogId: callLogId, callType: _callType));
    try {
      await _renderersReady;
      await _initLocalStream();
      await _createPeerConnection();
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      for (final peerId in _peerIds) {
        _chat.sendSignal(
          callLogId: callLogId,
          toUserId: peerId,
          signalType: 'OFFER',
          payload: jsonEncode(offer.toMap()),
        );
      }
    } catch (e) {
      debugPrint('[CALL] Offerer setup error: $e');
      _cleanup();
      emit(const CallEnded(reason: 'Không thể thiết lập cuộc gọi'));
    }
  }

  /// A (initiator): create peer connection → wait for OFFER from B
  Future<void> _setupAsAnswerer(String callLogId) async {
    _callLogId = callLogId;
    emit(CallConnecting(callLogId: callLogId, callType: _callType));
    try {
      await _renderersReady;
      await _initLocalStream();
      await _createPeerConnection();
      // Process queued OFFER that may have arrived before PC was ready
      if (_pendingOfferSignal != null) {
        await _handleOffer(_pendingOfferSignal!);
        _pendingOfferSignal = null;
      }
    } catch (e) {
      debugPrint('[CALL] Answerer setup error: $e');
      _cleanup();
      emit(const CallEnded(reason: 'Không thể thiết lập cuộc gọi'));
    }
  }

  Future<void> _handleOffer(CallSignal signal) async {
    _peerIds.add(signal.fromUserId);
    final offerMap = jsonDecode(signal.payload) as Map<String, dynamic>;
    final offer = RTCSessionDescription(
      offerMap['sdp'] as String,
      offerMap['type'] as String,
    );
    await _peerConnection!.setRemoteDescription(offer);
    _remoteDescSet = true;
    await _drainPendingIce();
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    _chat.sendSignal(
      callLogId: _callLogId!,
      toUserId: signal.fromUserId,
      signalType: 'ANSWER',
      payload: jsonEncode(answer.toMap()),
    );
  }

  Future<void> _handleAnswer(CallSignal signal) async {
    if (_peerConnection == null) return;
    final answerMap = jsonDecode(signal.payload) as Map<String, dynamic>;
    final answer = RTCSessionDescription(
      answerMap['sdp'] as String,
      answerMap['type'] as String,
    );
    await _peerConnection!.setRemoteDescription(answer);
    _remoteDescSet = true;
    await _drainPendingIce();
  }

  Future<void> _handleIce(CallSignal signal) async {
    final iceMap = jsonDecode(signal.payload) as Map<String, dynamic>;
    final candidate = RTCIceCandidate(
      iceMap['candidate'] as String,
      iceMap['sdpMid'] as String?,
      iceMap['sdpMLineIndex'] as int?,
    );
    if (!_remoteDescSet || _peerConnection == null) {
      _pendingIceCandidates.add(candidate);
    } else {
      await _peerConnection!.addCandidate(candidate);
    }
  }

  Future<void> _drainPendingIce() async {
    for (final c in _pendingIceCandidates) {
      await _peerConnection!.addCandidate(c);
    }
    _pendingIceCandidates.clear();
  }

  // ─── WebRTC helpers ────────────────────────────────────────────────────────

  Future<void> _initLocalStream() async {
    final constraints = <String, dynamic>{
      'audio': true,
      'video': _callType == CallType.video
          ? {'facingMode': 'user', 'width': 1280, 'height': 720}
          : false,
    };
    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    localRenderer.srcObject = _localStream;
  }

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(_iceConfig);

    _localStream?.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onIceCandidate = (candidate) {
      if (_callLogId == null || _peerIds.isEmpty) return;
      final icePayload = jsonEncode({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
      for (final peerId in _peerIds) {
        _chat.sendSignal(
          callLogId: _callLogId!,
          toUserId: peerId,
          signalType: 'ICE',
          payload: icePayload,
        );
      }
    };

    _peerConnection!.onTrack = (event) {
      if (event.streams.isEmpty) return;
      _remoteStream = event.streams[0];
      remoteRenderer.srcObject = _remoteStream;
      final cs = state;
      if (cs is CallConnecting) {
        emit(CallActive(callLogId: cs.callLogId, callType: cs.callType));
      }
    };

    _peerConnection!.onConnectionState = (rtcState) {
      debugPrint('[WebRTC] Connection state: $rtcState');
      if (rtcState == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          rtcState == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        _cleanup();
        emit(const CallEnded(reason: 'Mất kết nối'));
      }
    };
  }

  // ─── Cleanup ───────────────────────────────────────────────────────────────

  void _cleanup() {
    _pendingIceCandidates.clear();
    _pendingOfferSignal = null;
    _remoteDescSet = false;
    _callLogId = null;
    _peerIds.clear();
    _isInitiator = false;
    _calleeName = null;
    _callType = CallType.audio;

    _localStream?.getTracks().forEach((t) => t.stop());
    _localStream?.dispose();
    _localStream = null;
    localRenderer.srcObject = null;

    _remoteStream?.getTracks().forEach((t) => t.stop());
    _remoteStream?.dispose();
    _remoteStream = null;
    remoteRenderer.srcObject = null;

    _peerConnection?.close();
    _peerConnection = null;
  }

  @override
  Future<void> close() async {
    _callEventSub?.cancel();
    _callSignalSub?.cancel();
    _cleanup();
    localRenderer.dispose();
    remoteRenderer.dispose();
    return super.close();
  }
}

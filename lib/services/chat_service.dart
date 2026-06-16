import 'dart:async';
import 'dart:convert';

import 'package:facebook_clone/features/messages/models/message.dart';
import 'package:facebook_clone/services/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatService {
  static final ChatService _instance = ChatService._();
  factory ChatService() => _instance;
  ChatService._();

  static String get _wsUrl {
    final base = DioClient.baseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://')
        .replaceFirst('/api/v1', '');
    return '$base/ws-native';
  }

  StompClient? _client;
  final _pendingMessages = <Map<String, dynamic>>[];

  final _messageCtrl = StreamController<Message>.broadcast();
  final _typingCtrl = StreamController<TypingEvent>.broadcast();
  final _readCtrl = StreamController<ReadReceiptEvent>.broadcast();

  Stream<Message> get onMessage => _messageCtrl.stream;
  Stream<TypingEvent> get onTyping => _typingCtrl.stream;
  Stream<ReadReceiptEvent> get onRead => _readCtrl.stream;

  void connect({
    required String conversationId,
    void Function()? onConnected,
    void Function(String)? onError,
  }) {
    _client?.deactivate();
    final token = DioClient().token;

    debugPrint('[WS] Connecting to $_wsUrl | token=${token != null ? 'ok' : 'NULL'}');

    final authHeaders = token != null ? {'Authorization': 'Bearer $token'} : <String, String>{};

    _client = StompClient(
      config: StompConfig(
        url: _wsUrl,
        stompConnectHeaders: authHeaders,
        webSocketConnectHeaders: authHeaders,
        heartbeatIncoming: const Duration(milliseconds: 25000),
        heartbeatOutgoing: const Duration(milliseconds: 25000),
        reconnectDelay: const Duration(seconds: 5),
        onConnect: (frame) {
          debugPrint('[WS] Connected ✓ | pending=${_pendingMessages.length}');
          _subscribeToConversation(conversationId);
          for (final msg in _pendingMessages) {
            _client!.send(
              destination: '/app/chat.message',
              body: jsonEncode(msg),
            );
          }
          _pendingMessages.clear();
          onConnected?.call();
        },
        onWebSocketError: (err) {
          debugPrint('[WS] WebSocket error: $err');
          onError?.call(err.toString());
        },
        onStompError: (frame) {
          debugPrint('[WS] STOMP error: ${frame.body}');
          onError?.call(frame.body ?? 'STOMP error');
        },
        onDisconnect: (_) => debugPrint('[WS] Disconnected'),
      ),
    );
    _client!.activate();
  }

  void _subscribeToConversation(String id) {
    _client!.subscribe(
      destination: '/topic/conversation.$id',
      callback: (frame) {
        if (frame.body == null) return;
        final json = jsonDecode(frame.body!) as Map<String, dynamic>;
        _messageCtrl.add(Message.fromJson(json));
      },
    );
    _client!.subscribe(
      destination: '/topic/conversation.$id.typing',
      callback: (frame) {
        if (frame.body == null) return;
        final json = jsonDecode(frame.body!) as Map<String, dynamic>;
        _typingCtrl.add(TypingEvent.fromJson(json));
      },
    );
    _client!.subscribe(
      destination: '/topic/conversation.$id.read',
      callback: (frame) {
        if (frame.body == null) return;
        final json = jsonDecode(frame.body!) as Map<String, dynamic>;
        _readCtrl.add(ReadReceiptEvent.fromJson(json));
      },
    );
  }

  bool get _isConnected => _client != null && _client!.connected;

  void sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'TEXT',
    String? replyToId,
  }) {
    final payload = <String, dynamic>{
      'conversationId': conversationId,
      'content': content,
      'messageType': messageType,
      if (replyToId != null) 'replyToId': replyToId,
    };
    if (!_isConnected) {
      debugPrint('[WS] Not connected — queued message: $payload');
      _pendingMessages.add(payload);
      return;
    }
    debugPrint('[WS] Sending message: $payload');
    _client!.send(
      destination: '/app/chat.message',
      body: jsonEncode(payload),
    );
  }

  void sendTyping({required String conversationId, required bool typing}) {
    if (!_isConnected) return;
    _client!.send(
      destination: '/app/chat.typing',
      body: jsonEncode({
        'conversationId': conversationId,
        'typing': typing,
      }),
    );
  }

  void sendRead({
    required String conversationId,
    required String lastReadMessageId,
  }) {
    if (!_isConnected) return;
    _client!.send(
      destination: '/app/chat.read',
      body: jsonEncode({
        'conversationId': conversationId,
        'lastReadMessageId': lastReadMessageId,
      }),
    );
  }

  void disconnect() {
    _pendingMessages.clear();
    _client?.deactivate();
    _client = null;
  }
}

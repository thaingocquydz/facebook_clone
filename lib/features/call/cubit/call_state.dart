import 'package:equatable/equatable.dart';
import 'package:facebook_clone/features/call/models/call_models.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

class CallIdle extends CallState {
  const CallIdle();
}

class CallIncoming extends CallState {
  final String callLogId;
  final String conversationId;
  final CallType callType;
  final String callerName;
  final String? callerAvatar;
  final String remoteUserId;

  const CallIncoming({
    required this.callLogId,
    required this.conversationId,
    required this.callType,
    required this.callerName,
    required this.remoteUserId,
    this.callerAvatar,
  });

  @override
  List<Object?> get props => [callLogId, conversationId, callType, callerName, remoteUserId, callerAvatar];
}

class CallOutgoing extends CallState {
  final String callLogId;
  final String conversationId;
  final CallType callType;
  final String calleeName;

  const CallOutgoing({
    required this.callLogId,
    required this.conversationId,
    required this.callType,
    required this.calleeName,
  });

  @override
  List<Object?> get props => [callLogId, conversationId, callType, calleeName];
}

class CallConnecting extends CallState {
  final String callLogId;
  final CallType callType;

  const CallConnecting({required this.callLogId, required this.callType});

  @override
  List<Object?> get props => [callLogId, callType];
}

class CallActive extends CallState {
  final String callLogId;
  final CallType callType;
  final bool isMuted;
  final bool isCameraOff;

  const CallActive({
    required this.callLogId,
    required this.callType,
    this.isMuted = false,
    this.isCameraOff = false,
  });

  CallActive copyWith({bool? isMuted, bool? isCameraOff}) {
    return CallActive(
      callLogId: callLogId,
      callType: callType,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
    );
  }

  @override
  List<Object?> get props => [callLogId, callType, isMuted, isCameraOff];
}

class CallEnded extends CallState {
  final String? reason;

  const CallEnded({this.reason});

  @override
  List<Object?> get props => [reason];
}

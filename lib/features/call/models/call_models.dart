enum CallType { audio, video }

enum CallEventType {
  incomingCall,
  callAccepted,
  participantLeft,
  callEnded,
}

class CallEvent {
  final CallEventType type;
  final String callLogId;
  final String conversationId;
  final CallType callType;
  final String? initiatorId;
  final String? initiatorDisplayName;
  final String? initiatorAvatarUrl;
  /// ID của người vừa trigger event này:
  /// - INCOMING_CALL  → initiatorId (người gọi)
  /// - CALL_ACCEPTED  → acceptorId  (người vừa chấp nhận)
  final String? fromUserId;

  const CallEvent({
    required this.type,
    required this.callLogId,
    required this.conversationId,
    required this.callType,
    this.initiatorId,
    this.initiatorDisplayName,
    this.initiatorAvatarUrl,
    this.fromUserId,
  });

  factory CallEvent.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? '';
    final CallEventType type;
    switch (typeStr) {
      case 'INCOMING_CALL':
        type = CallEventType.incomingCall;
        break;
      case 'CALL_ACCEPTED':
        type = CallEventType.callAccepted;
        break;
      case 'PARTICIPANT_LEFT':
        type = CallEventType.participantLeft;
        break;
      case 'CALL_ENDED':
      default:
        type = CallEventType.callEnded;
    }
    final initiatorId = json['initiatorId'] as String?;
    // fromUserId: backend gửi field này; fallback về initiatorId cho INCOMING_CALL
    final fromUserId = json['fromUserId'] as String? ?? initiatorId;
    return CallEvent(
      type: type,
      callLogId: json['callLogId'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      callType: json['callType'] == 'VIDEO' ? CallType.video : CallType.audio,
      initiatorId: initiatorId,
      initiatorDisplayName: json['initiatorDisplayName'] as String?,
      initiatorAvatarUrl: json['initiatorAvatarUrl'] as String?,
      fromUserId: fromUserId,
    );
  }
}

class CallSignal {
  final String callLogId;
  final String fromUserId;
  final String signalType; // OFFER, ANSWER, ICE
  final String payload;

  const CallSignal({
    required this.callLogId,
    required this.fromUserId,
    required this.signalType,
    required this.payload,
  });

  factory CallSignal.fromJson(Map<String, dynamic> json) {
    return CallSignal(
      callLogId: json['callLogId'] as String? ?? '',
      fromUserId: json['fromUserId'] as String? ?? '',
      signalType: json['signalType'] as String? ?? '',
      payload: json['payload'] as String? ?? '',
    );
  }
}

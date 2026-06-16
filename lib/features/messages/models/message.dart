class ReplyToMessage {
  final String id;
  final String senderId;
  final String senderUsername;
  final String content;
  final String messageType;

  const ReplyToMessage({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.messageType,
  });

  factory ReplyToMessage.fromJson(Map<String, dynamic> json) {
    return ReplyToMessage(
      id: json['id'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderUsername: json['senderUsername'] as String? ?? '',
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? 'TEXT',
    );
  }
}

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderUsername;
  final String senderDisplayName;
  final String? senderAvatarUrl;
  final String content;
  final String type;
  final String? mediaUrl;
  final String? mediaThumbnail;
  final int? mediaSizeBytes;
  final ReplyToMessage? replyTo;
  final bool edited;
  final bool deleted;
  final DateTime sentAt;
  final DateTime updatedAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderUsername,
    required this.senderDisplayName,
    this.senderAvatarUrl,
    required this.content,
    required this.type,
    this.mediaUrl,
    this.mediaThumbnail,
    this.mediaSizeBytes,
    this.replyTo,
    this.edited = false,
    this.deleted = false,
    required this.sentAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final replyToJson = json['replyTo'] as Map<String, dynamic>?;
    final createdAt = json['createdAt'] as String?;
    final updatedAtRaw = json['updatedAt'] as String?;
    return Message(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderUsername: json['senderUsername'] as String? ?? '',
      senderDisplayName: json['senderDisplayName'] as String? ?? '',
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      content: json['content'] as String? ?? '',
      type: json['messageType'] as String? ?? 'TEXT',
      mediaUrl: json['mediaUrl'] as String?,
      mediaThumbnail: json['mediaThumbnail'] as String?,
      mediaSizeBytes: json['mediaSizeBytes'] as int?,
      replyTo: replyToJson != null ? ReplyToMessage.fromJson(replyToJson) : null,
      edited: json['edited'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
      sentAt: createdAt != null
          ? DateTime.tryParse(createdAt) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: updatedAtRaw != null
          ? DateTime.tryParse(updatedAtRaw) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class TypingEvent {
  final String conversationId;
  final String userId;
  final String username;
  final bool typing;

  const TypingEvent({
    required this.conversationId,
    required this.userId,
    required this.username,
    required this.typing,
  });

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    return TypingEvent(
      conversationId: json['conversationId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      typing: json['typing'] as bool? ?? false,
    );
  }
}

class ReadReceiptEvent {
  final String conversationId;
  final String userId;
  final String lastReadMessageId;
  final DateTime readAt;

  const ReadReceiptEvent({
    required this.conversationId,
    required this.userId,
    required this.lastReadMessageId,
    required this.readAt,
  });

  factory ReadReceiptEvent.fromJson(Map<String, dynamic> json) {
    return ReadReceiptEvent(
      conversationId: json['conversationId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      lastReadMessageId: json['lastReadMessageId'] as String? ?? '',
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class MessagesResponse {
  final int code;
  final List<Message> data;
  final String message;

  const MessagesResponse({
    required this.code,
    required this.data,
    required this.message,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] as Map<String, dynamic>? ?? {};
    final contentList = dataMap['content'] as List<dynamic>? ?? [];
    final dataList = contentList
        .map((m) => Message.fromJson(m as Map<String, dynamic>))
        .toList();

    return MessagesResponse(
      code: json['code'] as int? ?? 0,
      data: dataList,
      message: json['message'] as String? ?? '',
    );
  }
}

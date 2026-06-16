class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderDisplayName;
  final String? senderAvatarUrl;
  final String content;
  final String type;
  final DateTime sentAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderDisplayName,
    this.senderAvatarUrl,
    required this.content,
    required this.type,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderDisplayName: json['senderDisplayName'] as String? ?? '',
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      content: json['content'] as String? ?? '',
      type: json['messageType'] as String? ?? 'TEXT',
      sentAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
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

class ConversationMember {
  final String? avatarUrl;
  final String displayName;
  final bool online;
  final String role;
  final String userId;
  final String username;

  const ConversationMember({
    required this.avatarUrl,
    required this.displayName,
    required this.online,
    required this.role,
    required this.userId,
    required this.username,
  });

  factory ConversationMember.fromJson(Map<String, dynamic> json) {
    return ConversationMember(
      avatarUrl: json['avatarUrl'] as String?,
      displayName: json['displayName'] as String? ?? '',
      online: json['online'] as bool? ?? false,
      role: json['role'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }
}

class Conversation {
  final String id;
  final String name;
  final String? description;
  final String type;
  final int unreadCount;
  final List<ConversationMember> members;

  const Conversation({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.unreadCount,
    required this.members,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final membersList = (json['members'] as List<dynamic>? ?? [])
        .map((m) => ConversationMember.fromJson(m as Map<String, dynamic>))
        .toList();

    return Conversation(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String? ?? '',
      unreadCount: json['unreadCount'] as int? ?? 0,
      members: membersList,
    );
  }
}

class ConversationsResponse {
  final int code;
  final List<Conversation> data;
  final String message;

  const ConversationsResponse({
    required this.code,
    required this.data,
    required this.message,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((c) => Conversation.fromJson(c as Map<String, dynamic>))
        .toList();

    return ConversationsResponse(
      code: json['code'] as int? ?? 0,
      data: dataList,
      message: json['message'] as String? ?? '',
    );
  }
}

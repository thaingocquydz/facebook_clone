class AuthUser {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? email;

  const AuthUser({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.email,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String?,
    );
  }
}

class AuthResponse {
  final String? token;
  final String? refreshToken;
  final String? message;
  final AuthUser? user;

  const AuthResponse({
    this.token,
    this.refreshToken,
    this.message,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    final userJson = data?['user'] as Map<String, dynamic>?;

    return AuthResponse(
      token: data?['accessToken'] as String?,
      refreshToken: data?['refreshToken'] as String?,
      message: json['message'] as String?,
      user: userJson != null ? AuthUser.fromJson(userJson) : null,
    );
  }
}

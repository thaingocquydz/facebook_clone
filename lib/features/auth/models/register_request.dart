class RegisterRequest {
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String displayName;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'displayName': displayName,
      };
}

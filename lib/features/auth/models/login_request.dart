class LoginRequest {
  final String account;
  final String password;

  const LoginRequest({required this.account, required this.password});

  Map<String, dynamic> toJson() => {
        'identity': account,
        'password': password,
      };
}

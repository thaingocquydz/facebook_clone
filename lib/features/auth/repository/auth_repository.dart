import 'package:dio/dio.dart';
import 'package:facebook_clone/features/auth/models/auth_response.dart';
import 'package:facebook_clone/features/auth/models/login_request.dart';
import 'package:facebook_clone/features/auth/models/register_request.dart';
import 'package:facebook_clone/services/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/api/v1/auth/login',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _dio.post(
      '/api/v1/auth/register',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

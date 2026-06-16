import 'package:dio/dio.dart';
import 'package:facebook_clone/features/auth/cubit/auth_state.dart';
import 'package:facebook_clone/features/auth/models/login_request.dart';
import 'package:facebook_clone/features/auth/models/register_request.dart';
import 'package:facebook_clone/features/auth/repository/auth_repository.dart';
import 'package:facebook_clone/services/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  void reset() => emit(AuthInitial());

  Future<void> login(String account, String password) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(
        LoginRequest(account: account, password: password),
      );
      if (response.token != null) {
        DioClient().setToken(response.token!);
      }
      emit(LoginSuccess(message: response.message, user: response.user));
    } on DioException catch (e) {
      emit(AuthFailure(_handleDioError(e)));
    } catch (_) {
      emit(const AuthFailure('Đã có lỗi xảy ra, vui lòng thử lại'));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String displayName,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.register(
        RegisterRequest(
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          displayName: displayName,
        ),
      );
      emit(RegisterSuccess(message: response.message));
    } on DioException catch (e) {
      emit(AuthFailure(_handleDioError(e)));
    } catch (_) {
      emit(const AuthFailure('Đã có lỗi xảy ra, vui lòng thử lại'));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối quá thời gian, vui lòng thử lại';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        return 'Lỗi máy chủ: ${e.response?.statusCode}';
      default:
        return 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }
}

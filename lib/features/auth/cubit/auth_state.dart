import 'package:equatable/equatable.dart';
import 'package:facebook_clone/features/auth/models/auth_response.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String? message;
  final AuthUser? user;

  const LoginSuccess({this.message, this.user});

  @override
  List<Object?> get props => [message, user];
}

class RegisterSuccess extends AuthState {
  final String? message;
  const RegisterSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

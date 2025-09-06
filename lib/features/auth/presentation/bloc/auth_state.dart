part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthUninitialized extends AuthState {}
class Authenticated extends AuthState {
  final String userId;
  final String role;
  Authenticated({required this.userId, required this.role});
  @override
  List<Object?> get props => [userId, role];
}
class Unauthenticated extends AuthState {}
class AuthLoading extends AuthState {}
class OTPRequestedState extends AuthState {
  final String verificationId;
  OTPRequestedState(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}
class OTPVerifiedState extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

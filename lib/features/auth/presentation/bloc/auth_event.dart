part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String phone;
  final String societyCode;
  LoginRequested(this.phone, this.societyCode);
  @override
  List<Object?> get props => [phone, societyCode];
}
class RegisterRequested extends AuthEvent {
  final String name;
  final String apartmentName;
  final String flatNumber;
  final String phone;
  final String societyCode;
  RegisterRequested({required this.name, required this.apartmentName, required this.flatNumber, required this.phone, required this.societyCode});
  @override
  List<Object?> get props => [name, apartmentName, flatNumber, phone, societyCode];
}
class OTPRequested extends AuthEvent {
  final String phone;
  OTPRequested(this.phone);
  @override
  List<Object?> get props => [phone];
}
class OTPVerified extends AuthEvent {
  final String otp;
  OTPVerified(this.otp);
  @override
  List<Object?> get props => [otp];
}
class LogoutRequested extends AuthEvent {}
class CompleteRegistration extends AuthEvent {
  final String userId;
  final String name;
  final String apartmentName;
  final String flatNumber;
  final String phone;
  final String societyCode;
  CompleteRegistration({
    required this.userId,
    required this.name,
    required this.apartmentName,
    required this.flatNumber,
    required this.phone,
    required this.societyCode,
  });
  @override
  List<Object?> get props => [userId, name, apartmentName, flatNumber, phone, societyCode];
}
class CompleteLogin extends AuthEvent {
  final String userId;
  CompleteLogin({required this.userId});
  @override
  List<Object?> get props => [userId];
}

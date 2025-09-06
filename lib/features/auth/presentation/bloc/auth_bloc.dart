import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _verificationId;
  final UserRepository _userRepository = UserRepository();

  AuthBloc() : super(AuthUninitialized()) {
    on<OTPRequested>(_onOTPRequested);
    on<OTPVerified>(_onOTPVerified);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<CompleteRegistration>(_onCompleteRegistration);
    on<CompleteLogin>(_onCompleteLogin);
    // Add other event handlers as needed
  }

  Future<void> _onOTPRequested(OTPRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: event.phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          await _firebaseAuth.signInWithCredential(credential);
          emit(OTPVerifiedState());
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(e.message ?? 'OTP verification failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          emit(OTPRequestedState(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onOTPVerified(OTPVerified event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (_verificationId == null) {
        emit(AuthError('No verification ID. Please request OTP again.'));
        return;
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: event.otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      emit(OTPVerifiedState());
    } catch (e) {
      emit(AuthError('Invalid OTP. Please try again.'));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    add(OTPRequested(event.phone));
    // After OTP is verified, user creation in Firestore should be handled in the UI or in a follow-up event.
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    add(OTPRequested(event.phone));
    // After OTP is verified, user lookup and approval check should be handled in the UI or in a follow-up event.
  }

  Future<void> _onCompleteRegistration(CompleteRegistration event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = UserModel(
        id: event.userId,
        name: event.name,
        phone: event.phone,
        apartmentName: event.apartmentName,
        flatNumber: event.flatNumber,
        role: 'member',
        isApproved: false,
        createdAt: Timestamp.now(),
      );
      await _userRepository.createUser(user);
      emit(Authenticated(userId: user.id, role: user.role));
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onCompleteLogin(CompleteLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.getUserById(event.userId);
      if (user == null) {
        emit(AuthError('User not found. Please register.'));
      } else if (!user.isApproved) {
        emit(AuthError('Your account is pending admin approval.'));
      } else {
        emit(Authenticated(userId: user.id, role: user.role));
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }
}

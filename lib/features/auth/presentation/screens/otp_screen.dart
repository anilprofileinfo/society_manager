import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  final String? name;
  final String? apartmentName;
  final String? flatNumber;
  final String? societyCode;
  final bool isRegistration;
  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phone,
    this.name,
    this.apartmentName,
    this.flatNumber,
    this.societyCode,
    this.isRegistration = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        OTPVerified(_otpController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is OTPVerifiedState && widget.isRegistration) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            BlocProvider.of<AuthBloc>(context).add(
              CompleteRegistration(
                userId: userId,
                name: widget.name!,
                apartmentName: widget.apartmentName!,
                flatNumber: widget.flatNumber!,
                phone: widget.phone,
                societyCode: widget.societyCode!,
              ),
            );
          }
        }
        if (state is OTPVerifiedState && !widget.isRegistration) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            BlocProvider.of<AuthBloc>(context).add(
              CompleteLogin(userId: userId),
            );
          }
        }
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'userRole': state.role});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Enter OTP')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('OTP sent to ${widget.phone}', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Enter 6-digit OTP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _onVerify,
                          child: const Text('Verify OTP'),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

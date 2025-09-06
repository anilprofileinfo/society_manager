import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _societyCodeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _societyCodeController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginRequested(
          _phoneController.text.trim(),
          _societyCodeController.text.trim(),
        ),
      );
    }
  }

  void _onRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OTPRequestedState) {
          Navigator.pushNamed(context, '/otp', arguments: {
            'verificationId': state.verificationId,
            'phone': _phoneController.text.trim(),
            'isRegistration': false,
          });
        } else if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'userRole': state.role});
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter phone number';
                    }
                    if (value.length < 10) {
                      return 'Enter valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _societyCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Society Code',
                    prefixIcon: Icon(Icons.apartment),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter society code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onLogin,
                        child: const Text('Login as Admin'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onRegister,
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

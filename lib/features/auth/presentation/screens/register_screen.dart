import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _flatController = TextEditingController();
  final _phoneController = TextEditingController();
  final _societyCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _apartmentController.dispose();
    _flatController.dispose();
    _phoneController.dispose();
    _societyCodeController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterRequested(
          name: _nameController.text.trim(),
          apartmentName: _apartmentController.text.trim(),
          flatNumber: _flatController.text.trim(),
          phone: _phoneController.text.trim(),
          societyCode: _societyCodeController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OTPRequestedState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: state.verificationId,
                phone: _phoneController.text.trim(),
                name: _nameController.text.trim(),
                apartmentName: _apartmentController.text.trim(),
                flatNumber: _flatController.text.trim(),
                societyCode: _societyCodeController.text.trim(),
                isRegistration: true,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _apartmentController,
                  decoration: const InputDecoration(
                    labelText: 'Apartment Name',
                    prefixIcon: Icon(Icons.apartment),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter apartment name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _flatController,
                  decoration: const InputDecoration(
                    labelText: 'Flat Number',
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter flat number' : null,
                ),
                const SizedBox(height: 16),
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
                    prefixIcon: Icon(Icons.code),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter society code' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _onRegister,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

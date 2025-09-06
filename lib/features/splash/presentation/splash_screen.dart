import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    Future.delayed(const Duration(seconds: 2), _navigateNext);
  }

/*
  void _navigateNext() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // You may want to fetch user role from Firestore here
      Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'userRole': 'member'});
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
*/
  void _navigateNext() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user role from Firestore
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final role = data?['role'] ?? 'member';
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'userRole': role});
      } else {
        // User not found in Firestore, fallback to login or handle as needed
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apartment, size: 100, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Society Manager',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

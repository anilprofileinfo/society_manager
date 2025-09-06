import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/widgets/error_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initFCM();
  Bloc.observer = SimpleBlocObserver();
  runApp(const SocietyManagerApp());
}

Future<void> _initFCM() async {
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Show notification as SnackBar
    final context = navigatorKey.currentContext;
    if (context != null && message.notification != null) {
      showErrorSnackbar(context, message.notification!.title ?? 'Notification');
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SocietyManagerApp extends StatelessWidget {
  const SocietyManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Society Manager',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Optionally handle navigation side effects here
      },
      builder: (context, state) {
        if (state is AuthUninitialized) {
          return const SplashScreen();
        } else if (state is Unauthenticated) {
          return LoginScreen();
        } else if (state is OTPRequestedState) {
          return OtpScreen(verificationId: state.verificationId, phone: ""); // Pass phone if needed
        } else if (state is OTPVerifiedState) {
          // After OTP, show register or dashboard based on flow (simplified here)
          return const PlaceholderScreen(text: 'OTP Verified! Implement next step.');
        } else if (state is Authenticated) {
          return DashboardScreen(userRole: state.role);
        } else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthError) {
          return LoginScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String text;
  const PlaceholderScreen({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Society Manager')),
      body: Center(child: Text(text)),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }
}

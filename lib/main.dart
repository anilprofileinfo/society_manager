import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/error_snackbar.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/members/presentation/screens/admin_approval_screen.dart';
import 'firebase_options.dart';
// import 'features/profile/presentation/screens/profile_screen.dart'; // Uncomment if implemented

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initFCM();
  Bloc.observer = SimpleBlocObserver();
  runApp(const SocietyManagerApp());
}

Future<void> _initFCM() async {
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context != null && message.notification != null) {
      showErrorSnackbar(context, message.notification!.title ?? 'Notification');
    }
  });
}

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
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashScreen());
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterScreen());
            case '/otp':
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (_) => OtpScreen(
                  verificationId: args?['verificationId'] ?? '',
                  phone: args?['phone'] ?? '',
                  name: args?['name'],
                  apartmentName: args?['apartmentName'],
                  flatNumber: args?['flatNumber'],
                  societyCode: args?['societyCode'],
                  isRegistration: args?['isRegistration'] ?? false,
                ),
              );
            case '/dashboard':
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (_) => DashboardScreen(userRole: args?['userRole'] ?? 'member'),
              );
            case '/admin-approval':
              return MaterialPageRoute(builder: (_) => const AdminApprovalScreen());
            // case '/profile':
            //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
            default:
              return MaterialPageRoute(builder: (_) => const SplashScreen());
          }
        },
      ),
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

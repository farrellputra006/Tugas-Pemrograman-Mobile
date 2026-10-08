import 'package:flutter/material.dart';
import 'package:projectmobile/forgot_password_page.dart';
import 'package:projectmobile/login_page.dart';
import 'package:projectmobile/new_password_page.dart';
import 'package:projectmobile/profile_page.dart';
import 'package:projectmobile/register_page.dart';
import 'package:projectmobile/splash_page.dart';
import 'package:projectmobile/verification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecowalk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E604E)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const SplashPage(),
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/lupa-password': (context) => const ForgotPasswordPage(),
        '/new-password': (context) => const NewPasswordPage(),
        '/reset-password': (context) => const NewPasswordPage(),
        '/verification': (context) => const VerificationPage(),
        '/home': (context) => const ProfilePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}


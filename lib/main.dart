import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'otp_verification_page.dart';
import 'reset_password_page.dart';
import 'map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/forgot-password', page: () => ForgotPasswordPage()),
        GetPage(name: '/otp-verification', page: () => OtpVerificationPage()),
        GetPage(name: '/reset-password', page: () => ResetPasswordPage()),
        GetPage(name: '/map-screen', page: () => MapScreen()),
      ],
    );
  }
}

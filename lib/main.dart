import 'package:app_attend/src/dashboard/dashboard.dart';
import 'package:app_attend/src/main_screen.dart/login.dart';
import 'package:app_attend/src/main_screen.dart/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/main_screen.dart/welcome.dart';

void main() {
  runApp(TapAttendApp());
}

class TapAttendApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TapAttend',
      initialRoute: '/dashboard',
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
      ],
    );
  }
}

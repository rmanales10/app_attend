import 'package:app_attend/src/dashboard/dashboard.dart';
import 'package:app_attend/src/main_screen.dart/login.dart';
import 'package:app_attend/src/main_screen.dart/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/main_screen.dart/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDoLT3mc5M94ROOMzTkd8Wsck78SWGESC8",
            authDomain: "project101-fe735.firebaseapp.com",
            projectId: "project101-fe735",
            storageBucket: "project101-fe735.firebasestorage.app",
            messagingSenderId: "401225501792",
            appId: "1:401225501792:web:ca5288e4e2ee10cfdb0705",
            measurementId: "G-6BC7VJSLHR"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(TapAttendApp());
}

class TapAttendApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TapAttend',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
      ],
    );
  }
}

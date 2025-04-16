import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCImdQCXcVuxKg8YOGhVZaXrm8QZ427sHQ",
      authDomain: "hw04-40f58.firebaseapp.com",
      projectId: "hw04-40f58",
      storageBucket: "hw04-40f58.appspot.com",
      messagingSenderId: "3403600468",
      appId: "1:3403600468:web:df2bbea66b7f0fa80853c1",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xFFF6BD60);
  final Color backgroundColor = Color(0xFFF7EDE2);
  final Color accentColor = Color(0xFFF5CAC3);
  final Color secondaryColor = Color(0xFF84A59D);
  final Color warningColor = Color(0xFFF28482);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Board App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: warningColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: accentColor,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

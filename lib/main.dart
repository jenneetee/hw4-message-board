import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Manually initializing Firebase for web
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCImdQCXcVuxKg8YOGhVZaXrm8QZ427sHQ",
      authDomain: "hw04-40f58.firebaseapp.com",
      projectId: "hw04-40f58",
      storageBucket: "hw04-40f58.appspot.com", // Use the correct Firebase storage URL
      messagingSenderId: "3403600468",
      appId: "1:3403600468:web:df2bbea66b7f0fa80853c1",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Board App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

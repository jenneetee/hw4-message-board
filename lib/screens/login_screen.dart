import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_boards_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => MessageBoardsScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          ElevatedButton(onPressed: () => login(context), child: Text("Login")),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
          }, child: Text("Register")),
        ]),
      ),
    );
  }
}

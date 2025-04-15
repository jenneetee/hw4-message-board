import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  void register(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'first_name': fnameController.text,
        'last_name': lnameController.text,
        'role': 'user',
        'created_at': Timestamp.now(),
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: fnameController, decoration: InputDecoration(labelText: 'First Name')),
          TextField(controller: lnameController, decoration: InputDecoration(labelText: 'Last Name')),
          TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          ElevatedButton(onPressed: () => register(context), child: Text("Register")),
        ]),
      ),
    );
  }
}

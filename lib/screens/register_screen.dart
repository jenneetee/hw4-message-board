import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final dobController = TextEditingController();
  final bioController = TextEditingController();  // Controller for Bio field

  DateTime? selectedDate;

  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void register(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'first_name': fnameController.text.trim(),
          'last_name': lnameController.text.trim(),
          'email': user.email,
          'date_of_birth': selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
          'bio': bioController.text.trim(),  // Save bio here
          'role': 'user',
          'created_at': Timestamp.now(),
        });
      }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: fnameController, decoration: InputDecoration(labelText: 'First Name')),
              TextField(controller: lnameController, decoration: InputDecoration(labelText: 'Last Name')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () => pickDate(context),
              ),
              TextField(
                controller: bioController,  // TextField for bio
                decoration: InputDecoration(labelText: 'Bio'),
                maxLines: 3,  // Allow for multiline input
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () => register(context), child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}

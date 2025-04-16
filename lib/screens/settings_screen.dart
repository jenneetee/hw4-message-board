import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  User? user;
  DocumentSnapshot? userDoc;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      final data = doc.data() as Map<String, dynamic>?;

      setState(() {
        userDoc = doc;
        if (data != null) {
          _dobController.text = data.containsKey('dob') ? data['dob'] : '';
        }
        _emailController.text = user!.email ?? '';
      });
    }
  }

  Future<void> _updateDOB() async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'dob': _dobController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('DOB updated')));
    }
  }

  Future<void> _updateEmail() async {
    if (user != null) {
      try {
        await user!.updateEmail(_emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email updated')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _updatePassword() async {
    if (user != null) {
      try {
        await user!.updatePassword(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Color(0xFFF28482),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personal Information", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            TextField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(labelText: "Date of Birth"),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _dobController.text = picked.toIso8601String().split('T').first;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: _updateDOB,
              child: Text("Update DOB"),
            ),
            Divider(height: 32),
            Text("Login Information", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            ElevatedButton(
              onPressed: _updateEmail,
              child: Text("Update Email"),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text("Update Password"),
            ),
            Divider(height: 32),
            ElevatedButton(
              onPressed: () => logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF28482),
              ),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

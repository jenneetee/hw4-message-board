import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Update the user's email
  Future<void> _updateEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(_emailController.text.trim());
        await user.reload();
        user = _auth.currentUser; // Refresh the user data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email updated successfully")),
        );
      }
    } catch (e) {
      print("Error updating email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating email")),
      );
    }
  }

  // Update the user's password
  Future<void> _updatePassword() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_passwordController.text.trim());
        await user.reload();
        user = _auth.currentUser; // Refresh the user data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password updated successfully")),
        );
      }
    } catch (e) {
      print("Error updating password: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating password")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill the email field with the current user's email
    _emailController.text = _auth.currentUser?.email ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value != null && value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Save button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Only attempt update if validation passes
                    if (_emailController.text.isNotEmpty) {
                      await _updateEmail();
                    }
                    if (_passwordController.text.isNotEmpty) {
                      await _updatePassword();
                    }
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

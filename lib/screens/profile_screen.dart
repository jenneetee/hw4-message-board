import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bioController = TextEditingController();

  User? user;
  DocumentSnapshot? userDoc;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserData();
  }

  // Load the user's data from Firestore
  Future<void> _loadUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userDoc = doc;
        _bioController.text = doc['bio'] ?? '';  // Load the bio from Firestore
      });
    }
  }

  // Update the user's bio in Firestore
  Future<void> _updateBio() async {
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'bio': _bioController.text.trim(),
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bio updated successfully")));
      } catch (e) {
        print("Error updating bio: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating bio")));
      }
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Color(0xFFF28482),  // Using the app's custom color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Bio field
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Save button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Update the bio if valid
                    await _updateBio();
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

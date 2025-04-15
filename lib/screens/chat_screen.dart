import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  final String boardName;
  final messageController = TextEditingController();

  ChatScreen({required this.boardName});

  void sendMessage() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && messageController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection('boards')
          .doc(boardName)
          .collection('messages')
          .add({
        'text': messageController.text,
        'uid': user.uid,
        'timestamp': Timestamp.now(),
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseFirestore.instance
        .collection('boards')
        .doc(boardName)
        .collection('messages')
        .orderBy('timestamp', descending: false);

    return Scaffold(
      appBar: AppBar(title: Text(boardName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    return ListTile(
                      title: Text(data['text']),
                      subtitle: Text(data['timestamp'].toDate().toString()),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(controller: messageController),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}

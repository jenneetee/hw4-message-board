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
        'text': messageController.text.trim(),
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
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    final uid = data['uid'];
                    final messageText = data['text'];
                    final timestamp = data['timestamp'].toDate();

                    // Fetch user's full name based on UID
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) return SizedBox.shrink();

                        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;

                        if (userData == null || !userData.containsKey('first_name') || !userData.containsKey('last_name')) {
                          return ListTile(
                            title: Text(messageText),
                            subtitle: Text('Unknown user • $timestamp'),
                          );
                        }

                        final fullName = '${userData['first_name']} ${userData['last_name']}';

                        return ListTile(
                          title: Text(messageText),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sent by: $fullName"),
                              Text(timestamp.toString()),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

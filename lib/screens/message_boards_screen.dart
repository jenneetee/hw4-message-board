import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MessageBoardsScreen extends StatelessWidget {
  final List<Map<String, String>> boards = [
    {'name': 'Make-Up Tips', 'icon': '💄'},
    {'name': 'Gaming', 'icon': '🎮'},
    {'name': 'Random', 'icon': '🎲'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message Boards")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu', style: TextStyle(fontSize: 24))),
            ListTile(title: Text("Message Boards"), onTap: () {
              Navigator.pop(context);
            }),
            ListTile(title: Text("Profile"), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            }),
            ListTile(title: Text("Settings"), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
            }),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            leading: Text(board['icon']!, style: TextStyle(fontSize: 24)),
            title: Text(board['name']!),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ChatScreen(boardName: board['name']!),
              ));
            },
          );
        },
      ),
    );
  }
}

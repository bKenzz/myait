import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myait/screens/home/home.dart';
import 'package:myait/services/chat/chat_service.dart';
import 'package:myait/screens/home/main_navigation.dart';

class GroupChatsPage extends StatefulWidget {
  const GroupChatsPage({Key? key}) : super(key: key);

  @override
  State<GroupChatsPage> createState() => _GroupChatsPageState();
}

class _GroupChatsPageState extends State<GroupChatsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _chatName = '';
  String _chatImageUrl = '';
  String _chatDescription = '';
  List<String> _users = [];
  ChatService _chatService = ChatService();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(147, 196, 209, 100),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Chat Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a chat name';
                }
                return null;
              },
              onSaved: (value) {
                _chatName = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Chat Image URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a chat image URL';
                }
                return null;
              },
              onSaved: (value) {
                _chatImageUrl = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Users (usernames separated by commas)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter at least one user';
                }
                return null;
              },
              onSaved: (value) {
                _users = value!.split(',');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Chat Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a chat description';
                }
                return null;
              },
              onSaved: (value) {
                _chatDescription = value!;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Now you can use _chatName, _chatImageUrl, _users, and _chatDescription to create a new chat
                  // ...
                  await createChat();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainNavigation()),
                  );
                }
              },
              child: Text('Create Chat'),
            ),
          ],
        ),
      ),
    );
  }

  createChat() async {
    try {
      print('object');
      String chatType = _users.length == 1 ? 'dm' : 'group';

      await _chatService.create_Chatroom(_auth.currentUser!.uid, _users,
          chatType, _chatName, _chatDescription);
    } catch (e) {
      print('Failed to create chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create chat: $e')),
      );
    }
  }
}
      // Chat chat = Chat(
      //     chatRoomId: chatRoomId,
      //     participants: [currentEmail, ...otherUserIds],
      //     chatType: chatType,
      //     admins: [currentEmail],
      //     chatName: 'New Chat');

// Hex Color Codes
// #18363E rgb(24, 54, 62)
// #5F97AA rgb(95, 151, 170)
// #2D5F6E rgb(45, 95, 110)
// #3E88A5 rgb(62, 136, 165)
// #93C4D1 rgb(147, 196, 209)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/components/mybutton.dart';
import 'package:myait/screens/home/chat_page.dart';
import 'package:myait/screens/wrapper.dart';
import 'package:myait/services/auth.dart';
import 'package:myait/services/editprofile.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(147, 196, 209, 100),
        body: _buildUserList());
  }

//build a list of users

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('chats')
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList());
        }));
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    String chatId = document.id;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('chats').doc(chatId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        Map<String, dynamic> chatData =
            snapshot.data!.data()! as Map<String, dynamic>;
        // Use 'chatData' to build your widget
        // For example:
        return ListTile(
          title: Text(chatData['chatName']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  _auth.currentUser!.uid,
                  reciverUserId: chatId,
                  reciverUsername: chatData['chatName'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

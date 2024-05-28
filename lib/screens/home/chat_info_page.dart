import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatInfoPage extends StatefulWidget {
  final String chatId;

  ChatInfoPage({required this.chatId});

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getChatInfo();
  }

  Future<void> getChatInfo() async {
    DocumentSnapshot chatInfo = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();
    setState(() {
      data = chatInfo.data() as Map<String, dynamic>;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Info'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          Center(
              child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEEVrqp9eqAoNmzS0s8gjVGDxMBfBer68E_g&s'))),
          SizedBox(height: 10),
          ListTile(
            title: Text('Chat Name'),
            subtitle: Text('${data!['chatName']}'),
          ),
          ListTile(
            title: Text('Members'),
            subtitle: Text(
                '${data!['participants'] != null ? data!['participants'].join(' ') : 'No participants'}'),
          ),
          ListTile(
            title: Text('Admins'),
            subtitle: Text(
                '${data!['admins'] != null ? data!['admins'].join(', ') : 'No admins'}'),
          ),
          ListTile(
            title: Text('Chat Description'),
            subtitle: Text('${data!['chatdiscription']}'),
          ),
        ],
      ),
    );
  }
}

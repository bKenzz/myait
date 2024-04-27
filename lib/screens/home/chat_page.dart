import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/components/chat_bubble.dart';
import 'package:myait/components/mytextfield.dart';
import 'package:myait/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserId;
  final String reciverUsername;
  ChatPage(
      {super.key, required this.reciverUserId, required this.reciverUsername});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      print(_messageController);
      await _chatService.sendMessage(
          widget.reciverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(147, 196, 209, 100),
      appBar: AppBar(
        title: Text(widget.reciverUsername),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.reciverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
    String profileImageUrl = isCurrentUser
        ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
        : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

    // Set a cross alignment that matches the message bubble alignment.
    CrossAxisAlignment crossAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 20,
            ),
            SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: crossAlignment,
            children: [
              Text(isCurrentUser ? 'You' : widget.reciverUsername),
              ChatBubble(
                message: data['text'],
                timestamp: data["timestamp"],
                readStatus: false,
                messageType: 'default',
                forwarded: false,
                senderId: data['senderId'],
              ),
            ],
          ),
          if (isCurrentUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 20,
            ),
          ],
        ],
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Enter Message',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_upward),
          iconSize: 40,
          onPressed: () {
            sendMessage();
          },
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  ScrollController _scrollController = ScrollController();
  String currentChatRoomId = '';

  // bool _isAtBottom = true;
  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(_scrollListener);
  // }

  // void _scrollListener() {
  //   if (_scrollController.offset >=
  //           _scrollController.position.maxScrollExtent &&
  //       !_scrollController.position.outOfRange) {
  //     setState(() {
  //       _isAtBottom = true;
  //     });
  //   } else {
  //     setState(() {
  //       _isAtBottom = false;
  //       print(_isAtBottom);
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_scrollListener);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    List<String> ids = [widget.reciverUserId, _firebaseAuth.currentUser!.uid];
    ids.sort();
    currentChatRoomId = ids.join('_');
    return Scaffold(
      backgroundColor: Color.fromRGBO(147, 196, 209, 100),
      appBar: AppBar(
        title: Text(widget.reciverUsername),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _buildMessageInput(),
            ],
          ),
          // if (!_isAtBottom)
          //   Positioned(
          //     bottom: 50, // Adjust this value as needed
          //     right: 20, // Adjust this value as needed
          //     child: FloatingActionButton(
          //       child: Icon(Icons.arrow_downward),
          //       onPressed: _scrollToBottom,
          //     ),
          //   ),
        ],
      ),
    );
  }
//
//
//
//
//
//
//
//
//
//
//
//
//

  Future<void> sendMessage() async {
    bool isAtBottom = _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
    if (_messageController.text.isNotEmpty) {
      print(_messageController);
      await _chatService.sendMessage(
          widget.reciverUserId, _messageController.text);
      _messageController.clear();
    }
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
            controller: _scrollController,
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
    _scrollToBottom();
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
                editedStatus: data['editedStatus'],
                chatRoomId: currentChatRoomId,
                message: data['text'],
                timestamp: data["timestamp"],
                readStatus: false,
                messageType: 'default',
                forwarded: false,
                senderId: data['senderId'],
                id: document.id,
              )
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
    return Container(
      padding: EdgeInsets.all(8.0), // Add padding around the input bar
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      12.0), // Add horizontal padding inside the TextField
              decoration: BoxDecoration(
                color: Colors
                    .white, // Telegram uses a white or very light grey background
                borderRadius: BorderRadius.circular(
                    20.0), // Rounded corners for the TextField
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Enter Message',
                  border: InputBorder.none, // No border
                  hintStyle: TextStyle(
                      color: Colors.grey[400]), // Light grey color for hint
                ),
              ),
            ),
          ),
          SizedBox(width: 8), // Spacing between TextField and Button
          IconButton(
            icon: Icon(Icons.send), // The paper plane icon used by Telegram
            iconSize: 25,
            color: Colors.blue, // Telegram's icon is typically blue
            onPressed: () {
              sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

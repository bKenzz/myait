import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myait/components/chat_bubble.dart';
import 'package:myait/components/mytextfield.dart';
import 'package:myait/screens/home/chat_info_page.dart';
import 'package:myait/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserId;
  final String reciverUsername;

  ChatPage(String uid,
      {super.key, required this.reciverUserId, required this.reciverUsername});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<String, String> _usernames = {};
  Map<String, String> _pfps = {};
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ScrollController _scrollController = ScrollController();
  String currentChatRoomId = '';
  int messageCount = 0;
  ValueNotifier<String> replyMessage =
      ValueNotifier<String>('`32=21;`123x21fd');
  final ValueNotifier<String> current_message_id = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadUsernames();
  }

  Future<void> _loadUsernames() async {
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
    for (var doc in usersSnapshot.docs) {
      _usernames[doc.id] = (doc.data() as Map<String, dynamic>)['username'];
      _pfps[doc.id] = (doc.data() as Map<String, dynamic>)['profilePicture'];
    }
  }

  @override
  Widget build(BuildContext context) {
    currentChatRoomId = widget.reciverUserId;
    return FutureBuilder(
      future: _loadUsernames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            backgroundColor: Color.fromRGBO(147, 196, 209, 100),
            appBar: AppBar(
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatInfoPage(chatId: currentChatRoomId)),
                  );
                },
                child: Text(widget.reciverUsername),
              ),
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
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> sendMessage() async {
    // _scrollToBottom();
    bool isAtBottom = _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.reciverUserId,
          _messageController.text,
          replyMessage.value == '`32=21;`123x21fd'
              ? '`32=21;`123x21fd'
              : replyMessage.value);
      _messageController.clear();
    }
    replyMessage.value = '`32=21;`123x21fd';
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
          //HERHEHREHRERERERERE
          _firebaseAuth.currentUser!.uid,
          widget.reciverUserId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          if (snapshot.data!.docs.length > messageCount) {
            messageCount = snapshot.data!.docs.length;
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scrollToBottom();
            });
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
        ? _pfps[data['senderId']] ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKKOdmJz8Z2pDtYgFgR2u9spABvNNPKYYtGw&s'
        : _pfps[data['senderId']] ??
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

//hererererere profilePicture
    // Set a cross alignment that matches the message bubble alignment.
    CrossAxisAlignment crossAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    String username = _usernames[data['senderId']] ?? 'Unknown user';

    // _scrollToBottom();
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
              Text(isCurrentUser ? 'You' : username),
              ChatBubble(
                  onReply: onReply,
                  editedStatus: data['editedStatus'],
                  chatRoomId: currentChatRoomId,
                  message: data['text'],
                  timestamp: data["timestamp"],
                  readStatus: false,
                  messageType: 'default',
                  forwarded: false,
                  senderId: data['senderId'],
                  id: document.id,
                  replyMessage: data['replierId'] == '`32=21;`123x21fd'
                      ? ''
                      : data['replierId'])
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
      child: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: replyMessage,
            builder: (BuildContext context, String value, Widget? child) {
              return value != '`32=21;`123x21fd'
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.grey[200], // Change this as needed
                            child: Text(
                              value, // This will display the reply message
                              style: TextStyle(
                                  color: Colors.black), // Change this as needed
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            replyMessage.value =
                                '`32=21;`123x21fd'; // Clear the replyMessage
                          },
                        ),
                      ],
                    )
                  : Container();
            },
          ),
          Row(
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

  void onReply(String id, String chatRoomId, String message) {
    replyMessage.value = message;
    current_message_id.value = id;
  }
}

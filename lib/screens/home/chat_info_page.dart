import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/services/chat/chat_service.dart';
import 'package:myait/services/editprofile.dart';

class ChatInfoPage extends StatefulWidget {
  final String chatId;

  ChatInfoPage({required this.chatId});

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? data;
  bool isLoading = true;
  UserService _userService = UserService();
  TextEditingController addMemberController = TextEditingController();
  TextEditingController addAdminController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController chatNameController = TextEditingController();
  late String currentUserId;
  late Future<void> chatInfoFuture;
  ChatService _chatService = ChatService();
  late String profile;
  @override
  void initState() {
    super.initState();
    chatInfoFuture = getChatInfo();
  }

  Future<String> getUserInfo(String userId, String what) async {
    Future<DocumentSnapshot<Object?>> _document =
        _userService.getUserDatafromId(userId);
    DocumentSnapshot<Object?> snapshot = await _document;

    return snapshot[what].toString();
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
    if (data!['participants'] != null) {
      // existing code...
      profile = await getUsersProfile(data!['chatRoomId'], 'profilePicture');

      User? currentUser = await _userService.getCurrentUser();

      if (data!['participants'] != null) {
        List<String> participantNames = [];
        for (String userId in data!['participants']) {
          String name = await getUserInfo(userId, 'username');
          participantNames.add(name);
        }

        setState(() {
          data!['participantNames'] = participantNames;
        });
      }
      if (data!['admins'] != null) {
        List<String> adminNames = [];
        for (String userId in data!['admins']) {
          String name = await getUserInfo(userId, 'username');
          adminNames.add(name);
        }
        setState(() {
          data!['adminNames'] = adminNames;
          currentUserId = currentUser!.email!;
          print(currentUserId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: chatInfoFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(61, 90, 128, 1),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool isAdmin = data!['admins'].contains(currentUserId);
            print(data!['admins']);
            return Scaffold(
              backgroundColor: Color.fromRGBO(147, 196, 209, 100),
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text('Chat Info'),
              ),
              body: ListView(
                children: <Widget>[
                  SizedBox(height: 10),
                  Center(
                      child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(data!['chatType'] == 'group'
                        ? 'assets/' + data!['groupPicture']
                        : data!['participants'][0] == currentUserId
                            ? 'assets/' + profile
                            : 'assets/' + profile),
                  )),
                  SizedBox(height: 10),
                  isAdmin
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Chat Name'),
                                  content: TextField(
                                    controller: chatNameController,
                                    decoration: InputDecoration(
                                        hintText: "New chat name"),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        changeChatName();
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            tileColor: Colors.grey[700],
                            title: Text('Chat Name',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text('${data!['chatName']}',
                                style: TextStyle(color: Colors.white70)),
                          ),
                        )
                      : ListTile(
                          tileColor: Colors.grey[700],
                          title: Text('Chat Name',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text('${data!['chatName']}',
                              style: TextStyle(color: Colors.white70)),
                        ),
                  isAdmin
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Change Description'),
                                  content: TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                        hintText: "your new description"),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        changeChatDiscription();
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            tileColor: Color.fromRGBO(147, 196, 209, 100),
                            title: Text('Chat Description',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text('${data!['chatdiscription']}',
                                style: TextStyle(color: Colors.white70)),
                          ),
                        )
                      : ListTile(
                          tileColor: Color.fromRGBO(147, 196, 209, 100),
                          title: Text('Chat Description',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text('${data!['chatdiscription']}',
                              style: TextStyle(color: Colors.white70)),
                        ),
                  isAdmin
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Add Member'),
                                  content: TextField(
                                    controller: addMemberController,
                                    decoration: InputDecoration(
                                        hintText: "Enter new member's user id"),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        addMember();
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            tileColor: Colors.grey[600],
                            title: Text('Members',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                '${data!['participantNames'].join('\n')}',
                                style: TextStyle(color: Colors.white70)),
                          ),
                        )
                      : ListTile(
                          tileColor: Colors.grey[600],
                          title: Text('Members',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                              '${data!['participantNames'].join('\n')}',
                              style: TextStyle(color: Colors.white70)),
                        ),
                  isAdmin
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Add Admin'),
                                  content: TextField(
                                    controller: addAdminController,
                                    decoration: InputDecoration(
                                        hintText: "Enter new admin's user id"),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        addAdmin();
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            tileColor: Color.fromRGBO(147, 196, 209, 100),
                            title: Text('Admins',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                '${data!['admins'] != null ? data!['admins'].join('\n') : 'No admins'}',
                                style: TextStyle(color: Colors.white70)),
                          ),
                        )
                      : ListTile(
                          tileColor: Color.fromRGBO(147, 196, 209, 100),
                          title: Text('Admins',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                              '${data!['admins'] != null ? data!['admins'].join('\n') : 'No admins'}',
                              style: TextStyle(color: Colors.white70)),
                        ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  void addMember() {
    if (!data!['participants'].contains(addMemberController.text)) {
      _chatService.add_participant(
          addMemberController.text, data!['chatRoomId']);
    }
  }

  void addAdmin() {
    if (!data!['participants'].contains(addAdminController.text)) {
      if (!data!['admins'].contains(addAdminController.text)) {
        _chatService.add_admin(addAdminController.text, data!['chatRoomId']);
      }
    }
  }

  void changeChatName() {
    _chatService.change_chat_name(chatNameController.text, data!['chatRoomId']);
  }

  void changeChatDiscription() {
    _chatService.change_chat_discription(
        descriptionController.text, data!['chatRoomId']);
  }

  Future<String> getUsersProfile(String chatId, String what) async {
    UserService _userService = UserService();

    var currentUser = _auth.currentUser?.email;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    var participants;
    var otherPerson;
    var otherPersonId;
    var chatDocument = await _fireStore.collection('chats').doc(chatId).get();
    participants = chatDocument['participants'];

    if (participants[0] == currentUser) {
      otherPerson = participants[1];
    } else {
      otherPerson = participants[0];
    }
    otherPersonId = await _userService.userUsernametoId(otherPerson);
    var userDocument =
        await _fireStore.collection('users').doc(otherPersonId).get();
    var b = userDocument[what];
    return userDocument[what];
  }
}

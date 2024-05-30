import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chatRoomId;
  String chatName;
  List<String> participants;
  String? lastMessage;
  Timestamp? lastMessageTime;
  String chatType;
  List<String> admins;
  String? chatDiscription;
  String? groupPicture;
  String? lastMessageSender;
  Chat({
    required this.chatRoomId,
    required this.chatName,
    required this.admins,
    required this.participants,
    this.lastMessage,
    this.lastMessageSender,
    this.lastMessageTime,
    this.groupPicture,
    required this.chatType,
    this.chatDiscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupPicture': groupPicture,
      'lastMessageSender': lastMessageSender,
      'chatRoomId': chatRoomId,
      'chatName': chatName,
      'admins': admins,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'chatType': chatType,
      'chatdiscription': chatDiscription,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      groupPicture: map['groupPicture'],
      lastMessageSender: map['lastMessageSender'],
      chatRoomId: map['chatRoomId'],
      chatName: map['chatName'],
      admins: List<String>.from(map['admins']),
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['timestamp'],
      chatType: map['chatType'],
      chatDiscription: map['chatDiscription'],
    );
  }
}

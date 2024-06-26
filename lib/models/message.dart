import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String receiverId;
  String senderId;
  String text;
  Timestamp timestamp;
  bool readStatus;
  String messageType;
  Timestamp editedStatus;
  bool forwarded = false;
  String replierId;

  Message({
    required this.receiverId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.readStatus,
    required this.messageType,
    required this.editedStatus,
    required this.forwarded,
    required this.replierId,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'readStatus': readStatus,
      'messageType': messageType,
      'editedStatus': editedStatus,
      'forwarded': forwarded,
      'replierId': replierId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      text: map['text'],
      timestamp: map['timestamp'],
      readStatus: map['readStatus'],
      messageType: map['messageType'],
      editedStatus: map['editedStatus'],
      forwarded: map['forwarded'],
      replierId: map['replierId'],
    );
  }
}

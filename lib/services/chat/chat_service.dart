import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final DateTime timestamp = DateTime.now();

  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No current user found');
    }
    final String currentUserId = currentUser.uid;
    String? currentUserName;
    try {
      DocumentSnapshot userDocument =
          await _fireStore.collection('users').doc(currentUserId).get();
      final Map<String, dynamic>? userData =
          userDocument.data() as Map<String, dynamic>?;
      currentUserName = userData?['username'];

      if (currentUserName == null) {
        throw Exception('Username not found for user $currentUserId');
      }
    } catch (e) {
      print(e);
    }
    //create a new message
    print('AADASDASD');
    Message newMessage = Message(
        receiverId: receiverId,
        senderId: currentUserId,
        text: message,
        timestamp: timestamp,
        readStatus: false,
        messageType: 'All',
        editedStatus: false,
        forwarded: false);
    //construct chat room id from current user id and reaceiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

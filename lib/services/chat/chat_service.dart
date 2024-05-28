import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myait/models/message.dart';
import 'package:myait/models/mychat.dart';
import 'package:uuid/uuid.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message, replierId) async {
    final Timestamp timestamp = Timestamp.now();
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
    print(timestamp);

    Message newMessage = Message(
        receiverId: receiverId,
        senderId: currentUserId,
        text: message,
        timestamp: timestamp,
        readStatus: false,
        messageType: 'All',
        editedStatus: timestamp,
        forwarded: false,
        replierId: replierId);
    //construct chat room id from current user id and reaceiver id

    String chatRoomId = receiverId;
    await _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
    String chatRoomId = receiverId;

    return _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  editMessage(
    String chatRoomId,
    String messageId,
    String message,
  ) async {
    await _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({
      'text': message,
      'editedStatus': Timestamp.now(),
    });
  }

  delete_message(String chatRoomId, String messageId) async {
    await _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  create_Chatroom(String userId, List otherUserIds, String chatType,
      String chatName, String chatDiscription) async {
    try {
      var uuid = Uuid();
      String currentEmail = await getUsernameFromUserId(userId, 'email');
      String chatRoomId = uuid.v4();

      Chat chat = Chat(
          chatRoomId: chatRoomId,
          participants: [currentEmail, ...otherUserIds],
          chatType: chatType,
          admins: [currentEmail],
          chatName: chatName,
          chatDiscription: chatDiscription);

      await _fireStore.collection('users').doc(userId).update({
        'chats': FieldValue.arrayUnion([chatRoomId]),
      });
      await _fireStore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(chatRoomId)
          .set({'chatRoomId': chatRoomId});

      for (String otherUserId in otherUserIds) {
        DocumentSnapshot documentSnapshot = await _fireStore
            .collection('userUsernametoId')
            .doc(otherUserId)
            .get();
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String uid = data['uid'];

        await _fireStore.collection('users').doc(uid).update({
          'chats': FieldValue.arrayUnion([chatRoomId]),
        });
        await _fireStore.collection('chats').doc(chatRoomId).set(chat.toMap());
        await _fireStore
            .collection('users')
            .doc(uid)
            .collection('chats')
            .doc(chatRoomId)
            .set({'chatRoomId': chatRoomId});
      }
    } catch (e) {
      print('Failed to create chat room: $e');
      // Handle the error appropriately, e.g., show a SnackBar with the error message
    }
  }

  Future<String> getUsernameFromUserId(String userId, String element) async {
    DocumentSnapshot documentSnapshot =
        await _fireStore.collection('users').doc(userId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (!data.containsKey(element)) {
      throw Exception('Invalid username: $element');
    }
    return data[element];
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e);
    }
    throw Exception('Failed to upload image');
  }
}

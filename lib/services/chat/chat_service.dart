import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myait/models/message.dart';
import 'package:myait/models/mychat.dart';
import 'package:myait/services/editprofile.dart';
import 'package:uuid/uuid.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  UserService _userService = UserService();

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
    await _fireStore.collection('chats').doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': timestamp,
      'lastMessageSender': currentUserName,
    });
    DocumentSnapshot chatDocument =
        await _fireStore.collection('chats').doc(chatRoomId).get();
    List<String> participants = List<String>.from(chatDocument['participants']);

    for (var participant in participants) {
      String participantId = await _userService.userUsernametoId(participant);
      await _fireStore
          .collection('users')
          .doc(participantId)
          .collection('chats')
          .doc(chatRoomId)
          .set({'lastMessageTime': timestamp}, SetOptions(merge: true));
    }
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

      // Define the lists of images.
      List<String> dmImages = [
        'dm/download.jpg',
        'dm/gato(1).jpg',
        'dm/gato2.jpg',
        'dm/girl.jpg',
        'dm/girl(1).jpg',
        'dm/girl(2).jpg',
        'dm/images.jpg',
        'dm/man(1).jpg',
      ];
      List<String> groupImages = [
        'group/images (1).jpg',
        'group/images (2).jpg',
        'group/images (3).jpg',
        'group/images (4).jpg',
        'group/download (1).jpg',
        'group/images.jpg', /* add more images as needed */
      ];

      // Select a random image based on the chat type.
      String groupPicture;
      if (chatType == 'group') {
        groupPicture = groupImages[Random().nextInt(groupImages.length)];
      } else {
        groupPicture = groupImages[Random().nextInt(groupImages.length)];
      }

      Chat chat = Chat(
          chatRoomId: chatRoomId,
          groupPicture: groupPicture,
          participants: [currentEmail, ...otherUserIds],
          lastMessageTime: Timestamp.now(),
          lastMessage: '',
          lastMessageSender: '',
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

        if (!documentSnapshot.exists) {
          throw Exception('User $otherUserId does not exist');
        }

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
      DocumentSnapshot chatDocument =
          await _fireStore.collection('chats').doc(chatRoomId).get();
      List<String> participants =
          List<String>.from(chatDocument['participants']);

      for (var participant in participants) {
        String participantId = await _userService.userUsernametoId(participant);
        await _fireStore
            .collection('users')
            .doc(participantId)
            .collection('chats')
            .doc(chatRoomId)
            .set({'lastMessageTime': Timestamp.now()}, SetOptions(merge: true));
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

  add_participant(String participant, String chatRoomId) async {
    String? userId = await _userService.userUsernametoId(participant);
    await _fireStore.collection('users').doc(userId).update({
      'chats': FieldValue.arrayUnion([chatRoomId]),
    });

    await _fireStore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatRoomId)
        .set({
      'chatRoomId': chatRoomId,
    });

    await _fireStore.collection('chats').doc(chatRoomId).update({
      'chatType': 'group',
      'participants': FieldValue.arrayUnion([participant])
    });
  }

  add_admin(String participant, String chatRoomId) async {
    String? userId = await _userService.userUsernametoId(participant);

    await _fireStore.collection('chats').doc(chatRoomId).update({
      'admins': FieldValue.arrayUnion([participant])
    });
  }

  change_chat_name(
    String chatName,
    String chatRoomId,
  ) async {
    await _fireStore.collection('chats').doc(chatRoomId).update({
      'chatName': chatName,
    });
  }

  change_chat_discription(
    String chatDiscription,
    String chatRoomId,
  ) async {
    await _fireStore.collection('chats').doc(chatRoomId).update({
      'chatdiscription': chatDiscription,
    });
  }

  Future<String> getUsersProfile(String chatId, String what) async {
    UserService _userService = UserService();

    var currentUser = _firebaseAuth.currentUser?.email;
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

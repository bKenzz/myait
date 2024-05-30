import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String uid;
  String? username = 'MyAit User';
  String email;
  String? profilePicture;
  String? status = "Hello i use My Ait!";
  Timestamp? lastSeen = Timestamp.now();
  List<String>? chats;

  MyUser({
    required this.uid,
    required this.email,
    this.username = 'MyAit User',
    this.profilePicture,
    this.status = "Hello i use My Ait!",
    this.lastSeen,
    this.chats,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'status': status,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'chats': chats,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      profilePicture: map['profilePicture'],
      status: map['status'],
      lastSeen: map['lastSeen'] != null ? Timestamp.now() : null,
      chats: List<String>.from(map['chats']),
    );
  }

  void updateProfile(String parameter, String value) {
    _fireStore.collection('users').doc(this.uid).update({parameter: value});
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String uid;
  String? username = 'MyAit User';
  String email;
  String? profilePicture = 'DefaultProfilePicture.png';
  String? status = "Hello i use My Ait!";
  DateTime? lastSeen = DateTime.now();

  MyUser({
    required this.uid,
    required this.email,
    this.username = 'MyAit User',
    this.profilePicture = 'DefaultProfilePicture.png',
    this.status = "Hello i use My Ait!",
    this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'status': status,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      profilePicture: map['profilePicture'],
      status: map['status'],
      lastSeen: map['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'])
          : null,
    );
  }

  void updateProfile(String parameter, String value) {
    _fireStore.collection('users').doc(this.uid).update({parameter: value});
  }
}

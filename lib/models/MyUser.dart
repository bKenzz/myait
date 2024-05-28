import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String uid;
  String? username = 'MyAit User';
  String email;
  String? profilePicture =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';
  String? status = "Hello i use My Ait!";
  DateTime? lastSeen = DateTime.now();
  List<String>? chats;

  MyUser({
    required this.uid,
    required this.email,
    this.username = 'MyAit User',
    this.profilePicture =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
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
      lastSeen: map['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'])
          : null,
      chats: List<String>.from(map['chats']),
    );
  }

  void updateProfile(String parameter, String value) {
    _fireStore.collection('users').doc(this.uid).update({parameter: value});
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Get user data from Firestore
  Future<DocumentSnapshot> getUserData(String userId) async {
    return _firestore.collection('users').doc(userId).get();
  }

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    return _firestore.collection('users').doc(userId).update(data);
  }

  // Sign out
  Future<void> signOut() async {
    return _auth.signOut();
  }

  uploadUserProfilePicture(String userId, String url) async {
    return _firestore
        .collection('users')
        .doc(userId)
        .update({'profilePicture': url});
  }
}

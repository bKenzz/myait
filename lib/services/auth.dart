// ignore_for_file: prefer_const_constructors, unused_import, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myait/models/myuser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
// create user object based on firebase user

  MyUser? _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid, email: user.email!) : null;
  }

// sign in user

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//auth cahnge user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => user != null ? _userFromFirebaseUser(user) : null);
  }

// sign in with email and passwrod
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      MyUser uss = new MyUser(uid: user!.uid, email: user.email!);
      ;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with eamil and passwrod
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      MyUser uss = new MyUser(uid: user!.uid, email: user.email!);
      _fireStore
          .collection('users')
          .doc(user!.uid)
          .set(uss.toMap(), SetOptions(merge: true));
      _fireStore.collection('userUsernametoId').doc(email).set({
        'uid': user.uid,
        'userName': email,
      });
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // after creatheing the user createa a user document

  //google sign in
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);
      MyUser uss = new MyUser(uid: gUser!.id, email: gUser!.email);

      if (_fireStore.collection('users').doc(gUser!.id) == null) {
        _fireStore
            .collection('users')
            .doc(gUser!.id)
            .set(uss.toMap(), SetOptions(merge: true));
        _fireStore.collection('userUsernametoId').doc(gUser!.email).set({
          'uid': gUser!.id,
          'userName': gUser!.email,
        });
      }
      ;
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {}
  }
}

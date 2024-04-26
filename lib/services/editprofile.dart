import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myait/models/myuser.dart';
import 'package:myait/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:myait/database/userdb.dart';

class EditProfile {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  MyUser currentUser = Wrapper.currentUser;
  UserDb db = new UserDb();
  void editName(String name) {
    if (name.length < 12) {
      currentUser.updateProfile("username", name);
    }
  }

  void editAboutMe(String text) {
    currentUser.status = text;
  }
}

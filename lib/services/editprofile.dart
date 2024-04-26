import 'package:myait/models/myuser.dart';
import 'package:myait/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:myait/database/userdb.dart';

class EditProfile {
  MyUser currentUser = Wrapper.currentUser;
  UserDb db = new UserDb();
  void editName(String name) {
    if (name.length < 12) {
      currentUser.name = name;
      print(currentUser.email);
      db.editUserName(currentUser);
    }
  }

  void editAge(int age) {
    if (12 < age && age < 99) {
      currentUser.age = age;
    }

    void editAboutMe(String text) {
      currentUser.aboutMe = text;
    }
  }
}

import 'package:myait/models/userprofileinformation.dart';
import 'package:myait/screens/wrapper.dart';
import 'package:provider/provider.dart';

class EditProfile {
  Wrapper wrapperz = new Wrapper();

  void editName(String name) {
    UserProfileInformation currentUser = wrapperz.currentUserz;
    if (name.length < 12) {
      currentUser.name = name;
      print('HERRROEOORORO');
    }
  }

  // void editAge(int age) {
  //   if (12 < age && age < 99) {
  //     currentUser.age = age;
  //   }

  //   void editAboutMe(String text) {
  //     currentUser.aboutMe = text;
  //   }
  // }
}

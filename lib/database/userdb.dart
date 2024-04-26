import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myait/models/myuser.dart';

class UserDb extends GetxController {
  static UserDb get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  editUserName(MyUser user) {
    _db.collection('Users').add(user.toJson());
    _db.collection('Users').get();
  }
}

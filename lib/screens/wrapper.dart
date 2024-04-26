// ignore_for_file: prefer_const_constructors, unused_import, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:myait/models/myuser.dart';

import 'package:myait/screens/authenticate/authenticate.dart';
import 'package:myait/screens/authenticate/verify.dart';
import 'package:myait/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  static late MyUser currentUser;
  Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    // return home or auth widget
    if (user == null) {
      return Authenticate();
    } else {
      currentUser = user;
      return VerifyScreen();
    }
  }
}

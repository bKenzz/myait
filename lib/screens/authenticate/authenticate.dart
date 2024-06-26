// ignore_for_file: prefer_const_constructors, unused_import, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:myait/screens/authenticate/reg.dart';
import 'package:myait/screens/authenticate/signin.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Sign_in(toggleView: toggleView);
    } else {
      return Reg(toggleView: toggleView);
    }
  }
}

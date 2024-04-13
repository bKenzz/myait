import 'package:flutter/material.dart';
import 'package:myait/screens/authenticate/authenticate.dart';
import 'package:myait/screens/home/home.dart';
import 'package:myait/services/sign_in.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return home or auth widget
    return const SignIn();
  }
}

import 'package:flutter/material.dart';
import 'package:myait/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0.0,
        title: Text('Sign in to my appo'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: ElevatedButton(
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if (result == null) {
                print('no sign in');
              } else {
                print('signed in');
                print(result.uid);
              }
            },
            child: Text('Sign in anon'),
          )),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/components/mytextfield2.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  late String myError = '';
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      setState(() {
        myError = 'The reset password link has been send to your Email';
      });
    } catch (e) {
      setState(() {
        myError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(147, 196, 209, 100),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text('Enter your Email to get Password Reset Link'),
          SizedBox(height: 30),
          MyTextField2(
              controller: emailController,
              hintText: 'Your email',
              labeltext: 'Your Email',
              obscuretext: false,
              emptyvalidatortext: 'Your Email',
              iconn: Icons.email),
          MaterialButton(
            onPressed: () {
              passwordReset();
            },
            color: Color.fromRGBO(95, 151, 170, 0),
            child: Text('Reset Password'),
          ),
          SizedBox(
            height: 20,
          ),
          Text(myError,
              textAlign: TextAlign.center, style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }
}

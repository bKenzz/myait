import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/screens/home/home.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;
  late Timer _timerz;
  int _start = 15;
  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _timerz.cancel();
    super.dispose();
  }

  @override
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed((Duration(seconds: 15)));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e.toString());
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timerz = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? Home()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A verification email has been sent',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    child: Text('Resend a Link \n $_start'),
                  ),
                  TextButton(
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text('Cancel'))
                ],
              ),
            ),
          ),
        );
}

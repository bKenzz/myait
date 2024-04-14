// Hex Color Codes
// #18363E rgb(24, 54, 62)
// #5F97AA rgb(95, 151, 170)
// #2D5F6E rgb(45, 95, 110)
// #3E88A5 rgb(62, 136, 165)
// #93C4D1 rgb(147, 196, 209)
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myait/components/mytextfield.dart';

class Sign_in extends StatelessWidget {
  const Sign_in({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(147, 196, 209, 100),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                ),
                //logo
                CircleAvatar(
                  backgroundColor: Colors.brown.shade800,
                  backgroundImage: AssetImage('assets/images/ait.jpg'),
                  radius: 40,
                ),
                SizedBox(
                  height: 50,
                  width: 30,
                ),

                //welcome back
                Text('Welcome! please login to your account',
                    style: TextStyle(color: Colors.white, fontSize: 17)),
                SizedBox(
                  height: 30,
                  width: 30,
                ),

                //username textfield
                MyTextField(
                  hintText: '',
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                //password textfield
                MyTextField(
                  hintText: '',
                  obscureText: true,
                )

                //forgot password

                //sign in button

                // or countinue with

                //google

                //not a member? register now
              ],
            ),
          ),
        ));
  }
}

// Hex Color Codes
// #18363E rgb(24, 54, 62)
// #5F97AA rgb(95, 151, 170)
// #2D5F6E rgb(45, 95, 110)
// #3E88A5 rgb(62, 136, 165)
// #93C4D1 rgb(147, 196, 209)
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:myait/components/mybutton.dart';
import 'package:myait/components/square_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myait/components/mytextfield.dart';

import '../../components/mytextfield2.dart';
import '../../services/auth.dart';

class Sign_in extends StatefulWidget {
  const Sign_in({super.key});

  @override
  State<Sign_in> createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(147, 196, 209, 100),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
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
                    height: 10,
                    width: 30,
                  ),

                  //username textfield
                  MyTextField2(
                    controller: email,
                    hintText: 'Enter your email',
                    labeltext: 'Email',
                    iconn: Icons.email,
                    obscuretext: false,
                    emptyvalidatortext: "Enter an email",
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  //password textfield
                  MyTextField2(
                    controller: password,
                    hintText: 'Enter your Password',
                    labeltext: 'Password',
                    iconn: Icons.key,
                    obscuretext: true,
                    emptyvalidatortext: "Enter the password",
                  ),

                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Forgot Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 73, 173, 255),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  //sign in button
                  MyButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email.text, password.text);
                        if (result == null) {
                          setState(() => error =
                              'Could Not Sign In with Those Credentials');
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  // or countinue with

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  //google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      // google button
                      SquareTile(imagePath: 'assets/images/google.png'),

                      SizedBox(width: 25),

                      // apple button
                      SquareTile(imagePath: 'assets/images/google.png')
                    ],
                  ),
                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Register now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 173, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

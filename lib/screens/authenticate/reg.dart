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

class Reg extends StatefulWidget {
  final Function toggleView;

  const Reg({super.key, required this.toggleView});

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  String error = '';
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
                    height: 15,
                    width: 30,
                  ),

                  //welcome back
                  Text('Welcome! please login to your account',
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                  SizedBox(
                    height: 10,
                    width: 30,
                  ),

                  MyTextField2(
                    //username textfield
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
                  SizedBox(
                    height: 12,
                  ),
                  //confirm password
                  MyTextField2(
                    controller: confirmpassword,
                    hintText: 'Confirm your Password',
                    labeltext: 'Confirm Password',
                    iconn: Icons.key,
                    obscuretext: true,
                    emptyvalidatortext: "Confirm your Password",
                  ),

                  const SizedBox(height: 13),
                  //sign up button

                  MyButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (password.text != confirmpassword.text) {
                          setState(() => error = ' Passwords do not match');
                        } else {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email.text, password.text);
                          result = await _auth.signInWithEmailAndPassword(
                              email.text, password.text);
                          if (result == null) {
                            setState(() => error = ' The email is not valid');
                          }
                        }
                      }
                    },
                    buttontext: 'Sign Up',
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
                        'Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Color.fromARGB(255, 73, 173, 255), // Text Color
                        ),
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

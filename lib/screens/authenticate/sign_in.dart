// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myait/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0.0,
        title: Text('Sign in MyAit'),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Register'))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  decoration: InputDecoration(),
                ),
                SizedBox(height: 20),
                TextFormField(
                    validator: (val) => val!.length < 6
                        ? 'Enter a passwrod longer that 6 symbols'
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() =>
                            error = 'Could Not Sign In with Those Credentials');
                      }
                    }
                  },
                  child: Text('Sign in'),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 0.5,
                ),
                ElevatedButton(
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
                )
              ],
            ),
          )),
    );
  }
}

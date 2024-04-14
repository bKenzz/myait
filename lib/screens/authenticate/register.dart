// ignore_for_file: prefer_const_constructors, unused_import, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:myait/services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView});
  final Function toggleView;
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0.0,
        title: Text('Sign up to MyAit '),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In'))
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
                ),
                SizedBox(height: 20),
                TextFormField(
                    obscureText: true,
                    validator: (val) => val!.length < 6
                        ? 'Enter a passwrod longer that 6 symbols'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() => error = ' The email is not valid');
                      }
                    }
                  },
                  child: Text('Register'),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            ),
          )),
    );
  }
}

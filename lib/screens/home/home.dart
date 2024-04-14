// Hex Color Codes
// #18363E rgb(24, 54, 62)
// #5F97AA rgb(95, 151, 170)
// #2D5F6E rgb(45, 95, 110)
// #3E88A5 rgb(62, 136, 165)
// #93C4D1 rgb(147, 196, 209)
import 'package:flutter/material.dart';
import 'package:myait/services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(147, 196, 209, 100),
      appBar: AppBar(
        title: Text('AIT Schedule'),
        backgroundColor: Color.fromRGBO(45, 95, 110, 100),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            icon: Icon(
              Icons.person,
            ),
            label: const Text('logout'),
          ),
        ],
      ),
    );
  }
}

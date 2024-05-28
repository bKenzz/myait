// main_navigation.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myait/screens/home/GroupChatsPage.dart';
import 'package:myait/screens/home/home.dart';
import 'package:myait/screens/home/myprofile.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    Home(),
    MyProfile(),
    GroupChatsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 92, 103, 0.612), // background color
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'Chats'
            : _currentIndex == 1
                ? 'Profile'
                : 'Create Chats'),

        backgroundColor: Color.fromRGBO(90, 134, 148, 0.612), // app bar color
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: 'Create Chats')
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

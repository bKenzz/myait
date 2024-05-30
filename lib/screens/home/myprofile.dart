//61, 90, 128   Dark Blue - Ideal for: Header/Footer, Navigation Bar, Important Buttons (e.g., Submit, Confirm)
//152, 193, 217 Light - Blue Ideal for: Backgrounds, Button Hover States, Secondary Actions
//224, 251, 252 Very - Light Blue Ideal for: General Backgrounds, Off-state Toggle Buttons, Disabled Elements
//238, 108, 77  Orange - Ideal for: Call to Action Buttons, Warnings, Highlighted Icons
//41, 50, 65    Dark Charcoal - Ideal for: Text, Icons, Active States

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myait/services/editprofile.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var pickedFile;
  int ninjaLevel = 0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late User currentUser;
  DocumentSnapshot? userData;
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  UserService _userService = UserService();
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      currentUser = user;
      userData =
          await _fireStore.collection('users').doc(currentUser.uid).get();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(61, 90, 128, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            ninjaLevel += 1;
          });
        },
        backgroundColor: Colors.grey[800],
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(screenSize.width * 0.05,
            screenSize.height * 0.05, screenSize.width * 0.05, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: GestureDetector(
                onTap: () {
                  selectFile();
                },
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: userData != null
                      ? AssetImage('assets/' + userData!['profilePicture'])
                      : AssetImage('assets/images/default_profile_picture.jpg'),
                ),
              )),
              Divider(
                color: Colors.grey[800],
                height: 60.0,
              ),
              Text(
                'NAME',
                style: TextStyle(
                  color: Color.fromRGBO(152, 193, 217, 1),
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Change Name'),
                        content: TextField(
                          controller: nameController,
                          decoration:
                              InputDecoration(hintText: "Enter new name"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Submit'),
                            onPressed: () {
                              setState(() {
                                _userService.updateUserData(currentUser.uid, {
                                  'username': nameController.text,
                                });
                              });
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  userData != null ? userData!['username'] : 'Loading...',
                  style: TextStyle(
                    color: Color.fromRGBO(238, 108, 77, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width *
                        0.07, // Adjust the font size based on the screen size
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'ABOUT ME',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Change About Me'),
                        content: TextField(
                          controller: aboutMeController,
                          decoration:
                              InputDecoration(hintText: "Enter new about me"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Submit'),
                            onPressed: () {
                              setState(() {
                                _userService.updateUserData(currentUser.uid, {
                                  'status': aboutMeController.text,
                                });
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  userData != null ? userData!['status'] : 'Loading...',
                  style: TextStyle(
                    color: Colors.amberAccent[200],
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'Cookies',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '$ninjaLevel',
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.grey[400],
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    userData != null ? userData!['email'] : 'Loading...',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    try {
      final picker = ImagePicker();
      final result = await picker.pickImage(source: ImageSource.gallery);
      if (result == null) return;
      setState(() {
        pickedFile = File(result.path);
      });
    } catch (e) {
      print('Error in selectFile: $e');
    }
  }
}

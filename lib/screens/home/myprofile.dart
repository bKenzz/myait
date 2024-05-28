//61, 90, 128   Dark Blue - Ideal for: Header/Footer, Navigation Bar, Important Buttons (e.g., Submit, Confirm)
//152, 193, 217 Light - Blue Ideal for: Backgrounds, Button Hover States, Secondary Actions
//224, 251, 252 Very - Light Blue Ideal for: General Backgrounds, Off-state Toggle Buttons, Disabled Elements
//238, 108, 77  Orange - Ideal for: Call to Action Buttons, Warnings, Highlighted Icons
//41, 50, 65    Dark Charcoal - Ideal for: Text, Icons, Active States
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int ninjaLevel = 0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late User currentUser;
  DocumentSnapshot? userData;

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
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: userData != null
                      ? NetworkImage(userData!['profilePicture'])
                      : NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
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
              Text(
                userData != null ? userData!['username'] : 'Loading...',
                style: TextStyle(
                  color: Color.fromRGBO(238, 108, 77, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
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
              Text(
                userData != null ? userData!['status'] : 'Loading...',
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
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

  Future<void> updateUserProfilePicture(String url) async {
    await _fireStore.collection('users').doc(currentUser.uid).update({
      'profilePicture': url,
    });
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File file = File(image.path);
      try {
        // Upload to Firebase Storage
        await FirebaseStorage.instance
            .ref('uploads/${Path.basename(file.path)}')
            .putFile(file);

        // Once the upload is complete, update the user's profile picture URL
        String downloadURL = await FirebaseStorage.instance
            .ref('uploads/${Path.basename(file.path)}')
            .getDownloadURL();
        await updateUserProfilePicture(downloadURL);
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        print(e);
      }
    }
  }
}

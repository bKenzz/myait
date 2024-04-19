// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myait/services/auth.dart';

class MyTextField2 extends StatelessWidget {
  const MyTextField2(
      {super.key,
      this.controller,
      required this.hintText,
      required this.labeltext,
      required this.obscuretext,
      required this.emptyvalidatortext,
      required this.iconn});
  final controller;
  final String emptyvalidatortext;
  final String hintText;
  final bool obscuretext;
  final String labeltext;
  final IconData iconn;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: (val) => val!.isEmpty ? emptyvalidatortext : null,
        controller: controller,
        obscureText: obscuretext,
        decoration: InputDecoration(
            labelText: labeltext,
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 19, 20, 21),
              fontSize: 16,
            ),
            hintText: hintText,
            border: OutlineInputBorder(),
            prefixIcon: Icon(iconn),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 13, 13, 13))),
            // focusedBorder:
            //     OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            fillColor: Color.fromARGB(255, 222, 222, 222),
            filled: true),
      ),
    );
    ;
  }
}

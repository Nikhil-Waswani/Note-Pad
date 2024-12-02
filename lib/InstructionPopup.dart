// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'main.dart';
import 'package:flutter/material.dart';

Timer? gotoTimer;

class Instructionpopup extends StatefulWidget {
  const Instructionpopup({super.key});

  @override
  _InstructionpopupState createState() => _InstructionpopupState();
}

class _InstructionpopupState extends State<Instructionpopup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ClassHelper());
  }
}

class ClassHelper extends StatefulWidget {
  const ClassHelper({super.key});

  @override
  ClassHelperState createState() => ClassHelperState();
}

class ClassHelperState extends State<ClassHelper> {
  @override
  void initState() {
    super.initState();

    // Delay the navigation slightly to allow the widget to initialize
    gotoTimer = Timer(Duration(seconds: 5), () {
      gotoNotePad();
    });
  }

  void gotoNotePad() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
            child: Container(
      height: screenHeight * 0.9,
      width: screenWidth * 0.9,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
        border: Border.all(
          color: Colors.teal,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Text(
            "Instructions", // Heading
            style: TextStyle(
              fontSize: 24, // Larger font size for the heading
              fontWeight: FontWeight.bold,
              color: Colors.teal[900], // Dark teal for emphasis
            ),
          ),
          SizedBox(height: 16), // Space below the heading
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Use plus button to add a new Note",
                style: TextStyle(fontSize: 15, color: Colors.teal[800]),
              ),
              SizedBox(height: 8),
              Text(
                "Click eye button to check existing Notes",
                style: TextStyle(fontSize: 15, color: Colors.teal[800]),
              ),
              SizedBox(height: 8),
              Text(
                "Do Not Copy Paste words in the text field",
                style: TextStyle(fontSize: 15, color: Colors.teal[800]),
              ),
              SizedBox(height: 8),
              Text(
                "Do not use suggested words by Keyboard",
                style: TextStyle(fontSize: 15, color: Colors.teal[800]),
              ),
              SizedBox(height: 8),
              Text(
                "Notes can't be editable, So be careFul",
                style: TextStyle(fontSize: 15, color: Colors.teal[800]),
              ),
              SizedBox(height: 8),
              Text(
                "Sometimes it is good to use slowly the Note Pad for better reponse",
                style: TextStyle(fontSize: 15, color: Colors.teal[800]),
              )
            ],
          )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (gotoTimer != null) {
                  gotoTimer?.cancel();
                }
                gotoNotePad();
              },
              child: Text("OK"))
        ],
      ),
    )));
  }
}

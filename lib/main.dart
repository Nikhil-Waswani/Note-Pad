// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, empty_catches, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_child_properties_last

import 'dart:async';
import 'package:easyo/InstructionPopup.dart';
import 'package:flutter/material.dart';
import 'Stack.dart';
import 'notes.dart';

final TextEditingController controller = TextEditingController();
StackUndo initialStack = StackUndo();
StackUndo stackundo = StackUndo();
StackUndo stackBackspace = StackUndo();
String previousString = "";

void main() {
  runApp(Instructionpopup());
}

void containerSetting() async {
  containers = [];
  containers = await readListFromFile();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int cursorPosition = 0;
  Timer? _backspace;
  String removedData = "";

  @override
  void initState() {
    super.initState();
    containerSetting();

    controller.addListener(() {
      int currentLength = controller.text.length;
      cursorPosition = controller.selection.baseOffset;
      if (previousString.length < currentLength) {
        stackundo.top = null;
        int tempsize = (initialStack.top == null) ? 0 : initialStack.top!.size;
        int topLength =
            (initialStack.top == null) ? 0 : initialStack.top!.data.length;
        if ((controller.text[cursorPosition - 1] != " ") &&
            (initialStack.top?.data != "%removed") &&
            (cursorPosition == tempsize + topLength + 1)) {
          initialStack.push(
              (initialStack.pop() + controller.text[cursorPosition - 1]),
              tempsize);
        } else {
          initialStack.push(
              controller.text[cursorPosition - 1], cursorPosition - 1);
        }
      } else if (previousString.length > currentLength) {
        stackundo.top = null;
        _backspace?.cancel();
        removedData = previousString[cursorPosition] + removedData;

        _backspace = Timer(const Duration(milliseconds: 400), () {
          initialStack.push("%removed", 0);
          stackBackspace.push(removedData, cursorPosition);
          removedData = "";
        });
      }
      previousString = controller.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Write(),
    );
  }
}

class Write extends StatefulWidget {
  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes Pad",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade300,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.06,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Enter text here...',
                    prefixIcon: const Icon(Icons.message_outlined),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      try {
                        if (initialStack.top!.data == "%removed") {
                          int tempsize = stackBackspace.top!.size;
                          controller.text =
                              controller.text.substring(0, tempsize) +
                                  stackBackspace.pop() +
                                  controller.text.substring(tempsize);
                          initialStack.pop();
                        } else {
                          controller.text = stackundo.undo();
                        }
                      } catch (e) {}
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color.fromARGB(255, 243, 26, 26),
                      iconColor: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.undo),
                        SizedBox(width: 3),
                        Text(
                          'Undo',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      controller.text = stackundo.redo();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.green[300],
                      iconColor: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Redo',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(width: 3),
                        Icon(Icons.redo_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 90,
            right: 20,
            child: Tooltip(
              message: 'View saved notes',
              child: FloatingActionButton(
                onPressed: () {
                  redoNotesStack.top = null;
                  notesStack.top = null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notes()),
                  );
                },
                backgroundColor: Colors.teal.shade300,
                child: const Icon(Icons.remove_red_eye_outlined),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Tooltip(
              message: 'Add a new note',
              child: FloatingActionButton(
                onPressed: () {
                  addNote(controller.text);
                  controller.text = previousString = '';
                  initialStack.top = null;
                  stackBackspace.top = null;
                  stackundo.top = null;
                },
                backgroundColor: Colors.teal.shade300,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'stack.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

List<Map<String, dynamic>> containers = [];
StackUndo notesStack = StackUndo();
StackUndo redoNotesStack = StackUndo();

void addNote(String text) async {
  if (text.isNotEmpty) {
    containers.add({'text': text}); // Add new note to the list
    await saveListToFile(containers); // Save the updated list to file
  }
}

class _NotesState extends State<Notes> {
  @override
  void initState() {
    super.initState();
    loadContainers(); // Load data when the screen is first created
  }

  // Function to load containers from the file
  void loadContainers() async {
    List<Map<String, dynamic>> data = await readListFromFile();
    setState(() {
      containers = data; // Update the containers list and trigger UI rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Notes",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal.shade300,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Scrollable Notes Section
              Expanded(
                child: containers.isEmpty
                    ? Center(
                        child: Text('No notes available')) // Message if empty
                    : ListView.builder(
                        itemCount: containers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.teal[100],
                                border: Border.all(
                                  color: Colors.teal,
                                  width: 4.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(containers[index]["text"]),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded),
                                    onPressed: () {
                                      notesStack.push(
                                          containers[index]["text"], 0);
                                      setState(() {
                                        containers.removeAt(index);

                                        saveListToFile(
                                            containers); // Save updated list to file
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Buttons (Undo & Redo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (notesStack.top != null) {
                        setState(() {
                          addNote(notesStack.pop());
                          redoNotesStack.push("removed%", 0);
                        });
                      }
                    },
                    child: Text(
                      "Undo",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (redoNotesStack.top != null) {
                        setState(() {
                          notesStack.push(containers.last['text'], 0);
                          containers.removeLast();
                          saveListToFile(
                              containers); // Save updated list to file
                          redoNotesStack.pop();
                        });
                      }
                    },
                    child: Text(
                      "Redo",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.greenAccent.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Save the updated list to the file (replaces existing data)
Future<void> saveListToFile(List<Map<String, dynamic>> newData) async {
  final file = await _getLocalFile(); // Get the file path
  final jsonString = jsonEncode(newData); // Convert data to JSON
  await file.writeAsString(jsonString); // Overwrite file with new data
}

// Get the file path for saving data
Future<File> _getLocalFile() async {
  final directory =
      await getApplicationDocumentsDirectory(); // App's local storage
  return File('${directory.path}/my_data.json'); // File path
}

// Read the list from the file
Future<List<Map<String, dynamic>>> readListFromFile() async {
  try {
    final file = await _getLocalFile(); // Get the file path
    String jsonString = await file.readAsString(); // Read the file
    List<dynamic> jsonList = jsonDecode(jsonString); // Decode JSON string
    return jsonList
        .cast<Map<String, dynamic>>(); // Convert to List<Map<String, dynamic>>
  } catch (e) {
    return []; // Return an empty list if there's an error
  }
}

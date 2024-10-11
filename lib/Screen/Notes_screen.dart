import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> notes = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Load saved notes when the app starts
  }

  // Load notes from SharedPreferences
  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  // Save notes to SharedPreferences
  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', notes);
  }

  void _addNote() {
    String noteText = _textController.text;
    if (noteText.isNotEmpty) {
      setState(() {
        notes.add(noteText);
      });
      _saveNotes(); // Save notes after adding
      _textController.clear();
    }
  }

  void _deleteNoteAtIndex(int index) {
    setState(() {
      notes.removeAt(index);
    });
    _saveNotes(); // Save notes after deletion
  }

  void _goToStudyAssistantScreen() {
    String combinedNotes = notes.join(" ");
    Navigator.pushNamed(
      context,
      '/studyAssistant',
      arguments: combinedNotes, // Pass the combined notes as arguments
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Enter your note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: notes.isEmpty
                      ? Center(child: Text('No notes yet. Add a note!'))
                      : ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                  notes[index],
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNoteAtIndex(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          // Positioned button to add a note
          Positioned(
            bottom: 80, // Positioned 80 pixels from the bottom to make space for the new button
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _addNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Add Note', style: TextStyle(fontSize: 16)),
            ),
          ),
          // Positioned button to navigate to StudyAssistantScreen
          Positioned(
            bottom: 20, // Positioned at the bottom
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _goToStudyAssistantScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Go to Study Assistant', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

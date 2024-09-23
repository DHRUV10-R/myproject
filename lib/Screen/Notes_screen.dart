import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> notes = [];
  final TextEditingController _textController = TextEditingController();

  void _addNote() {
    String noteText = _textController.text;
    if (noteText.isNotEmpty) {
      setState(() {
        notes.add(noteText);
      });
      _textController.clear();
    }
  }

  void _deleteNoteAtIndex(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void _goToStudyAssistant() {
    if (notes.isNotEmpty) {
      String allNotes = notes.join(" "); // Concatenating all notes into one string
      Navigator.pushNamed(context, '/studyAssistant', arguments: allNotes);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add some notes first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter your note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Add Note'),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToStudyAssistant,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Generate Summary'),
            ),
          ],
        ),
      ),
    );
  }
}

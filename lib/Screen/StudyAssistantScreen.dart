import 'package:flutter/material.dart';

import '../services/api_sevices.dart';

class StudyAssistantScreen extends StatefulWidget {
  @override
  _StudyAssistantScreenState createState() => _StudyAssistantScreenState();
}

class _StudyAssistantScreenState extends State<StudyAssistantScreen> {
  String? _summary = "AI Summary will appear here...";
  bool _isLoading = false;

  final String _apiKey = 'https://api.openai.com/v1/completions'; // Place your actual API key here

  void _generateSummary(String notes) async {
    setState(() {
      _isLoading = true;
      _summary = '';
    });

    String? summary = await getSummary(_apiKey);

    setState(() {
      _isLoading = false;
      _summary = summary ?? 'Failed to generate summary.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final String notes = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Study Assistant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Original Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  notes,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _generateSummary(notes);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('Generate AI Summary'),
            ),
            SizedBox(height: 20),
            Text(
              _summary!,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

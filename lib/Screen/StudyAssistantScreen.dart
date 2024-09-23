import 'package:flutter/material.dart';
import '../services/api_sevices.dart';


class StudyAssistantScreen extends StatefulWidget {
  @override
  _StudyAssistantScreenState createState() => _StudyAssistantScreenState();
}

class _StudyAssistantScreenState extends State<StudyAssistantScreen> {
  String aiSummary = "AI Summary will appear here...";
  bool isLoading = false;
  final ApiService apiService = ApiService(); // Create an instance of ApiService

  // Function to call AI summary API
  Future<void> _generateSummary(String notes) async {
    setState(() {
      isLoading = true;
    });

    try {
      final summary = await apiService.generateSummary(notes);
      setState(() {
        aiSummary = summary;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        aiSummary = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String notes = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Study Assistant'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Original Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              notes,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _generateSummary(notes);  // Call the API to generate summary
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 68, 255, 84),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Generate AI Summary'),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            Text(
              aiSummary,  // Display the AI summary
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

//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

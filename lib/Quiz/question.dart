import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String category;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.category,
  });

  // Factory constructor to create a Question object from a Map (JSON)
  factory Question.fromMap(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      category: json['category'] as String,
    );
  }
}

Future<List<Question>> loadQuestions() async {
  // Load the JSON file from assets
  final String jsonString = await rootBundle.loadString('assets/questions.json');
  // Decode the JSON string into a list of dynamic objects
  final List<dynamic> jsonList = json.decode(jsonString);
  // Map the JSON objects to a list of Question objects
  return jsonList.map((jsonItem) => Question.fromMap(jsonItem as Map<String, dynamic>)).toList();
}

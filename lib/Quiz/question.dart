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

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['questionText'],
      options: List<String>.from(map['options']),
      correctOptionIndex: map['correctOptionIndex'],
      category: map['category'],
    );
  }
}

Future<List<Question>> loadQuestions() async {
  final String jsonString = await rootBundle.loadString('assets/questions.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((jsonItem) => Question.fromMap(jsonItem)).toList();
}

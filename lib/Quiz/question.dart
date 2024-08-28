class Question {
  String questionText;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  // Method to create a Question from a map (for dynamic loading)
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      questionText: data['questionText'] as String,
      options: List<String>.from(data['options'] as List<dynamic>),
      correctOptionIndex: data['correctOptionIndex'] as int,
    );
  }
}

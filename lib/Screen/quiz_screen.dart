import 'package:flutter/material.dart';
import '../Quiz/question.dart';


class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;

  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final List<Map<String, dynamic>> questionData = [
      {
        'questionText': 'What is the capital of France?',
        'options': ['Paris', 'London', 'Berlin', 'Madrid'],
        'correctOptionIndex': 0,
      },
      {
        'questionText': 'Which planet is known as the Red Planet?',
        'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
        'correctOptionIndex': 1,
      },
      {
        'questionText': 'Who wrote "Hamlet"?',
        'options': [
          'Charles Dickens',
          'Mark Twain',
          'William Shakespeare',
          'Jane Austen'
        ],
        'correctOptionIndex': 2,
      },
      // Add more questions here or fetch from an external source
    ];

    setState(() {
      _questions = questionData.map((q) => Question.fromMap(q)).toList();
    });
  }

  void _answerQuestion(int selectedIndex) {
    if (_questions[_currentQuestionIndex].correctOptionIndex == selectedIndex) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _isQuizFinished = true;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isQuizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _questions.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isQuizFinished
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Quiz Finished!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your Score: $_score/${_questions.length}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _resetQuiz,
                        child: Text('Restart Quiz'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _questions[_currentQuestionIndex].questionText,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      ..._questions[_currentQuestionIndex].options.map((option) {
                        int index = _questions[_currentQuestionIndex].options.indexOf(option);
                        return ElevatedButton(
                          onPressed: () => _answerQuestion(index),
                          child: Text(option),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}

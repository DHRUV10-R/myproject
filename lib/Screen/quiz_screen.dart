import 'dart:async'; 
import 'package:flutter/material.dart';
import '../Quiz/question.dart'; // Import the Question class

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  List<Question> _questions = [];
  bool _isAnswerSelected = false;
  int? _selectedOptionIndex;
  Timer? _timer;
  int _remainingTime = 10; // Timer duration for each question
  bool _show50_50 = false; // To track if the 50-50 lifeline is used
  List<int> _disabledOptions = []; // Tracks disabled options for 50-50 lifeline

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Load questions when the widget is initialized
    _startTimer(); // Start the timer when the widget is initialized
  }

  // Load questions from the asset file
  Future<void> _loadQuestions() async {
    final List<Question> questions = await loadQuestions();
    if (mounted) {
      setState(() {
        _questions = questions; // Assign loaded questions to _questions
      });
    }
  }

  @override
  void dispose() {
    // Cancel timers or stop any async operations
    _timer?.cancel();
    super.dispose();
  }

  // Start or restart the timer
  void _startTimer() {
    _remainingTime = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        _skipQuestion();
      } else {
        if (mounted) {
          setState(() {
            _remainingTime--;
          });
        }
      }
    });
  }

  // Stop the timer
  void _stopTimer() {
    _timer?.cancel();
  }

  // Handle when an answer is selected
  void _answerQuestion(int selectedIndex) {
    _stopTimer();
    setState(() {
      _isAnswerSelected = true;
      _selectedOptionIndex = selectedIndex;

      if (_questions[_currentQuestionIndex].correctOptionIndex == selectedIndex) {
        _score++;
      }

      Future.delayed(Duration(seconds: 1), () {
        _moveToNextQuestion();
      });
    });
  }

  // Skip the current question when time runs out or "Skip" is used
  void _skipQuestion() {
    _stopTimer();
    setState(() {
      _moveToNextQuestion();
    });
  }

  // Reset quiz logic
  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isQuizFinished = false;
      _isAnswerSelected = false;
      _show50_50 = false;
      _disabledOptions = [];
      _questions.shuffle(); // Shuffle again when restarting the quiz
      _startTimer(); // Restart the timer
    });
  }

  // Move to the next question and restart the timer
  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswerSelected = false;
        _selectedOptionIndex = null;
        _disabledOptions.clear();
        _startTimer(); // Restart the timer for the next question
      });
    } else {
      setState(() {
        _isQuizFinished = true;
        _stopTimer(); // Stop the timer when quiz is finished
      });
    }
  }

  // 50-50 Lifeline to disable two wrong options
  void _use5050Lifeline() {
    if (!_show50_50) {
      setState(() {
        _show50_50 = true;
        int correctIndex = _questions[_currentQuestionIndex].correctOptionIndex;
        List<int> incorrectIndices = [];

        for (int i = 0; i < _questions[_currentQuestionIndex].options.length; i++) {
          if (i != correctIndex) incorrectIndices.add(i);
        }

        incorrectIndices.shuffle();
        _disabledOptions = incorrectIndices.take(2).toList(); // Disable 2 wrong options
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 205, 236),
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
                      // Progress Bar
                      LinearProgressIndicator(
                        value: (_currentQuestionIndex + 1) / _questions.length,
                      ),
                      SizedBox(height: 20),
                      // Timer
                      Text(
                        'Time Remaining: $_remainingTime seconds',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      SizedBox(height: 20),
                      // Question Category and Text
                      Text(
                        'Category: ${_questions[_currentQuestionIndex].category}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _questions[_currentQuestionIndex].questionText,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      ..._questions[_currentQuestionIndex].options.map((option) {
                        int index = _questions[_currentQuestionIndex].options.indexOf(option);
                        // ignore: unused_local_variable
                        bool isCorrect = _questions[_currentQuestionIndex].correctOptionIndex == index;

                        return ElevatedButton(
                          onPressed: (_isAnswerSelected || _disabledOptions.contains(index))
                              ? null
                              : () => _answerQuestion(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isAnswerSelected
                                ? (index == _questions[_currentQuestionIndex].correctOptionIndex
                                    ? Colors.green
                                    : (index == _selectedOptionIndex ? Colors.red : null))
                                : null, // Show green for correct, red for wrong
                          ),
                          child: Text(option),
                        );
                      }).toList(),
                      SizedBox(height: 20),
                      // Lifelines
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _show50_50 ? null : _use5050Lifeline,
                            child: Text('50-50 Lifeline'),
                          ),
                          ElevatedButton(
                            onPressed: _skipQuestion,
                            child: Text('Skip Question'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

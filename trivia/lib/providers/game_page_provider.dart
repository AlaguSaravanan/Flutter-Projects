import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;
  List? questions;
  int _currentQuestionCount = 0;
  int _correctCount = 0;
  final String difficultyLevel;
  final String? category; // Nullable category

  final HtmlUnescape _unescape = HtmlUnescape();
  BuildContext context;

  GamePageProvider({
    required this.context,
    required this.difficultyLevel,
    this.category,
  }) {
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    _getQuestionsFromAPI();
  }

  Future<void> _getQuestionsFromAPI() async {
    Map<String, dynamic> queryParameters = {
      'amount': _maxQuestions,
      'type': 'boolean',
      'difficulty': difficultyLevel,
    };

    // Add category to query only if it's not null and difficulty is Easy
    if (difficultyLevel.toLowerCase() == 'easy' && category != null) {
      queryParameters['category'] = category!;
    }

    var _response = await _dio.get(
      '',
      queryParameters: queryParameters,
    );

    var _data = jsonDecode(_response.toString());
    questions = (_data['results'] as List).map((question) {
      return {
        ...question,
        'question': _unescape.convert(question['question']),
        'category': _unescape.convert(question['category']),
      };
    }).toList();
    notifyListeners();
  }

  String getCurrentQuestionText() {
    return questions![_currentQuestionCount]['question'];
  }

  Future<void> answerQuestion(String _answer) async {
    bool isCorrect =
        questions![_currentQuestionCount]['correct_answer'] == _answer;
    _correctCount += isCorrect ? 1 : 0;
    _currentQuestionCount++;
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          title: Icon(
            isCorrect ? Icons.check_circle : Icons.cancel_sharp,
            color: Colors.white,
          ),
        );
      },
    );
    await Future.delayed(
      const Duration(seconds: 1),
    );
    Navigator.pop(context);
    if (_currentQuestionCount == _maxQuestions) {
      endGame();
    } else {
      notifyListeners();
    }
  }

  Future<void> endGame() async {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Results!',
                style: TextStyle(fontSize: 26, color: Colors.white,fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Go back to the start page
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Score: $_correctCount/ $_maxQuestions',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}

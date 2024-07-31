import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spell_it/views/results_screen.dart';

import '../models/score.dart';

class Game extends StatelessWidget {
  final String levelName;
  final List<Map<String, String>> questions;
  final List<dynamic> gameScoreList;
  final Score gameScore;
  final Function(int, int)? onLevelComplete;

  Game({
    required this.levelName,
    required this.questions,
    required this.gameScoreList,
    required this.gameScore,
    this.onLevelComplete,
  });

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      levelName: levelName,
      questions: questions,
      gameScoreList: gameScoreList,
      gameScore: gameScore,
      onLevelComplete: onLevelComplete,
    );
  }
}

class GameScreen extends StatefulWidget {
  final String levelName;
  final List<Map<String, String>> questions;
  final List<dynamic> gameScoreList;
  final Score gameScore;
  final Function(int, int)? onLevelComplete;

  GameScreen({
    required this.levelName,
    required this.questions,
    required this.gameScoreList,
    required this.gameScore,
    this.onLevelComplete,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentQuestionIndex = 0;
  TextEditingController answerController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts(); // كائن لتحويل النص إلى كلام

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("en-US"); // تعيين اللغة إلى الإنجليزية
    if (widget.questions.isNotEmpty) {
      _speakWord(widget.questions[currentQuestionIndex]['en'] ?? '');
    }
  }

  void _speakWord(String word) async {
    await _flutterTts.speak(word);
  }

  void _checkAnswer() {
    String correctAnswer = widget.questions[currentQuestionIndex]['en'] ?? '';
    String userAnswer = answerController.text.trim().toLowerCase();

    if (userAnswer == correctAnswer) {
      setState(() {
        widget.gameScore.correctAnswers += 1;
      });
    }
    setState(() {
      widget.gameScore.totalQuestions += 1;
    });

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex += 1;
        answerController.clear();
        _speakWord(widget.questions[currentQuestionIndex]['en'] ?? '');
      });
    } else {
      _completeLevel();
    }
  }

  void _completeLevel() {
    if (widget.onLevelComplete != null) {
      widget.onLevelComplete!(
          widget.gameScore.totalQuestions, widget.gameScore.correctAnswers);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          totalQuestions: widget.gameScore.totalQuestions,
          correctAnswers: widget.gameScore.correctAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.questions[currentQuestionIndex]['ar'] ?? '',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _speakWord(
                  widget.questions[currentQuestionIndex]['en'] ?? ''),
              child: Text('Read Word'),
            ),
            TextField(
              style: TextStyle(color: Colors.pink, fontSize: 30),
              controller: answerController,
              decoration: InputDecoration(
                labelText: 'أدخل إجابتك',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('تحقق من الإجابة'),
            ),
          ],
        ),
      ),
    );
  }
}

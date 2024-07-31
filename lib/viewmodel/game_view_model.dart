import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/level.dart';
import '../models/score.dart';

import '../services/game_data.dart';
import '../views/game.dart';
import '../views/results_screen.dart'; // استيراد ResultsScreen

class GameViewModel extends ChangeNotifier {
  List<Level> levels = [
    Level(name: 'المستوى 1', number: 1, color: Colors.blue),
    Level(name: 'المستوى 2', number: 2, color: Colors.green),
    Level(name: 'المستوى 3', number: 3, color: Colors.red),
  ];

  List<bool> levelUnlocked = [true, false, false];
  List<dynamic> gameScoreList = [];
  late Score gameScore;

  List<Map<String, String>> questions = [];
  int currentQuestionIndex = 0;
  final TextEditingController answerController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  GameViewModel() {
    _loadLevelUnlockedStatus();
    _loadScores();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
  }

  Future<void> _loadLevelUnlockedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? levelStatus = prefs.getStringList('levelUnlocked');
    if (levelStatus != null) {
      levelUnlocked = levelStatus.map((e) => e == 'true').toList();
    } else {
      levelUnlocked = [true, false, false]; // الحالة الافتراضية
    }
    notifyListeners();
  }

  // void _handleLevelCompletion(int totalQuestions, int correctAnswers) async {
  //   double percentage = (correctAnswers / totalQuestions) * 100;
  //   int currentLevelIndex = levels.indexWhere((l) => l.name == gameScore.level);

  //   if (percentage >= 90 && currentLevelIndex + 1 == levels.length) {
  //     // إعادة تعيين المستويات إلى الحالة الافتراضية
  //     _resetLevelsToDefault();
  //   } else if (percentage >= 90 && currentLevelIndex + 1 < levels.length) {
  //     levelUnlocked[currentLevelIndex + 1] = true;
  //     await _saveLevelUnlockedStatus();
  //   }
  // }

  void _resetLevelsToDefault() async {
    levelUnlocked = [true, false, false];
    await _saveLevelUnlockedStatus();
    notifyListeners();
  }

  Future<void> _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gameScoreList = [];
    for (var level in levels) {
      String? jsonString = prefs.getString(level.name);
      if (jsonString != null) {
        List<dynamic> scores = jsonDecode(jsonString);
        gameScoreList.addAll(scores);
      }
    }
    notifyListeners();
  }

  void goToGame(BuildContext context, Level level) async {
    if (!levelUnlocked[level.number - 1]) {
      _showLevelLockedDialog(context);
      return;
    }

    GameData gameData = GameData(levelName: level.name);
    await gameData.getQuestions();

    if (gameData.questions == null || gameData.questions!.isEmpty) {
      _showInvalidQuestionDialog(context);
      return;
    }

    gameScore = Score(level: level.name, totalQuestions: 0, correctAnswers: 0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Game(
          levelName: level.name,
          questions: gameData.questions!
              .map((e) => {
                    'ar': e['ar']?.toString() ?? '',
                    'en': e['en']?.toString() ?? ''
                  })
              .toList(),
          gameScoreList: gameScoreList,
          gameScore: gameScore,
          onLevelComplete: (totalQuestions, correctAnswers) {
            _completeLevel(context);
          },
        ),
      ),
    );
  }

  void resetLevelState() {
    levelUnlocked = [true, false, false];
    notifyListeners();
  }

  void _showLevelLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("المستوى مقفل"),
          content: Text("قم بإكمال المستويات السابقة لفتح هذا المستوى."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("حسناً"),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خطأ في تحميل الأسئلة"),
          content: Text("لا توجد أسئلة متاحة لهذا المستوى."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("حسناً"),
            ),
          ],
        );
      },
    );
  }

  void speakWord() async {
    if (currentQuestionIndex < questions.length) {
      await flutterTts.speak(questions[currentQuestionIndex]['en'] ?? '');
    }
  }

  void checkAnswer(BuildContext context) {
    String correctAnswer = questions[currentQuestionIndex]['en'] ?? '';
    String userAnswer = answerController.text.trim().toLowerCase();

    if (userAnswer == correctAnswer) {
      gameScore.correctAnswers += 1;
      _showCorrectAnswerDialog(context); // إظهار رسالة الإجابة الصحيحة
    } else {
      _showIncorrectAnswerDialog(context); // إظهار رسالة الإجابة الخاطئة
    }

    gameScore.totalQuestions += 1;

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex += 1;
      answerController.clear();
      speakWord();
      notifyListeners();
    } else {
      _completeLevel(context);
    }
  }

  void _showCorrectAnswerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إجابة صحيحة"),
          content: Text("أحسنت! الإجابة صحيحة."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("استمر"),
            ),
          ],
        );
      },
    );
  }

  void _showIncorrectAnswerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إجابة خاطئة"),
          content: Text(
              "الإجابة الصحيحة هي: ${questions[currentQuestionIndex]['en']}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("استمر"),
            ),
          ],
        );
      },
    );
  }

  void _completeLevel(BuildContext context) async {
    double percentage =
        (gameScore.correctAnswers / gameScore.totalQuestions) * 100;
    int currentLevelIndex = levels.indexWhere((l) => l.name == gameScore.level);

    print('نسبة الإجابات الصحيحة: $percentage');
    print('مستوى اللعب الحالي: ${gameScore.level}');
    print('فهرس المستوى الحالي: $currentLevelIndex');
    print('حالة المستويات المفتوحة: $levelUnlocked');

    if (percentage >= 90 && currentLevelIndex + 1 == levels.length) {
      // إعادة تعيين المستويات إلى الحالة الافتراضية
      _resetLevelsToDefault();
    } else if (percentage >= 90 && currentLevelIndex + 1 < levels.length) {
      levelUnlocked[currentLevelIndex + 1] = true;
      await _saveLevelUnlockedStatus();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          totalQuestions: gameScore.totalQuestions,
          correctAnswers: gameScore.correctAnswers,
        ),
      ),
    );
  }

  Future<void> _saveLevelUnlockedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'levelUnlocked',
      levelUnlocked.map((e) => e.toString()).toList(),
    );
    notifyListeners();
  }
}

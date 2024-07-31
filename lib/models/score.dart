class Score {
  final String level;
  int totalQuestions;
  int correctAnswers;

  Score({
    required this.level,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
  });
}

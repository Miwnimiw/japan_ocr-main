// lib/quiz/quiz_controller.dart
import '../dictionary_data.dart';
import '../quiz_history.dart';

class QuizController {
  int currentIndex = 0;
  int score = 0;
  final int totalQuestions = 10;

  late List<String> questions; // list ตัวอักษรที่ใช้เป็นโจทย์

  QuizController() {
    _generateQuestions();
  }

  /// สุ่มคำถามจาก dictionaryData
  void _generateQuestions() {
    final keys = dictionaryData.keys.toList();
    keys.shuffle();
    questions = keys.take(totalQuestions).toList();
  }

  /// ดึงคำถามปัจจุบัน
  String get currentQuestion => questions[currentIndex];

  /// ตรวจคำตอบของผู้ใช้
  bool checkAnswer(String userAnswer) {
    final correct = userAnswer.trim() == currentQuestion;
    if (correct) score++;
    return correct;
  }

  /// ไปคำถามถัดไป
  bool nextQuestion() {
    if (currentIndex < totalQuestions - 1) {
      currentIndex++;
      return true;
    }
    return false; // หมายถึงทำครบแล้ว
  }

  /// บันทึกผลลัพธ์ลง QuizHistory
  Future<void> saveResult() async {
    await QuizHistory.saveResult(score, totalQuestions);
  }

  /// เริ่มใหม่
  void reset() {
    score = 0;
    currentIndex = 0;
    _generateQuestions();
  }
}

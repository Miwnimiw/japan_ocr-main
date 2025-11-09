// lib/quiz/quiz_history.dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class QuizHistory {
  /// บันทึกผลสอบใหม่
  static Future<void> saveResult(int score, int total) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/quiz_history.json');

    List<Map<String, dynamic>> history = [];
    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        history = List<Map<String, dynamic>>.from(json.decode(content));
      }
    }

    history.add({
      'score': score,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    });

    await file.writeAsString(json.encode(history));
  }

  /// โหลดประวัติทั้งหมด
  static Future<List<Map<String, dynamic>>> loadHistory() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/quiz_history.json');
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    if (content.isEmpty) return [];
    return List<Map<String, dynamic>>.from(json.decode(content));
  }

  /// ล้างประวัติ
  static Future<void> clearHistory() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/quiz_history.json');
    if (await file.exists()) {
      await file.writeAsString('[]');
    }
  }
}

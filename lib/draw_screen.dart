import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:app_ocr_japan/ocr_service.dart';
import 'package:app_ocr_japan/dictionary_data.dart';
import 'package:app_ocr_japan/quiz_history.dart'; // ✅ ใช้ได้ถ้ามีไฟล์นี้อยู่ใน lib/quiz/

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final List<ui.Offset?> _points = [];
  final GlobalKey _paintKey = GlobalKey(); // ✅ ใช้แก้ปัญหาเส้นไม่ตรง
  String _result = '';
  bool _isLoading = false;

  // ✅ ตัวแปร Quiz
  List<String> _quizList = [];
  int _currentQuestion = 0;
  int _score = 0;
  String _currentQuestionText = '';
  final bool _isQuizMode = true;


  @override
  void initState() {
    super.initState();
    _initializeOCR();
    _generateQuiz();
  }

  Future<void> _initializeOCR() async {
    await OcrService.init();
  }

  /// ✅ สร้างชุดคำถาม (เฉพาะฮิรางานะ + คาตาคานะ)
  void _generateQuiz() {
    final allChars = dictionaryData.keys
        .where((c) => RegExp(r'^[ぁ-んァ-ン]+$').hasMatch(c))
        .toList();

    allChars.shuffle(Random());
    _quizList = allChars.take(10).toList();
    _currentQuestion = 0;
    _score = 0;
    _currentQuestionText = _quizList[_currentQuestion];
  }

  void _clearCanvas() {
    setState(() {
      _points.clear();
      _result = '';
    });
  }

  Future<void> _processOCR() async {
    if (_points.isEmpty) return;

    setState(() => _isLoading = true);
    final text = await OcrService.recognizeDrawing(_points);
    setState(() {
      _result = text.isNotEmpty ? text : 'อ่านไม่ออก 😢';
      _isLoading = false;
    });

    debugPrint('🎯 ผลลัพธ์ OCR: $_result');

    if (_isQuizMode) {
      _checkAnswer();
    }
  }

  void _checkAnswer() async {
    final correct = _quizList[_currentQuestion];
    bool isCorrect = _result.trim() == correct.trim();

    if (isCorrect) _score++;

    // ✅ บันทึกประวัติเมื่อจบข้อ
    if (_currentQuestion == 9) {
      await QuizHistory.saveResult(_score, 10);
    }

    // ✅ เช็กก่อนใช้ context หลัง async
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '✅ ถูกต้อง!' : '❌ ผิดจ้า'),
        content: Text('คำตอบคือ: $correct\nคุณเขียนได้: $_result'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextQuestion();
            },
            child: const Text('ข้อต่อไป ➡️'),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < 9) {
      setState(() {
        _currentQuestion++;
        _currentQuestionText = _quizList[_currentQuestion];
        _points.clear();
        _result = '';
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🎉 สรุปผลแบบทดสอบ'),
        content: Text('คุณได้คะแนน $_score / 10'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateQuiz();
              _clearCanvas();
            },
            child: const Text('เริ่มใหม่ 🔁'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✏️ แบบทดสอบการเขียนญี่ปุ่น'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // 🔹 ส่วนหัวโจทย์
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.indigo.shade50,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'ข้อ ${_currentQuestion + 1} / 10',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'เขียนอักษรนี้ให้ถูกต้อง 👇',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentQuestionText,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 พื้นที่วาด (Canvas)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],

              ),
              child: GestureDetector(
                key: _paintKey, // ✅ ใช้ key นี้แทน context
                onPanStart: (details) {
                  final RenderBox renderBox =
                  _paintKey.currentContext!.findRenderObject() as RenderBox;
                  final localPosition =
                  renderBox.globalToLocal(details.globalPosition);
                  setState(() => _points.add(localPosition));
                },
                onPanUpdate: (details) {
                  final RenderBox renderBox =
                  _paintKey.currentContext!.findRenderObject() as RenderBox;
                  final localPosition =
                  renderBox.globalToLocal(details.globalPosition);
                  setState(() => _points.add(localPosition));
                },
                onPanEnd: (details) => setState(() => _points.add(null)),
                child: CustomPaint(
                  painter: DrawingPainter(_points),
                  child: Container(),
                ),
              ),
            ),
          ),

          // 🔹 ส่วนล่าง (ผลลัพธ์ + ปุ่ม)
          Container(
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                  _result.isEmpty
                      ? "'🖋 เขียนแล้วกด' 'ตรวจสอบ'"
                      : '📖 อ่านได้ว่า: $_result',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _clearCanvas,
                      icon: const Icon(Icons.clear),
                      label: const Text('ล้าง'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _processOCR,
                      icon: const Icon(Icons.search),
                      label: const Text('ตรวจสอบ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🎨 ตัววาดเส้น
class DrawingPainter extends CustomPainter {
  final List<ui.Offset?> points;
  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

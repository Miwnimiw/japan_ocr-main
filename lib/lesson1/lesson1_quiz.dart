import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Lesson1Quiz extends StatefulWidget {
  final List<Map<String, String>> questions;
  const Lesson1Quiz({Key? key, required this.questions}) : super(key: key);

  @override
  _Lesson1QuizState createState() => _Lesson1QuizState();
}

class _Lesson1QuizState extends State<Lesson1Quiz> with TickerProviderStateMixin {
  late List<Map<String, String>> shuffledQuestions;
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  bool isCorrect = false;
  List<String> options = [];
  bool questionIsKana = true; // True = Hiragana, False = Romaji
  Random random = Random();

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    shuffledQuestions = List.from(widget.questions)..shuffle();
    _initAnimations();
    generateOptions();
  }

  void _initAnimations() {
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void generateOptions() {
    final current = shuffledQuestions[currentIndex];

    questionIsKana = random.nextBool();
    String correctAnswer = questionIsKana ? current['kana']! : current['romaji']!;
    String correctChoice = questionIsKana ? current['romaji']! : current['kana']!;

    Set<String> opts = {correctChoice};
    while (opts.length < 4) {
      final candidate = shuffledQuestions[random.nextInt(shuffledQuestions.length)];
      String choice = questionIsKana ? candidate['romaji']! : candidate['kana']!;
      if (choice != correctChoice) opts.add(choice);
    }
    options = opts.toList()..shuffle();

    answered = false;
    isCorrect = false;
  }

  void answer(String choice) {
    final current = shuffledQuestions[currentIndex];
    String correctChoice = questionIsKana ? current['romaji']! : current['kana']!;
    setState(() {
      answered = true;
      isCorrect = choice == correctChoice;
      if (isCorrect) score++;
    });

    _flipController.forward();

    Future.delayed(const Duration(milliseconds: 800), () async {
      _flipController.reset();
      await nextQuestion();
    });
  }

  Future<void> nextQuestion() async {
    if (currentIndex < shuffledQuestions.length - 1) {
      await _slideController.reverse();
      setState(() {
        currentIndex++;
        generateOptions();
      });
      _slideController.forward();
    } else {
      await saveHistory();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResult(score: score, total: shuffledQuestions.length),
          ),
        );
      }
    }
  }

  Future<void> saveHistory() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/quiz_history.json');
    List<Map<String, dynamic>> history = [];
    if (await file.exists()) {
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        history = List<Map<String, dynamic>>.from(json.decode(content));
      }
    }
    history.add({
      "date": DateTime.now().toIso8601String(),
      "score": score,
      "total": shuffledQuestions.length,
    });
    await file.writeAsString(json.encode(history));
  }

  @override
  Widget build(BuildContext context) {
    final current = shuffledQuestions[currentIndex];
    String questionText = questionIsKana ? current['kana']! : current['romaji']!;
    String answerText = isCorrect ? " 🟢" : " ❌";

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 1 Quiz'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('คำถามที่ ${currentIndex + 1} / ${shuffledQuestions.length}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    bool isFront = _flipAnimation.value < pi / 2;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_flipAnimation.value),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isFront ? questionText : answerText,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: isFront ? Colors.black : (isCorrect ? Colors.green : Colors.red),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: options.map((opt) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    onPressed: answered ? null : () => answer(opt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: answered
                          ? (opt == (questionIsKana ? current['romaji']! : current['kana']!) ? Colors.green : Colors.red)
                          : Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(opt, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResult extends StatelessWidget {
  final int score;
  final int total;
  const QuizResult({Key? key, required this.score, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ผลลัพธ์แบบทดสอบ'), backgroundColor: Colors.deepPurple),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('คุณตอบถูก $score / $total ข้อ', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('กลับไปยังแบบทดสอบ'),
          ),
        ]),
      ),
    );
  }
}

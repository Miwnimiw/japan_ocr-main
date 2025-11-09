import 'package:flutter/material.dart';
import 'dart:async';

class Lesson2Quiz extends StatefulWidget {
  // It's good practice to make the list mutable if you plan to shuffle it.
  final List<Map<String, String>> questions;

  const Lesson2Quiz({super.key, required this.questions});

  @override
  State<Lesson2Quiz> createState() => _Lesson2QuizState();
}

class _Lesson2QuizState extends State<Lesson2Quiz> {
  int currentIndex = 0;
  int score = 0;
  final TextEditingController answerController = TextEditingController();

  // State variables to track answer correctness and loading state
  bool? _wasCorrect;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Shuffle the list of questions when the quiz starts to ensure they are random
    // and not repeated in the same order.
    widget.questions.shuffle();
  }

  void checkAnswer() {
    // Prevent multiple submissions while checking
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    String userAnswer = answerController.text.trim().toLowerCase();
    String correctAnswer =
    widget.questions[currentIndex]['romaji']!.toLowerCase();

    bool isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      score++;
    }

    // Update the UI to show the feedback icon (correct or incorrect)
    setState(() {
      _wasCorrect = isCorrect;
    });

    // Wait for a moment so the user can see the feedback
    Timer(const Duration(milliseconds: 1200), () {
      if (currentIndex < widget.questions.length - 1) {
        // Move to the next question
        setState(() {
          currentIndex++;
          _wasCorrect = null; // Reset feedback icon
          _isChecking = false; // Re-enable button
          answerController.clear();
        });
      } else {
        // End of the quiz, show results
        showResultDialog();
      }
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (_) => AlertDialog(
        title: const Text("ผลลัพธ์"),
        content: Text("คุณทำได้ $score / ${widget.questions.length} คะแนน"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to the previous screen
            },
            child: const Text("ปิด"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("แบบทดสอบ คาตาคานะ"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feedback Icon Area
            SizedBox(
              height: 80,
              child: _wasCorrect == null
                  ? null // Show nothing before an answer is submitted
                  : Icon(
                _wasCorrect! ? Icons.check_circle : Icons.cancel,
                color: _wasCorrect! ? Colors.green : Colors.red,
                size: 60,
              ),
            ),
            // Katakana Character
            Text(
              widget.questions[currentIndex]['kana']!,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            // Answer TextField
            TextField(
              controller: answerController,
              // Disable the text field while checking the answer
              enabled: !_isChecking,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "ใส่คำอ่าน (romaji)",
              ),
              // Allows submitting with the keyboard's "done" button
              onSubmitted: (_) => checkAnswer(),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton.icon(
              // Disable button while checking to prevent spamming
              onPressed: _isChecking ? null : checkAnswer,
              icon: const Icon(Icons.check),
              label: const Text("ตรวจคำตอบ"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Progress Text
            Text(
              "ข้อที่ ${currentIndex + 1} / ${widget.questions.length}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

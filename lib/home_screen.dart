import 'package:flutter/material.dart';
import 'package:app_ocr_japan/draw_screen.dart';
import 'package:app_ocr_japan/lesson1/lesson1_screen.dart';
import 'package:app_ocr_japan/lesson2/lesson2_screen.dart';
import 'package:app_ocr_japan/lesson3/lesson3_screen.dart';
import 'package:app_ocr_japan/kanji_search_screen.dart';
import 'package:app_ocr_japan/quiz/quiz_history_page.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key}); // ✅ ใช้ super parameter (Dart 3+)

  final List<Map<String, dynamic>> lessons = [
    {
      'title': 'บทที่ 1: ฮิรางานะ',
      'description': 'เรียนรู้ตัวอักษรฮิรางานะเบื้องต้น',
      'screen':  Lesson1Screen(), // ✅ ใส่ const ถ้า constructor รองรับ
    },
    {
      'title': 'บทที่ 2: คาตาคานะ',
      'description': 'ฝึกอ่านเขียนคาตาคานะ',
      'screen':  Lesson2Screen(),
    },
    {
      'title': 'บทที่ 3: คำศัพท์พื้นฐาน',
      'description': 'จดจำคำศัพท์ญี่ปุ่นที่ใช้บ่อย',
      'screen': const Lesson3Screen(),
    },
    {
      'title': 'บทที่ 4: ไวยากรณ์ + แบบทดสอบ',
      'description': 'เรียนรู้โครงสร้างประโยคง่าย ๆ และทำแบบทดสอบ',
      'screen': null,
    },
    {
      'title': 'OCR: วาดตัวอักษร',
      'description': 'เขียนแล้วให้แอปอ่านภาษาญี่ปุ่นจากลายมือคุณ',
      'screen': const DrawScreen(),
    },
    {
      'title': 'ประวัติแบบทดสอบ',
      'description': 'ดูคะแนนและประวัติการทำ Quiz ของคุณ',
      'screen': const QuizHistoryPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แอปเรียนภาษาญี่ปุ่น'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KanjiSearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: ListTile(
              title: Text(
                lesson['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(lesson['description']),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (lesson['screen'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => lesson['screen'],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('ยังไม่พร้อมใช้งาน'),
                      content: const Text('บทเรียนนี้กำลังอยู่ระหว่างพัฒนา'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('ตกลง'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

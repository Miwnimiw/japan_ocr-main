import 'package:flutter/material.dart';
import 'package:app_ocr_japan/home_screen.dart';
import 'package:app_ocr_japan/ocr_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OcrService.init(); // โหลด OCR ให้เสร็จก่อนเข้าแอป
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OCR Japan',
      home: HomeScreen(), // หน้าหลักของแอป
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: OcrService.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // โมเดลโหลดเสร็จ → แสดง HomeScreen ปกติ
          return MaterialApp(
            title: 'Japanese Learning App',
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        } else {
          // ระหว่างโหลดโมเดล → แสดง Loading Indicator
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }


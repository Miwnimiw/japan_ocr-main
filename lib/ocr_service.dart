import 'dart:math';
import 'dart:ui';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:app_ocr_japan/dictionary_data.dart';
import 'package:flutter/foundation.dart';

class OcrService {
  static final _modelManager = DigitalInkRecognizerModelManager();
  static DigitalInkRecognizer? _recognizer;

  /// ✅ โหลดโมเดลภาษาญี่ปุ่น
  static Future<void> init() async {
    const model = 'ja';
    try {
      final isDownloaded = await _modelManager.isModelDownloaded(model);
      if (!isDownloaded) {
        if (kDebugMode) {
          print('📥 กำลังดาวน์โหลดโมเดลภาษาญี่ปุ่น...');
        }
        await _modelManager.downloadModel(model);
      }
      _recognizer = DigitalInkRecognizer(languageCode: model);
      if (kDebugMode) {
        print('✅ โหลดโมเดล OCR ญี่ปุ่นสำเร็จ');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ โหลด OCR ล้มเหลว: $e');
      }
      try {
        _recognizer = DigitalInkRecognizer(languageCode: model);
      } catch (_) {
        _recognizer = null;
      }
    }
  }

  /// ✅ ฟังก์ชันหลัก OCR
  static Future<String> recognizeDrawing(List<Offset?> points) async {
    if (_recognizer == null || points.isEmpty) return '';

    // ---------- 1) แยก Stroke ----------
    final rawStrokes = <List<Offset>>[];
    var current = <Offset>[];
    for (final p in points) {
      if (p == null) {
        if (current.isNotEmpty) {
          rawStrokes.add(List.from(current));
          current.clear();
        }
      } else {
        current.add(p);
      }
    }
    if (current.isNotEmpty) rawStrokes.add(List.from(current));
    if (rawStrokes.isEmpty) return '';

    // ---------- 2) ลบ noise ----------
    final filteredStrokes = rawStrokes.where((s) => s.length >= 3).toList();
    if (filteredStrokes.isEmpty) return '';

    // ---------- 3) Normalize ----------
    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;
    for (var stroke in filteredStrokes) {
      for (var p in stroke) {
        if (p.dx < minX) minX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy > maxY) maxY = p.dy;
      }
    }

    final width = maxX - minX;
    final height = maxY - minY;
    const target = 256.0;
    final scale = target / max(width, height);
    const padding = 10.0;

    // ---------- 4) สร้าง Ink ----------
    final strokes = <Stroke>[];
    int t = 0;
    for (var stroke in filteredStrokes) {
      final s = Stroke();
      for (var p in stroke) {
        final x = (p.dx - minX) * scale + padding;
        final y = (p.dy - minY) * scale + padding;
        t += 10;
        s.points.add(StrokePoint(x: x, y: y, t: t));
      }
      t += 20;
      strokes.add(s);
    }

    try {
      final ink = Ink()..strokes.addAll(strokes);

      final candidates = await _recognizer!.recognize(ink);

      if (candidates.isEmpty) {
        if (kDebugMode) {
          print('🤷‍♂️ ไม่มีผลลัพธ์จาก OCR');
        }
        return '';
      }

      if (kDebugMode) {
        print('🎌 ผลลัพธ์ OCR:');
        for (final c in candidates) {
          print('- ${c.text} (${c.score.toStringAsFixed(3)})');
        }
      }

      return candidates.first.text;
    } catch (e) {
      if (kDebugMode) {
        print('❌ OCR Error: $e');
      }
      return '';
    }
  }

  /// ✅ Dictionary ของเดิม
  static List<Map<String, dynamic>> searchCharacter(String char) {
    final results = <Map<String, dynamic>>[];
    final data = dictionaryData[char];
    if (data != null) {
      results.add({
        'char': char,
        'romaji': data['romaji']?.toString() ?? '',
        'examples': (data['examples'] as List?)?.cast<String>() ?? [],
      });
    }
    return results;
  }

  static List<Map<String, dynamic>> searchWord(String query) {
    final results = <Map<String, dynamic>>[];
    dictionaryData.forEach((char, data) {
      final romaji = data['romaji']?.toString() ?? '';
      final examples = (data['examples'] as List?)?.cast<String>() ?? [];
      if (char.contains(query) ||
          romaji.contains(query) ||
          examples.any((ex) => ex.contains(query))) {
        results.add({
          'char': char,
          'romaji': romaji,
          'examples': examples,
        });
      }
    });
    return results;
  }
}

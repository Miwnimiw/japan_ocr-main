import 'package:flutter/material.dart';
import 'package:app_ocr_japan/ocr_service.dart';

class KanjiSearchScreen extends StatefulWidget {
  const KanjiSearchScreen({super.key});

  @override
  KanjiSearchScreenState createState() => KanjiSearchScreenState();
}

class KanjiSearchScreenState extends State<KanjiSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  void _search() {
    final query = _controller.text.trim();
    setState(() {
      if (query.isEmpty) {
        _results = [];
      } else if (query.length == 1) {
        _results = OcrService.searchCharacter(query);
      } else {
        _results = OcrService.searchWord(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหาคำศัพท์/คันจิ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'พิมพ์ตัวอักษร/โรมาจิ/คำที่ต้องการค้นหา',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('ไม่มีผลลัพธ์'))
                  : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  final examples =
                      (item['examples'] as List<String>?)?.join('\n') ??
                          '';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        "${item["char"]} (${item["romaji"]})",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        examples,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

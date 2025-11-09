import 'package:flutter/material.dart';
import '../quiz_history.dart';

class QuizHistoryPage extends StatefulWidget {
  const QuizHistoryPage({super.key});

  @override
  _QuizHistoryPageState createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await QuizHistory.loadHistory();
    setState(() {
      history = data.reversed.toList();
    });
  }

  Future<void> clearAll() async {
    await QuizHistory.clearHistory();
    setState(() {
      history = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติแบบทดสอบ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearAll,
            tooltip: 'ล้างประวัติ',
          )
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('ยังไม่มีประวัติการทำแบบทดสอบ'))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];
          final date = DateTime.parse(record['date']);
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.deepPurple),
              title: Text("คะแนน: ${record['score']} / ${record['total']}"),
              subtitle: Text(
                  "วันที่: ${date.day}-${date.month}-${date.year} เวลา: ${date.hour}:${date.minute.toString().padLeft(2, '0')}"),
            ),
          );
        },
      ),
    );
  }
}

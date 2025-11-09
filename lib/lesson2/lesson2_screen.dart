import 'package:flutter/material.dart';
import 'lesson2_quiz.dart';

class Lesson2Screen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> katakanaSections = {
    'a': [
      {'kana': 'ア', 'romaji': 'a'},
      {'kana': 'イ', 'romaji': 'i'},
      {'kana': 'ウ', 'romaji': 'u'},
      {'kana': 'エ', 'romaji': 'e'},
      {'kana': 'オ', 'romaji': 'o'},
    ],
    'ka': [
      {'kana': 'カ', 'romaji': 'ka'},
      {'kana': 'キ', 'romaji': 'ki'},
      {'kana': 'ク', 'romaji': 'ku'},
      {'kana': 'ケ', 'romaji': 'ke'},
      {'kana': 'コ', 'romaji': 'ko'},
    ],
    'sa': [
      {'kana': 'サ', 'romaji': 'sa'},
      {'kana': 'シ', 'romaji': 'shi'},
      {'kana': 'ス', 'romaji': 'su'},
      {'kana': 'セ', 'romaji': 'se'},
      {'kana': 'ソ', 'romaji': 'so'},
    ],
    'ta': [
      {'kana': 'タ', 'romaji': 'ta'},
      {'kana': 'チ', 'romaji': 'chi'},
      {'kana': 'ツ', 'romaji': 'tsu'},
      {'kana': 'テ', 'romaji': 'te'},
      {'kana': 'ト', 'romaji': 'to'},
    ],
    'na': [
      {'kana': 'ナ', 'romaji': 'na'},
      {'kana': 'ニ', 'romaji': 'ni'},
      {'kana': 'ヌ', 'romaji': 'nu'},
      {'kana': 'ネ', 'romaji': 'ne'},
      {'kana': 'ノ', 'romaji': 'no'},
    ],
    'ha': [
      {'kana': 'ハ', 'romaji': 'ha'},
      {'kana': 'ヒ', 'romaji': 'hi'},
      {'kana': 'フ', 'romaji': 'fu'},
      {'kana': 'ヘ', 'romaji': 'he'},
      {'kana': 'ホ', 'romaji': 'ho'},
    ],
    'ma': [
      {'kana': 'マ', 'romaji': 'ma'},
      {'kana': 'ミ', 'romaji': 'mi'},
      {'kana': 'ム', 'romaji': 'mu'},
      {'kana': 'メ', 'romaji': 'me'},
      {'kana': 'モ', 'romaji': 'mo'},
    ],
    'ya': [
      {'kana': 'ヤ', 'romaji': 'ya'},
      {'kana': 'ユ', 'romaji': 'yu'},
      {'kana': 'ヨ', 'romaji': 'yo'},
    ],
    'ra': [
      {'kana': 'ラ', 'romaji': 'ra'},
      {'kana': 'リ', 'romaji': 'ri'},
      {'kana': 'ル', 'romaji': 'ru'},
      {'kana': 'レ', 'romaji': 're'},
      {'kana': 'ロ', 'romaji': 'ro'},
    ],
    'wa': [
      {'kana': 'ワ', 'romaji': 'wa'},
      {'kana': 'ヲ', 'romaji': 'wo'},
    ],
    'n': [
      {'kana': 'ン', 'romaji': 'n'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('บทที่ 2: คาตาคานะ'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ...katakanaSections.entries.map((entry) {
            String section = entry.key;
            List<Map<String, String>> characters = entry.value;

            return ExpansionTile(
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  section.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade900,
                  ),
                ),
              ),
              children: [
                Container(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: characters.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade200,
                              Colors.deepPurple.shade50
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                characters[index]['kana']!,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade900,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                characters[index]['romaji']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }).toList(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Lesson2Quiz(
                        questions: katakanaSections.values
                            .expand((e) => e)
                            .toList(),
                      )),
                );
              },
              icon: Icon(Icons.quiz),
              label: Text('เริ่มทำแบบทดสอบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

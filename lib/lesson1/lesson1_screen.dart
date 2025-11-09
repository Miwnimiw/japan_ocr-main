import 'package:flutter/material.dart';
import 'lesson1_quiz.dart';

class Lesson1Screen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> hiraganaSections = {
    'a': [
      {'kana': 'あ', 'romaji': 'a'},
      {'kana': 'い', 'romaji': 'i'},
      {'kana': 'う', 'romaji': 'u'},
      {'kana': 'え', 'romaji': 'e'},
      {'kana': 'お', 'romaji': 'o'},
    ],
    'ka': [
      {'kana': 'か', 'romaji': 'ka'},
      {'kana': 'き', 'romaji': 'ki'},
      {'kana': 'く', 'romaji': 'ku'},
      {'kana': 'け', 'romaji': 'ke'},
      {'kana': 'こ', 'romaji': 'ko'},
    ],
    'sa': [
      {'kana': 'さ', 'romaji': 'sa'},
      {'kana': 'し', 'romaji': 'shi'},
      {'kana': 'す', 'romaji': 'su'},
      {'kana': 'せ', 'romaji': 'se'},
      {'kana': 'そ', 'romaji': 'so'},
    ],
    'ta': [
      {'kana': 'た', 'romaji': 'ta'},
      {'kana': 'ち', 'romaji': 'chi'},
      {'kana': 'つ', 'romaji': 'tsu'},
      {'kana': 'て', 'romaji': 'te'},
      {'kana': 'と', 'romaji': 'to'},
    ],
    'na': [
      {'kana': 'な', 'romaji': 'na'},
      {'kana': 'に', 'romaji': 'ni'},
      {'kana': 'ぬ', 'romaji': 'nu'},
      {'kana': 'ね', 'romaji': 'ne'},
      {'kana': 'の', 'romaji': 'no'},
    ],
    'ha': [
      {'kana': 'は', 'romaji': 'ha'},
      {'kana': 'ひ', 'romaji': 'hi'},
      {'kana': 'ふ', 'romaji': 'fu'},
      {'kana': 'へ', 'romaji': 'he'},
      {'kana': 'ほ', 'romaji': 'ho'},
    ],
    'ma': [
      {'kana': 'ま', 'romaji': 'ma'},
      {'kana': 'み', 'romaji': 'mi'},
      {'kana': 'む', 'romaji': 'mu'},
      {'kana': 'め', 'romaji': 'me'},
      {'kana': 'も', 'romaji': 'mo'},
    ],
    'ya': [
      {'kana': 'や', 'romaji': 'ya'},
      {'kana': 'ゆ', 'romaji': 'yu'},
      {'kana': 'よ', 'romaji': 'yo'},
    ],
    'ra': [
      {'kana': 'ら', 'romaji': 'ra'},
      {'kana': 'り', 'romaji': 'ri'},
      {'kana': 'る', 'romaji': 'ru'},
      {'kana': 'れ', 'romaji': 're'},
      {'kana': 'ろ', 'romaji': 'ro'},
    ],
    'wa': [
      {'kana': 'わ', 'romaji': 'wa'},
      {'kana': 'を', 'romaji': 'wo'},
    ],
    'n': [
      {'kana': 'ん', 'romaji': 'n'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('บทที่ 1: ฮิรางานะ'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ...hiraganaSections.entries.map((entry) {
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
                    builder: (_) => Lesson1Quiz(
                      questions: hiraganaSections.values.expand((e) => e).toList(),
                    ),
                  ),
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

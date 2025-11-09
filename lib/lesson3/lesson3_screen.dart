import 'package:flutter/material.dart';
import 'dart:async';


class DictionaryService {
  static Map<String, dynamic>? findWord(String text) {
    for (var word in words) {
      if (word.hiragana.contains(text) ||
          word.kanji.contains(text)) {
        return {
          'romanji': word.romanji,
          'thai': word.thai,
          'example': word.hiragana + (word.kanji.isNotEmpty ? " (${word.kanji})" : "")
        };
      }
    }
    return null;
  }
}



class Word {
  final String romanji;
  final String hiragana;
  final String kanji;
  final String thai;
  final String image;

  Word({
    required this.romanji,
    required this.hiragana,
    required this.kanji,
    required this.thai,
    required this.image,
  });
}

// ---------------- คำศัพท์ทั้งหมด ----------------
final List<Word> words = [
  Word(romanji: 'asa', hiragana: 'あさ', kanji: '朝', thai: 'เช้า', image: 'assets/images/asa.png'),
  Word(romanji: 'hiru', hiragana: 'ひる', kanji: '昼', thai: 'กลางวัน', image: 'assets/images/hiru.png'),
  Word(romanji: 'yoru', hiragana: 'よる', kanji: '夜', thai: 'กลางคืน', image: 'assets/images/yoru.png'),
  Word(romanji: 'isu', hiragana: 'いす', kanji: '椅子', thai: 'เก้าอี้', image: 'assets/images/isu.png'),
  Word(romanji: 'ocha', hiragana: 'おちゃ', kanji: 'お茶', thai: 'ชา', image: 'assets/images/ocha.png'),
  Word(romanji: 'tookee', hiragana: 'とけい', kanji: '時計', thai: 'นาฬิกา', image: 'assets/images/tookee.png'),
  Word(romanji: 'umi', hiragana: 'うみ', kanji: '海', thai: 'ทะเล', image: 'assets/images/umi.png'),
  Word(romanji: 'yama', hiragana: 'やま', kanji: '山', thai: 'ภูเขา', image: 'assets/images/yama.png'),
  Word(romanji: 'iun', hiragana: 'いうん', kanji: '言う', thai: 'พูด', image: 'assets/images/iun.png'),
  Word(romanji: 'neko', hiragana: 'ねこ', kanji: '猫', thai: 'แมว', image: 'assets/images/neko.png'),
  Word(romanji: 'zasshi', hiragana: 'ざっし', kanji: '雑誌', thai: 'นิตยสาร', image: 'assets/images/zasshi.png'),
  Word(romanji: 'tsukue', hiragana: 'つくえ', kanji: '机', thai: 'โต๊ะ', image: 'assets/images/tsukue.png'),
  Word(romanji: 'nihongo', hiragana: 'にほんご', kanji: '日本語', thai: 'ภาษาญี่ปุ่น', image: 'assets/images/nihongo.png'),
  Word(romanji: 'ego', hiragana: 'えいご', kanji: '英語', thai: 'ภาษาอังกฤษ', image: 'assets/images/ego.png'),
  Word(romanji: 'tenbura', hiragana: 'てんぷら', kanji: '天ぷら', thai: 'เทมปุระ', image: 'assets/images/tenbura.png'),
  Word(romanji: 'fujisan', hiragana: 'ふじさん', kanji: '富士山', thai: 'ภูเขาไฟฟูจิ', image: 'assets/images/fujisan.png'),
  Word(romanji: 'tookyoo', hiragana: 'とうきょう', kanji: '東京', thai: 'โตเกียว', image: 'assets/images/tookyoo.png'),
  Word(romanji: 'kazoku', hiragana: 'かぞく', kanji: '家族', thai: 'ครอบครัว', image: 'assets/images/kazoku.png'),
  Word(romanji: 'yasai', hiragana: 'やさい', kanji: '野菜', thai: 'ผัก', image: 'assets/images/yasai.png'),
  Word(romanji: 'sakana', hiragana: 'さかな', kanji: '魚', thai: 'ปลา', image: 'assets/images/sakana.png'),
  Word(romanji: 'tamago', hiragana: 'たまご', kanji: '卵', thai: 'ไข่', image: 'assets/images/tamago.png'),
  Word(romanji: 'ohayou', hiragana: 'おはよう', kanji: '', thai: 'สวัสดีตอนเช้า', image: 'assets/images/ohayou.png'),
  Word(romanji: 'konnichiwa', hiragana: 'こんにちは', kanji: '', thai: 'สวัสดี', image: 'assets/images/konnichiwa.png'),
  Word(romanji: 'konbanwa', hiragana: 'こんばんは', kanji: '', thai: 'สวัสดีตอนเย็น', image: 'assets/images/konbanwa.png'),
  Word(romanji: 'arigatou', hiragana: 'ありがとう', kanji: '', thai: 'ขอบคุณ', image: 'assets/images/arigatou.png'),
  Word(romanji: 'gomen', hiragana: 'ごめん', kanji: '', thai: 'ขอโทษ', image: 'assets/images/gomen.png'),
  Word(romanji: 'sayonara', hiragana: 'さよなら', kanji: '', thai: 'ลาก่อน', image: 'assets/images/sayonara.png'),
  Word(romanji: 'pan', hiragana: 'ぱん', kanji: 'パン', thai: 'ขนมปัง', image: 'assets/images/pan.png'),
  Word(romanji: 'terebi', hiragana: 'テレビ', kanji: 'テレビ', thai: 'ทีวี', image: 'assets/images/terebi.png'),
  Word(romanji: 'kamera', hiragana: 'カメラ', kanji: 'カメラ', thai: 'กล้อง', image: 'assets/images/kamera.png'),
  Word(romanji: 'sofa', hiragana: 'ソファ', kanji: 'ソファ', thai: 'โซฟา', image: 'assets/images/sofa.png'),
  Word(romanji: 'beddo', hiragana: 'ベッド', kanji: 'ベッド', thai: 'เตียงนอน', image: 'assets/images/beddo.png'),
  Word(romanji: 'shirt', hiragana: 'シャツ', kanji: 'シャツ', thai: 'เสื้อเชิ้ต', image: 'assets/images/shirt.png'),
  Word(romanji: 'coffee', hiragana: 'コーヒー', kanji: 'コーヒー', thai: 'กาแฟ', image: 'assets/images/coffee.png'),
  Word(romanji: 'juice', hiragana: 'ジュース', kanji: 'ジュース', thai: 'น้ำผลไม้', image: 'assets/images/juice.png'),
  Word(romanji: 'aircon', hiragana: 'エアコン', kanji: 'エアコン', thai: 'แอร์', image: 'assets/images/aircon.png'),
  Word(romanji: 'shampoo', hiragana: 'シャンプー', kanji: 'シャンプー', thai: 'แชมพู', image: 'assets/images/shampoo.png'),
  Word(romanji: 'manga', hiragana: 'まんが', kanji: '漫画', thai: 'การ์ตูน', image: 'assets/images/manga.png'),
  Word(romanji: 'restaurant', hiragana: 'レストラン', kanji: 'レストラン', thai: 'ร้านอาหาร', image: 'assets/images/restaurant.png'),
  Word(romanji: 'hotel', hiragana: 'ホテル', kanji: 'ホテル', thai: 'โรงแรม', image: 'assets/images/hotel.png'),
  Word(romanji: 'taxi', hiragana: 'タクシー', kanji: 'タクシー', thai: 'แท็กซี่', image: 'assets/images/taxi.png'),
  Word(romanji: 'karaoke', hiragana: 'カラオケ', kanji: 'カラオケ', thai: 'คาราโอเกะ', image: 'assets/images/karaoke.png'),
  Word(romanji: 'watashi', hiragana: 'わたし', kanji: '私', thai: 'ฉัน', image: 'assets/images/watashi.png'),
  Word(romanji: 'chichi', hiragana: 'ちち', kanji: '父', thai: 'พ่อ', image: 'assets/images/chichi.png'),
  Word(romanji: 'haha', hiragana: 'はは', kanji: '母', thai: 'แม่', image: 'assets/images/haha.png'),
  Word(romanji: 'ani', hiragana: 'あに', kanji: '兄', thai: 'พี่ชาย', image: 'assets/images/ani.png'),
  Word(romanji: 'ane', hiragana: 'あね', kanji: '姉', thai: 'พี่สาว', image: 'assets/images/ane.png'),
];

// ---------------- Widget ----------------
class Lesson3Screen extends StatefulWidget {
  const Lesson3Screen({Key? key}) : super(key: key);

  @override
  State<Lesson3Screen> createState() => _Lesson3ScreenState();
}

class _Lesson3ScreenState extends State<Lesson3Screen> {
  final Map<int, bool> _showRomanji = {};

  void _toggleRomanji(int index) {
    setState(() {
      _showRomanji[index] = true;
    });

    // 10 วิ หายไป
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showRomanji[index] = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cellWidth = (screenWidth - 12 * 3) / 2;
    final imageHeight = cellWidth * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('คำศัพท์พื้นฐาน'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          final isRomanjiVisible = _showRomanji[index] ?? false;

          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () => _toggleRomanji(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: imageHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        word.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isRomanjiVisible)
                    Text(word.romanji,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(word.hiragana,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.blueAccent)),
                  Text(word.kanji,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.orangeAccent)),
                  const SizedBox(height: 6),
                  Text(word.thai,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.green)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

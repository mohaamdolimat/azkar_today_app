
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(AzkarApp());
}

class AzkarApp extends StatefulWidget {
  @override
  _AzkarAppState createState() => _AzkarAppState();
}

class _AzkarAppState extends State<AzkarApp> {
  bool isArabic = true;

  final Map<String, List<Map<String, String>>> azkarData = {
    'morning': [
      {
        'ar': 'اللّهُ لا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        'en': 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.'
      },
      {
        'ar': 'أَصْبَحْنا وَأَصْبَحَ المُلكُ للهِ',
        'en': 'We have entered the morning and at this very time all sovereignty belongs to Allah.'
      },
    ],
    'evening': [
      {
        'ar': 'أَمْسَيْنا وَأَمْسَى المُلكُ للهِ',
        'en': 'We have entered the evening and at this very time all sovereignty belongs to Allah.'
      },
      {
        'ar': 'اللّهُ لا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        'en': 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.'
      },
    ],
  };

  final Map<String, Map<String, String>> sectionsTitles = {
    'morning': {'ar': 'أذكار الصباح', 'en': 'Morning Azkar'},
    'evening': {'ar': 'أذكار المساء', 'en': 'Evening Azkar'},
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أذكار اليوم - Azkar Today',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD6EAF8),
        primaryColor: Color(0xFF5DADE2),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18,
            height: 1.5,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF5DADE2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF5DADE2),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'أذكار اليوم' : 'Azkar Today'),
          actions: [
            IconButton(
              tooltip: isArabic ? 'تغيير اللغة' : 'Change Language',
              icon: Icon(Icons.language),
              onPressed: () {
                setState(() {
                  isArabic = !isArabic;
                });
              },
            )
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: azkarData.entries.map((entry) {
            final sectionKey = entry.key;
            final sectionAzkar = entry.value;
            return AzkarSection(
              title: sectionsTitles[sectionKey]?[isArabic ? 'ar' : 'en'] ?? '',
              azkarList: sectionAzkar,
              isArabic: isArabic,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AzkarSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> azkarList;
  final bool isArabic;

  AzkarSection({
    required this.title,
    required this.azkarList,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
            SizedBox(height: 12),
            ...azkarList.map((azkar) {
              final text = isArabic ? azkar['ar']! : azkar['en']!;
              return AzkarItem(text: text, isArabic: isArabic);
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class AzkarItem extends StatelessWidget {
  final String text;
  final bool isArabic;

  AzkarItem({required this.text, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFD6EAF8).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF5DADE2)),
      ),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Color(0xFF2C3E50)),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Color(0xFF5DADE2)),
            tooltip: isArabic ? 'نسخ' : 'Copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              final snackBar = SnackBar(
                content: Text(isArabic
                    ? 'تم نسخ الذكر إلى الحافظة'
                    : 'Azkar copied to clipboard'),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }
}

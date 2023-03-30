import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifzmate/screens/surah.dart';
import 'package:quran/quran.dart' as quran;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Surahs"),
            // const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: quran.totalSurahCount,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${index + 1}. ${quran.getSurahNameArabic(index + 1)}",
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    subtitle: Text(
                      "Verses: ${quran.getVerseCount(index + 1)} | ${quran.getSurahName(index + 1)} | ${quran.getSurahNameEnglish(index + 1)}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Get.to(() => Surah(surahNumber: index + 1));
                    },
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

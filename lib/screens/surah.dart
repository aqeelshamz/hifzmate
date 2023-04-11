import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

class Surah extends StatefulWidget {
  final int surahNumber;
  const Surah({super.key, required this.surahNumber});

  @override
  State<Surah> createState() => _SurahState();
}

class _SurahState extends State<Surah> {
  bool _isEnglish = true;
  bool _showTranslation = true;
  var player = AudioPlayer();

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _isEnglish = prefs.getBool("isEnglish") ?? true;
        _showTranslation = prefs.getBool("showTranslation") ?? true;
      });
    });
    super.initState();
    player = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.translate_rounded),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.translate_rounded),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      quran.getSurahNameArabic(widget.surahNumber),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      quran.getSurahName(widget.surahNumber),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showTranslation = !_showTranslation;
                        });
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool("showTranslation", _showTranslation);
                        });
                      },
                      icon: Icon(_showTranslation
                          ? Icons.subtitles_outlined
                          : Icons.subtitles_off_outlined),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isEnglish = !_isEnglish;
                        });
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool("isEnglish", _isEnglish);
                        });
                      },
                      icon: const Icon(Icons.translate_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quran.getVerseCount(widget.surahNumber),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        quran.getVerse(widget.surahNumber, index + 1,
                            verseEndSymbol: true),
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _showTranslation
                          ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${index + 1}. ${quran.getVerseTranslation(widget.surahNumber, index + 1, translation: _isEnglish ? quran.Translation.enSaheeh : quran.Translation.mlAbdulHameed).replaceAll("Allah", "God")}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (player.state == PlayerState.playing) {
                                if (player.playerId ==
                                    "${widget.surahNumber}:${index + 1}") {
                                  await player.pause();
                                  setState(() {});
                                  return;
                                } else {
                                  await player.stop();
                                  setState(() {});
                                }
                              }
                              setState(() {
                                player = AudioPlayer(
                                    playerId:
                                        "${widget.surahNumber}:${index + 1}");
                              });
                              await player.setSourceUrl(
                                  quran.getAudioURLByVerse(
                                      widget.surahNumber, index + 1));
                              await player.resume();
                              player.onDurationChanged.listen((event) {
                                setState(() {});
                              });
                              player.onPlayerStateChanged.listen((event) {
                                setState(() {});
                              });
                            },
                            icon: Icon(player.playerId ==
                                        "${widget.surahNumber}:${index + 1}" &&
                                    player.state == PlayerState.playing
                                ? FeatherIcons.pause
                                : FeatherIcons.play),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'l10n/app_localizations.dart';

// ============================================================
// ARABIC LETTER MODEL
// ============================================================

class ArabicLetter {
  final String mainLetter;
  final List<String> variants;
  final List<String> audioPaths;
  final List<String> labels;

  ArabicLetter({
    required this.mainLetter,
    required this.variants,
    required this.audioPaths,
    required this.labels,
  });
}

// ============================================================
// BILINGUAL ARABIC ALPHABET LESSONS
// ============================================================

class ArabicLessons extends StatelessWidget {
  ArabicLessons({super.key});

  // Keep all original letters and audio paths.
  final List<ArabicLetter> letters = [
    ArabicLetter(
      mainLetter: 'أ',
      variants: ['أَ', 'أُ', 'إِِ'],
      audioPaths: [
        'soundus/Recording.mp3',
        'soundus/Recording1.mp3',
        'soundus/Recording3.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ب',
      variants: ['بَ', 'بُ', 'بِ'],
      audioPaths: [
        'soundus/Recording4.mp3',
        'soundus/Recording6.mp3',
        'soundus/Recording5.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ت',
      variants: ['تَ', 'تُ', 'تِ'],
      audioPaths: [
        'soundus/Recording7.mp3',
        'soundus/Recording8.mp3',
        'soundus/Recording9.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ث',
      variants: ['ثَ', 'ثُ', 'ثِ'],
      audioPaths: [
        'soundus/Recording10.mp3',
        'soundus/Recording11.mp3',
        'soundus/Recording12.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ج',
      variants: ['جَ', 'جُ', 'جِ'],
      audioPaths: [
        'soundus/Recording13.mp3',
        'soundus/Recording14.mp3',
        'soundus/Recording15.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ح',
      variants: ['حَ', 'حُ', 'حِ'],
      audioPaths: [
        'soundus/Recording16.mp3',
        'soundus/Recording17.mp3',
        'soundus/Recording18.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'خ',
      variants: ['خَ', 'خُ', 'خِ'],
      audioPaths: [
        'soundus/Recording19.mp3',
        'soundus/Recording21.mp3',
        'soundus/Recording20.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'د',
      variants: ['دَ', 'دُ', 'دِ'],
      audioPaths: [
        'soundus/Recording22.mp3',
        'soundus/Recording23.mp3',
        'soundus/Recording24.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ذ',
      variants: ['ذَ', 'ذُ', 'ذِ'],
      audioPaths: [
        'soundus/Recording25.mp3',
        'soundus/Recording26.mp3',
        'soundus/Recording27.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ر',
      variants: ['رَ', 'رُ', 'رِ'],
      audioPaths: [
        'soundus/Recording28.mp3',
        'soundus/Recording29.mp3',
        'soundus/Recording30.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ز',
      variants: ['زَ', 'زُ', 'زِ'],
      audioPaths: [
        'soundus/Recording31.mp3',
        'soundus/Recording32.mp3',
        'soundus/Recording33.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'س',
      variants: ['سَ', 'سُ', 'سِ'],
      audioPaths: [
        'soundus/Recording34.mp3',
        'soundus/Recording35.mp3',
        'soundus/Recording36.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ش',
      variants: ['شَ', 'شُ', 'شِ'],
      audioPaths: [
        'soundus/Recording37.mp3',
        'soundus/Recording38.mp3',
        'soundus/Recording39.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ص',
      variants: ['صَ', 'صُ', 'صِ'],
      audioPaths: [
        'soundus/Recording40.mp3',
        'soundus/Recording41.mp3',
        'soundus/Recording42.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ض',
      variants: ['ضَ', 'ضُ', 'ضِ'],
      audioPaths: [
        'soundus/Recording43.mp3',
        'soundus/Recording44.mp3',
        'soundus/Recording45.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ط',
      variants: ['طَ', 'طُ', 'طِ'],
      audioPaths: [
        'soundus/Recording46.mp3',
        'soundus/Recording47.mp3',
        'soundus/Recording48.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ظ',
      variants: ['ظَ', 'ظُ', 'ظِ'],
      audioPaths: [
        'soundus/Recording43.mp3',
        'soundus/Recording44.mp3',
        'soundus/Recording45.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ع',
      variants: ['عَ', 'عُ', 'عِ'],
      audioPaths: [
        'soundus/Recording49.mp3',
        'soundus/Recording50.mp3',
        'soundus/Recording51.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'غ',
      variants: ['غَ', 'غُ', 'غِ'],
      audioPaths: [
        'soundus/Recording52.mp3',
        'soundus/Recording53.mp3',
        'soundus/Recording54.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ف',
      variants: ['فَ', 'فُ', 'فِ'],
      audioPaths: [
        'soundus/Recording55.mp3',
        'soundus/Recording56.mp3',
        'soundus/Recording57.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ق',
      variants: ['قَ', 'قُ', 'قِ'],
      audioPaths: [
        'soundus/Recording58.mp3',
        'soundus/Recording59.mp3',
        'soundus/Recording60.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ك',
      variants: ['كَ', 'كُ', 'كِ'],
      audioPaths: [
        'soundus/Recording64.mp3',
        'soundus/Recording65.mp3',
        'soundus/Recording66.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ل',
      variants: ['لَ', 'لُ', 'لِ'],
      audioPaths: [
        'soundus/Recording61.mp3',
        'soundus/Recording62.mp3',
        'soundus/Recording63.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'م',
      variants: ['مَ', 'مُ', 'مِ'],
      audioPaths: [
        'soundus/Recording67.mp3',
        'soundus/Recording68.mp3',
        'soundus/Recording69.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ن',
      variants: ['نَ', 'نُ', 'نِ'],
      audioPaths: [
        'soundus/Recording70.mp3',
        'soundus/Recording71.mp3',
        'soundus/Recording72.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ه',
      variants: ['هَ', 'هُ', 'هِ'],
      audioPaths: [
        'soundus/Recording73.mp3',
        'soundus/Recording74.mp3',
        'soundus/Recording75.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'و',
      variants: ['وَ', 'وُ', 'وِ'],
      audioPaths: [
        'soundus/Recording76.mp3',
        'soundus/Recording77.mp3',
        'soundus/Recording78.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
    ArabicLetter(
      mainLetter: 'ي',
      variants: ['يَ', 'يُ', 'يِ'],
      audioPaths: [
        'soundus/Recording79.mp3',
        'soundus/Recording80.mp3',
        'soundus/Recording81.mp3',
      ],
      labels: ['Fatḥah', 'Damma', 'Kasrah'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.lime[300],

      appBar: AppBar(
        title: Text(
          l10n.learnArabicAlphabetTitle,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[600],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),

        itemCount: letters.length,

        itemBuilder: (context, index) {
          final letter = letters[index];

          return LetterTile(
            letter: letter.mainLetter,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LetterDetailScreen(
                    letter: letter,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// LETTER TILE
// ============================================================

class LetterTile extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;

  const LetterTile({
    super.key,
    required this.letter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],

          borderRadius:
          BorderRadius.circular(12),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        alignment: Alignment.center,

        child: Text(
          letter,
          textDirection: TextDirection.rtl,

          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LETTER DETAIL SCREEN
// ============================================================

class LetterDetailScreen extends StatefulWidget {
  final ArabicLetter letter;

  const LetterDetailScreen({
    super.key,
    required this.letter,
  });

  @override
  State<LetterDetailScreen> createState() =>
      _LetterDetailScreenState();
}

class _LetterDetailScreenState
    extends State<LetterDetailScreen> {

  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // ==========================================================
  // LOCALIZED HARAKAH LABEL
  // ==========================================================

  String _harakahLabel(
      AppLocalizations l10n,
      int index,
      ) {
    if (index == 0) {
      return l10n.fathahLabel;
    }

    if (index == 1) {
      return l10n.dammaLabel;
    }

    if (index == 2) {
      return l10n.kasrahLabel;
    }

    return widget.letter.labels[index];
  }

  // ==========================================================
  // PLAY AUDIO
  // ==========================================================

  Future<void> playSound(String path) async {
    try {
      await player.play(AssetSource(path));
    } catch (e) {
      debugPrint('Audio playback error: $e');

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.audioPlaybackError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================================
  // BUILD LETTER DETAIL
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.lime[300],

      appBar: AppBar(
        title: Text(
          l10n.learnLetterTitle(
            widget.letter.mainLetter,
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blueGrey[600],

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              for (int i = 0;
              i < widget.letter.variants.length;
              i++)

                Container(
                  margin: const EdgeInsets.all(8),

                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(12),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.5),

                        spreadRadius: 2,
                        blurRadius: 5,

                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Column(
                        children: [
                          Text(
                            _harakahLabel(l10n, i),

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            widget.letter.variants[i],

                            textDirection:
                            TextDirection.rtl,

                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      IconButton(
                        tooltip: l10n.playPronunciation,

                        icon: Icon(
                          Icons.volume_up,
                          color: Colors.blueGrey[600],
                        ),

                        onPressed: () => playSound(
                          widget.letter.audioPaths[i],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

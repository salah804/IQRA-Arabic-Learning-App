
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import 'package:aqra/api_config.dart';
import 'l10n/app_localizations.dart';

// ============================================================
// IQRA - BILINGUAL QUIZ 2
// ============================================================

// ============================================================
// FIND CORRECT ANSWER
// ============================================================

int getQuiz2CorrectAnswerIndex(List<dynamic> options) {
  for (int i = 0; i < options.length; i++) {
    final option = options[i];

    final flag =
    option is Map ? option['Answer_flag'] : null;

    if (flag == 1 || flag?.toString() == '1') {
      return i;
    }
  }

  return -1;
}

// ============================================================
// QUIZ 2
// ============================================================

class Quiz2 extends StatefulWidget {
  final int quizID;

  const Quiz2({
    super.key,
    required this.quizID,
  });

  @override
  State<Quiz2> createState() => _Quiz2State();
}

class _Quiz2State extends State<Quiz2> {

  // ==========================================================
  // QUIZ DATA
  // ==========================================================

  List<dynamic> questions = [];

  int currentQuestionIndex = 0;
  int _selectedAnswerIndex = -1;
  int totalScore = 0;

  bool _showResult = false;
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isSubmitting = false;
  bool _scoreSubmitted = false;
  bool _loadFailed = false;

  final AudioPlayer audioPlayer = AudioPlayer();

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    final hasCache = await _loadCachedQuiz();

    if (!mounted) return;

    await fetchQuizData(
      showErrors: !hasCache,
    );
  }

  // ==========================================================
  // LOCAL CACHE FILE
  // ==========================================================

  Future<File> _getQuizCacheFile() async {
    final directory =
    await getApplicationSupportDirectory();

    return File(
      '${directory.path}/quiz2_${widget.quizID}.json',
    );
  }

  // ==========================================================
  // LOAD CACHED QUIZ
  // ==========================================================

  Future<bool> _loadCachedQuiz() async {
    try {
      final file = await _getQuizCacheFile();

      if (!await file.exists()) {
        return false;
      }

      final cachedJson = await file.readAsString();

      if (cachedJson.trim().isEmpty) {
        return false;
      }

      final decoded = jsonDecode(cachedJson);

      final quiz =
      decoded is Map ? decoded['quiz'] : null;

      final cachedQuestions =
      quiz is Map ? quiz['questions'] : null;

      if (cachedQuestions is! List ||
          cachedQuestions.isEmpty) {
        return false;
      }

      if (!mounted) return false;

      setState(() {
        questions =
        List<dynamic>.from(cachedQuestions);

        _isLoading = false;
        _loadFailed = false;
      });

      debugPrint('QUIZ 2: Loaded from cache');

      return true;

    } catch (e) {
      debugPrint('QUIZ 2 CACHE LOAD ERROR: $e');
      return false;
    }
  }

  // ==========================================================
  // SAVE QUIZ TO CACHE
  // ==========================================================

  Future<void> _saveQuizCache(String jsonData) async {
    try {
      final file = await _getQuizCacheFile();

      await file.writeAsString(
        jsonData,
        flush: false,
      );

      debugPrint('QUIZ 2: Cache saved');

    } catch (e) {
      debugPrint('QUIZ 2 CACHE SAVE ERROR: $e');
    }
  }

  // ==========================================================
  // CHECK WHETHER STUDENT STARTED QUIZ
  // ==========================================================

  bool get _quizHasStarted =>
      currentQuestionIndex > 0 ||
          _selectedAnswerIndex >= 0 ||
          _showResult ||
          totalScore > 0;

  // ==========================================================
  // TOAST MESSAGE
  // ==========================================================

  void _showToast(
      String message, {
        Color color = Colors.red,
      }) {
    if (!mounted) return;

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // ==========================================================
  // FETCH QUIZ DATA FROM PHP
  // ==========================================================

  Future<void> fetchQuizData({
    bool showErrors = true,
  }) async {

    if (!mounted) return;

    if (questions.isEmpty) {
      setState(() {
        _isLoading = true;
        _loadFailed = false;
      });
    } else {
      setState(() {
        _isRefreshing = true;
      });
    }

    try {

      // ======================================================
      // ONLINE QUIZ 2 ENDPOINT
      // ======================================================

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/fetch_quiz2.php',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      // ======================================================
      // DECODE RESPONSE
      // ======================================================

      String responseBody =
      utf8.decode(response.bodyBytes);

      // Compatibility with older PHP output
      responseBody = responseBody.replaceFirst(
        'Connected successfully to the database!',
        '',
      ).trim();

      debugPrint(
        'QUIZ 2: Received '
            '${responseBody.length} characters',
      );

      final decoded = jsonDecode(responseBody);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid quiz response',
        );
      }

      if (decoded.containsKey('success') &&
          decoded['success'] != true) {
        throw const FormatException(
          'Quiz 2 server rejected request',
        );
      }

      final quiz = decoded['quiz'];

      final loadedQuestions =
      quiz is Map ? quiz['questions'] : null;

      if (loadedQuestions is! List ||
          loadedQuestions.isEmpty) {
        throw const FormatException(
          'Quiz 2 questions missing',
        );
      }

      // ======================================================
      // SAVE LATEST QUIZ FOR OFFLINE USE
      // ======================================================

      await _saveQuizCache(responseBody);

      if (!mounted) return;

      // Do not change active quiz questions
      // during a background refresh.
      if (questions.isEmpty || !_quizHasStarted) {
        setState(() {
          questions =
          List<dynamic>.from(loadedQuestions);

          _isLoading = false;
          _loadFailed = false;
        });
      }

      debugPrint('QUIZ 2: Server refresh successful');

    } catch (e) {
      debugPrint('QUIZ 2 FETCH ERROR: $e');

      if (!mounted) return;

      // Keep cached questions if online refresh fails.
      if (questions.isNotEmpty) {
        return;
      }

      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });

      if (showErrors) {
        _showToast(
          AppLocalizations.of(context)!
              .quiz2LoadShort,
        );
      }

    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;

          if (questions.isNotEmpty) {
            _isLoading = false;
          }
        });
      }
    }
  }

  // ==========================================================
  // SELECT AN ANSWER
  // ==========================================================

  void _selectAnswer(int index) {
    if (_showResult ||
        _isSubmitting ||
        _scoreSubmitted) {
      return;
    }

    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  // ==========================================================
  // SUBMIT ANSWER
  // ==========================================================

  void _submitAnswer() {
    if (_showResult ||
        questions.isEmpty ||
        _isSubmitting ||
        _scoreSubmitted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    if (_selectedAnswerIndex < 0) {
      _showToast(
        l10n.quizSelectAnswerFirst,
        color: Colors.orange,
      );
      return;
    }

    final question =
    questions[currentQuestionIndex];

    final options =
    question is Map ? question['options'] : null;

    if (options is! List) {
      _showToast(l10n.quizCorrectAnswerMissing);
      return;
    }

    final correctAnswerIndex =
    getQuiz2CorrectAnswerIndex(options);

    if (correctAnswerIndex < 0) {
      _showToast(l10n.quizCorrectAnswerMissing);
      return;
    }

    final isCorrect =
        _selectedAnswerIndex == correctAnswerIndex;

    setState(() {
      _showResult = true;

      if (isCorrect) {
        totalScore += 5;
      }
    });

    _showToast(
      isCorrect
          ? l10n.quizCorrectPoints
          : l10n.quizIncorrectAnswer,

      color: isCorrect
          ? Colors.green
          : Colors.red,
    );
  }

  // ==========================================================
  // CONTINUE QUIZ
  // ==========================================================

  Future<void> _continueQuiz() async {
    if (!_showResult ||
        _isSubmitting ||
        _scoreSubmitted) {
      return;
    }

    if (currentQuestionIndex <
        questions.length - 1) {

      setState(() {
        currentQuestionIndex++;
        _selectedAnswerIndex = -1;
        _showResult = false;
      });

    } else {

      _showToast(
        AppLocalizations.of(context)!
            .quizCompletedScore(totalScore),

        color: Colors.blueGrey,
      );

      await _submitScore();
    }
  }

  // ==========================================================
  // SUBMIT SCORE TO MYSQL
  // ==========================================================

  Future<void> _submitScore() async {
    if (_isSubmitting || _scoreSubmitted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final username =
          prefs.getString('username') ?? '';

      if (!mounted) return;

      if (username.isEmpty) {
        _showToast(
          AppLocalizations.of(context)!
              .quizUsernameNotFound,
        );
        return;
      }

      // ======================================================
      // ONLINE SCORE ENDPOINT
      // ======================================================

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/submit_score.php',
      );

      final response = await http.post(
        url,
        body: {
          'username': username,
          'quizID': widget.quizID.toString(),
          'score': totalScore.toString(),
        },
      ).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Score server error: ${response.statusCode}',
        );
      }

      final result = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (!mounted) return;

      // ======================================================
      // SCORE SAVED
      // ======================================================

      if (result is Map &&
          result['success'] == true) {

        setState(() {
          _scoreSubmitted = true;
        });

        _showToast(
          AppLocalizations.of(context)!
              .quiz2ScoreSaved,

          color: Colors.green,
        );

      } else {

        _showToast(
          AppLocalizations.of(context)!
              .quizScoreSaveFailed,
        );
      }

    } catch (e) {
      debugPrint('QUIZ 2 SCORE ERROR: $e');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .quizScoreNetworkError,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ==========================================================
  // PLAY BASE64 AUDIO
  // ==========================================================


  Future<void> _playSound(String base64Sound) async {
    try {
      if (base64Sound.trim().isEmpty) {
        return;
      }

      // Remove data URI prefix if present.
      String cleanBase64 = base64Sound.trim();

      if (cleanBase64.contains('base64,')) {
        cleanBase64 = cleanBase64.split('base64,').last;
      }

      // Remove whitespace.
      cleanBase64 = cleanBase64.replaceAll(
        RegExp(r'\s+'),
        '',
      );

      // Decode the Base64 audio.
      final Uint8List bytes = base64Decode(cleanBase64);

      // Stop previous audio.
      await audioPlayer.stop();

      if (kIsWeb) {

        // ==========================================
        // FLUTTER WEB AUDIO
        // ==========================================

        final String dataUrl = Uri.dataFromBytes(
          bytes,
          mimeType: 'audio/mpeg',
        ).toString();

        await audioPlayer.play(
          UrlSource(dataUrl),
        );

        debugPrint('QUIZ 2: Web audio started');

      } else {

        // ==========================================
        // ANDROID AUDIO
        // ==========================================

        await audioPlayer.play(
          BytesSource(bytes),
        );

        debugPrint('QUIZ 2: Android audio started');
      }

    } catch (e) {
      debugPrint('QUIZ 2 AUDIO ERROR: $e');

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.quizAudioError,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // ==========================================================
  // RETRY QUIZ LOADING
  // ==========================================================

  Future<void> _retryQuiz() async {
    await fetchQuizData(
      showErrors: true,
    );
  }

  // ==========================================================
  // BUILD QUIZ 2
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.lime[300],

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        title: Text(
          l10n.quizLabel(2),

          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blueGrey,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: Container(
        color: Colors.lime[300],

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        child: _isLoading && questions.isEmpty

        // ================================================
        // LOADING
        // ================================================

            ? const Center(
          child: CircularProgressIndicator(),
        )

        // ================================================
        // LOAD ERROR
        // ================================================

            : _loadFailed && questions.isEmpty

            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Icon(
                Icons.cloud_off,
                size: 65,
                color: Colors.blueGrey,
              ),

              const SizedBox(height: 15),

              Text(
                l10n.quiz2LoadError,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _retryQuiz,

                icon: const Icon(Icons.refresh),

                label: Text(l10n.quizTryAgain),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        )

        // ============================================
        // NO QUESTIONS
        // ============================================

            : questions.isEmpty

            ? Center(
          child: Text(
            l10n.quiz2NoQuestions,

            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        )

        // ========================================
        // QUIZ
        // ========================================

            : Column(
          children: [
            const SizedBox(height: 10),

            // ==================================
            // SCORE
            // ==================================

            Text(
              l10n.quizScoreSummary(
                totalScore,
                questions.length * 5,
              ),

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // ==================================
            // QUESTION NUMBER
            // ==================================

            Text(
              l10n.quizQuestionProgress(
                currentQuestionIndex + 1,
                questions.length,
              ),

              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            // ==================================
            // BACKGROUND REFRESH
            // ==================================

            if (_isRefreshing)
              const Padding(
                padding: EdgeInsets.only(
                  top: 6,
                ),

                child: SizedBox(
                  width: 16,
                  height: 16,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // ==================================
            // QUESTION CONTENT
            // ==================================

            Expanded(
              child: Quiz2Content(
                question: questions[
                currentQuestionIndex],

                selectedAnswerIndex:
                _selectedAnswerIndex,

                showResult: _showResult,

                isBusy: _isSubmitting ||
                    _scoreSubmitted,

                onSelectAnswer:
                _selectAnswer,

                onSubmitAnswer:
                _submitAnswer,

                onContinueQuiz:
                _continueQuiz,

                onPlaySound:
                _playSound,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}

// ============================================================
// QUIZ 2 CONTENT
// ============================================================

class Quiz2Content extends StatelessWidget {
  final dynamic question;

  final int selectedAnswerIndex;
  final bool showResult;
  final bool isBusy;

  final ValueChanged<int> onSelectAnswer;
  final VoidCallback onSubmitAnswer;

  final Future<void> Function() onContinueQuiz;
  final Future<void> Function(String) onPlaySound;

  const Quiz2Content({
    super.key,
    required this.question,
    required this.selectedAnswerIndex,
    required this.showResult,
    this.isBusy = false,
    required this.onSelectAnswer,
    required this.onSubmitAnswer,
    required this.onContinueQuiz,
    required this.onPlaySound,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final rawOptions =
    question is Map ? question['options'] : null;

    final List<dynamic> options =
    rawOptions is List
        ? rawOptions
        : <dynamic>[];

    final correctAnswerIndex =
    getQuiz2CorrectAnswerIndex(options);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,

        children: [

          const SizedBox(height: 10),

          // ==================================================
          // QUESTION FROM DATABASE
          // ==================================================

          Text(
            question is Map
                ? question['Text']?.toString() ?? ''
                : '',

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ==================================================
          // AUDIO BUTTON
          // ==================================================

          if (question is Map &&
              question['Sound'] != null &&
              question['Sound']
                  .toString()
                  .trim()
                  .isNotEmpty)

            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 20,
              ),

              alignment: Alignment.center,

              child: Tooltip(
                message: l10n.playPronunciation,

                child: InkWell(
                  borderRadius:
                  BorderRadius.circular(35),

                  onTap: () {
                    onPlaySound(
                      question['Sound'].toString(),
                    );
                  },

                  child: Container(
                    width: 65,
                    height: 65,

                    decoration: BoxDecoration(
                      color: Colors.blueGrey,

                      borderRadius:
                      BorderRadius.circular(35),
                    ),

                    child: const Icon(
                      Icons.volume_up,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // ==================================================
          // ANSWER OPTIONS
          // ==================================================

          for (int index = 0;
          index < options.length;
          index++)

            _buildOptionTile(
              options,
              index,
              correctAnswerIndex,
            ),

          // ==================================================
          // RESULT
          // ==================================================

          if (showResult) ...[
            const SizedBox(height: 15),

            Text(
              selectedAnswerIndex ==
                  correctAnswerIndex

                  ? l10n.quizAwesome

                  : correctAnswerIndex >= 0 &&
                  correctAnswerIndex <
                      options.length

                  ? l10n.quizIncorrectFeedback(
                options[correctAnswerIndex]
                is Map
                    ? options[
                correctAnswerIndex]
                ['OptionText']
                    ?.toString() ??
                    ''
                    : '',
              )

                  : l10n.quizIncorrectAnswer,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,

                color: selectedAnswerIndex ==
                    correctAnswerIndex
                    ? Colors.green[800]
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 20),

            // ================================================
            // CONTINUE
            // ================================================

            ElevatedButton(
              onPressed: isBusy
                  ? null
                  : () {
                onContinueQuiz();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),

              child: Text(
                l10n.quizContinue,

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

          ] else

          // ==================================================
          // SUBMIT ANSWER
          // ==================================================

            Padding(
              padding: const EdgeInsets.all(16),

              child: ElevatedButton(
                onPressed:
                selectedAnswerIndex >= 0 &&
                    !isBusy
                    ? onSubmitAnswer
                    : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,

                  disabledBackgroundColor:
                  Colors.grey.shade400,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),

                child: Text(
                  l10n.quizSubmitAnswer,

                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================================
  // ANSWER OPTION TILE
  // ==========================================================

  Widget _buildOptionTile(
      List<dynamic> options,
      int index,
      int correctAnswerIndex,
      ) {
    final option = options[index];

    final optionText = option is Map
        ? option['OptionText']?.toString() ?? ''
        : '';

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey;
    Color circleColor = Colors.grey;
    Color textColor = Colors.black;

    // ========================================================
    // ANSWER RESULT
    // ========================================================

    if (showResult) {
      if (index == correctAnswerIndex) {
        backgroundColor = Colors.green;
        borderColor = Colors.green;
        circleColor = Colors.green.shade800;
        textColor = Colors.white;

      } else if (index == selectedAnswerIndex) {
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        circleColor = Colors.red.shade800;
        textColor = Colors.white;
      }

    } else if (index == selectedAnswerIndex) {
      backgroundColor = Colors.blue;
      borderColor = Colors.blue;
      circleColor = Colors.blue.shade800;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: showResult || isBusy
          ? null
          : () => onSelectAnswer(index),

      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius:
          BorderRadius.circular(10),

          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),

        child: Row(
          children: [

            // ================================================
            // A, B, C, D
            // ================================================

            CircleAvatar(
              backgroundColor: circleColor,

              child: Text(
                String.fromCharCode(65 + index),

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ================================================
            // OPTION TEXT
            // ================================================

            Expanded(
              child: Text(
                optionText,

                style: TextStyle(
                  fontSize: 17,
                  color: textColor,
                ),
              ),
            ),

            // ================================================
            // CORRECT ANSWER ICON
            // ================================================

            if (showResult &&
                index == correctAnswerIndex)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),

            // ================================================
            // WRONG ANSWER ICON
            // ================================================

            if (showResult &&
                index == selectedAnswerIndex &&
                index != correctAnswerIndex)
              const Icon(
                Icons.cancel,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

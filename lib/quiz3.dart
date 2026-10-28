
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqra/api_config.dart';
import 'l10n/app_localizations.dart';

// ============================================================
// IQRA - BILINGUAL QUIZ 3
// MATCHING PAIRS
// ============================================================

class Quiz3 extends StatefulWidget {
  final int quizID;

  const Quiz3({
    super.key,
    required this.quizID,
  });

  @override
  State<Quiz3> createState() => _Quiz3State();
}

class _Quiz3State extends State<Quiz3> {

  // ==========================================================
  // QUIZ DATA
  // ==========================================================

  List<dynamic> questions = [];

  int currentQuestionIndex = 0;
  int selectedOption1 = -1;
  int selectedOption2 = -1;

  bool _showResult = false;
  bool _isCorrectMatch = true;
  bool _matchLocked = false;

  int totalScore = 0;

  final List<int> correctMatches = [];

  // ==========================================================
  // STATES
  // ==========================================================

  bool _isLoading = true;
  bool _loadFailed = false;
  bool _isSubmittingScore = false;
  bool _scoreSubmitted = false;

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  // ==========================================================
  // SHOW TOAST
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
  // FETCH QUIZ 3 FROM SERVER
  // ==========================================================

  Future<void> fetchQuizData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });

    try {

      // ======================================================
      // EXISTING PHP ENDPOINT
      // ======================================================

      final Uri url = Uri.parse(
        '${ApiConfig.baseUrl}/fetch_quiz3.php',
      );

      final http.Response response =
      await http.get(url).timeout(
        const Duration(seconds: 30),
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        throw Exception(
          'Quiz 3 HTTP ${response.statusCode}',
        );
      }

      // ======================================================
      // DECODE JSON
      // ======================================================

      String responseBody =
      utf8.decode(response.bodyBytes);

      responseBody = responseBody.replaceFirst(
        'Connected successfully to the database!',
        '',
      ).trim();

      debugPrint(
        'QUIZ 3 RESPONSE: '
            '${responseBody.length} characters',
      );

      final dynamic decoded =
      jsonDecode(responseBody);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid Quiz 3 response',
        );
      }

      if (decoded['success'] != true) {
        throw const FormatException(
          'Quiz 3 request failed',
        );
      }

      final dynamic quiz = decoded['quiz'];

      final dynamic loadedQuestions =
      quiz is Map ? quiz['questions'] : null;

      if (loadedQuestions is! List ||
          loadedQuestions.isEmpty) {
        throw const FormatException(
          'No Quiz 3 questions found',
        );
      }

      if (!mounted) return;

      // ======================================================
      // LOAD QUESTIONS
      // ======================================================

      setState(() {
        questions =
        List<dynamic>.from(loadedQuestions);

        currentQuestionIndex = 0;
        selectedOption1 = -1;
        selectedOption2 = -1;

        _showResult = false;
        _isCorrectMatch = true;
        _matchLocked = false;

        totalScore = 0;
        correctMatches.clear();

        _scoreSubmitted = false;
        _loadFailed = false;
      });

      debugPrint('QUIZ 3: Loaded successfully');

    } catch (e) {
      debugPrint('QUIZ 3 FETCH ERROR: $e');

      if (!mounted) return;

      setState(() {
        _loadFailed = true;
      });

      _showToast(
        AppLocalizations.of(context)!
            .quiz3LoadShort,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // SELECT MATCHING OPTIONS
  // ==========================================================

  void _selectOption(
      int index,
      bool isLeftSide,
      ) {

    if (_showResult ||
        _matchLocked ||
        _isSubmittingScore ||
        _scoreSubmitted ||
        questions.isEmpty) {
      return;
    }

    final dynamic question =
    questions[currentQuestionIndex];

    final dynamic rawOptions =
    question is Map ? question['options'] : null;

    if (rawOptions is! List) return;

    final List<dynamic> options = rawOptions;

    final int half = options.length ~/ 2;

    // Make sure left and right selections
    // always use their correct columns.
    if (isLeftSide) {
      if (index < 0 || index >= half) return;
    } else {
      if (index < half || index >= options.length) {
        return;
      }
    }

    if (correctMatches.contains(index)) return;

    setState(() {
      if (isLeftSide) {
        selectedOption1 = index;
      } else {
        selectedOption2 = index;
      }

      _isCorrectMatch = true;
    });

    // Wait until one item is selected
    // from each side.
    if (selectedOption1 == -1 ||
        selectedOption2 == -1) {
      return;
    }

    final dynamic option1 =
    options[selectedOption1];

    final dynamic option2 =
    options[selectedOption2];

    if (option1 is! Map || option2 is! Map) {
      return;
    }

    // ========================================================
    // MATCH USING THE EXISTING ANSWER_FLAG
    // ========================================================

    final int flag1 = int.tryParse(
      option1['Answer_flag'].toString(),
    ) ?? -1;

    final int flag2 = int.tryParse(
      option2['Answer_flag'].toString(),
    ) ?? -2;

    final bool correct =
        flag1 >= 0 && flag1 == flag2;

    setState(() {
      _isCorrectMatch = correct;
      _matchLocked = true;

      if (correct) {
        if (!correctMatches.contains(selectedOption1)) {
          correctMatches.add(selectedOption1);
        }

        if (!correctMatches.contains(selectedOption2)) {
          correctMatches.add(selectedOption2);
        }
      }
    });

    // Allow the student to see the result
    // before clearing the current selection.
    Future<void>.delayed(
      const Duration(seconds: 1),
    ).then((_) {

      if (!mounted) return;

      setState(() {
        selectedOption1 = -1;
        selectedOption2 = -1;
        _isCorrectMatch = true;
        _matchLocked = false;
      });
    });
  }

  // ==========================================================
  // CHECK WHETHER ALL PAIRS ARE MATCHED
  // ==========================================================

  bool allPairsCorrect() {
    if (questions.isEmpty ||
        currentQuestionIndex >= questions.length) {
      return false;
    }

    final dynamic question =
    questions[currentQuestionIndex];

    final dynamic options =
    question is Map ? question['options'] : null;

    if (options is! List ||
        options.isEmpty ||
        options.length.isOdd) {
      return false;
    }

    return correctMatches.length == options.length;
  }

  // ==========================================================
  // SUBMIT CURRENT QUESTION
  // ==========================================================

  void _submitAnswer() {
    if (_showResult ||
        _matchLocked ||
        _isSubmittingScore ||
        _scoreSubmitted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    if (!allPairsCorrect()) {
      _showToast(
        l10n.quiz3MatchAllPairs,
        color: Colors.orange,
      );
      return;
    }

    setState(() {
      _showResult = true;

      // Five points per completed question.
      totalScore += 5;
    });

    _showToast(
      l10n.quizCorrectPoints,
      color: Colors.green,
    );
  }

  // ==========================================================
  // CONTINUE TO NEXT QUESTION
  // ==========================================================

  Future<void> _continueQuiz() async {
    if (!_showResult ||
        _isSubmittingScore ||
        _scoreSubmitted) {
      return;
    }

    if (currentQuestionIndex <
        questions.length - 1) {

      setState(() {
        currentQuestionIndex++;

        _showResult = false;

        selectedOption1 = -1;
        selectedOption2 = -1;

        _isCorrectMatch = true;
        _matchLocked = false;

        correctMatches.clear();
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
  // SUBMIT FINAL SCORE
  // ==========================================================

  Future<void> _submitScore() async {
    if (_isSubmittingScore || _scoreSubmitted) {
      return;
    }

    setState(() {
      _isSubmittingScore = true;
    });

    try {

      // ======================================================
      // GET USERNAME
      // ======================================================

      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String username =
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
      // EXISTING SCORE API
      // ======================================================

      final Uri url = Uri.parse(
        '${ApiConfig.baseUrl}/submit_score.php',
      );

      final http.Response response =
      await http.post(
        url,

        body: {
          'username': username,
          'quizID': widget.quizID.toString(),
          'score': totalScore.toString(),
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        _showToast(
          AppLocalizations.of(context)!
              .serverErrorStatus(response.statusCode),
        );
        return;
      }

      // ======================================================
      // READ RESPONSE
      // ======================================================

      final dynamic decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is Map<String, dynamic> &&
          decoded['success'] == true) {

        setState(() {
          _scoreSubmitted = true;
        });

        _showToast(
          AppLocalizations.of(context)!
              .quiz3ScoreSaved,

          color: Colors.green,
        );

      } else {

        _showToast(
          AppLocalizations.of(context)!
              .quizScoreSaveFailed,
        );
      }

    } catch (e) {
      debugPrint('QUIZ 3 SCORE ERROR: $e');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .quizScoreNetworkError,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingScore = false;
        });
      }
    }
  }

  // ==========================================================
  // BUILD QUIZ 3
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.lime[300],

      appBar: AppBar(
        title: Text(
          l10n.quizLabel(3),

          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blueGrey,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: _isLoading

      // ==================================================
      // LOADING
      // ==================================================

          ? const Center(
        child: CircularProgressIndicator(),
      )

      // ==================================================
      // LOADING ERROR
      // ==================================================

          : _loadFailed && questions.isEmpty

          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

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
                l10n.quiz3LoadError,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: fetchQuizData,

                icon: const Icon(
                  Icons.refresh,
                ),

                label: Text(
                  l10n.quizTryAgain,
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )

      // ==============================================
      // NO QUESTIONS
      // ==============================================

          : questions.isEmpty

          ? Center(
        child: Text(
          l10n.quiz3NoQuestions,

          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      )

      // ==========================================
      // QUIZ CONTENT
      // ==========================================

          : Column(
        children: [

          // ====================================
          // SCORE AND QUESTION NUMBER
          // ====================================

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

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

                const SizedBox(height: 10),

                Text(
                  l10n.quizQuestionProgress(
                    currentQuestionIndex + 1,
                    questions.length,
                  ),

                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // ====================================
          // MATCHING CONTENT
          // ====================================

          Expanded(
            child: QuizContent(
              question: questions[
              currentQuestionIndex],

              selectedOption1:
              selectedOption1,

              selectedOption2:
              selectedOption2,

              showResult: _showResult,

              isCorrectMatch:
              _isCorrectMatch,

              correctMatches:
              correctMatches,

              isBusy: _isSubmittingScore ||
                  _scoreSubmitted ||
                  _matchLocked,

              onSelectOption:
              _selectOption,

              onSubmitAnswer:
              _submitAnswer,

              onContinueQuiz:
              _continueQuiz,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUIZ 3 MATCHING CONTENT
// ============================================================

class QuizContent extends StatelessWidget {
  final dynamic question;

  final int selectedOption1;
  final int selectedOption2;

  final bool showResult;
  final bool isCorrectMatch;
  final bool isBusy;

  final List<int> correctMatches;

  final void Function(int, bool) onSelectOption;
  final VoidCallback onSubmitAnswer;
  final VoidCallback onContinueQuiz;

  const QuizContent({
    super.key,

    required this.question,

    required this.selectedOption1,
    required this.selectedOption2,

    required this.showResult,
    required this.isCorrectMatch,

    required this.correctMatches,

    this.isBusy = false,

    required this.onSelectOption,
    required this.onSubmitAnswer,
    required this.onContinueQuiz,
  });

  // ==========================================================
  // CHECK ALL MATCHES
  // ==========================================================

  bool _allPairsCorrect(List<dynamic> options) {
    return options.isNotEmpty &&
        options.length.isEven &&
        correctMatches.length == options.length;
  }

  // ==========================================================
  // BUILD ONE OPTION TILE
  // ==========================================================

  Widget _buildMatchingTile({
    required Map<dynamic, dynamic> option,
    required int index,
    required bool isLeftSide,
  }) {

    final bool isSelected =
    isLeftSide
        ? selectedOption1 == index
        : selectedOption2 == index;

    final bool isMatched =
    correctMatches.contains(index);

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey;
    Color circleColor = Colors.grey;
    Color textColor = Colors.black;

    // ========================================================
    // MATCHED
    // ========================================================

    if (isMatched) {
      backgroundColor = Colors.lightGreen;
      borderColor = Colors.green;
      circleColor = Colors.green;
      textColor = Colors.white;

    } else if (isSelected) {

      if (isCorrectMatch) {
        backgroundColor = Colors.blue;
        borderColor = Colors.blue;
        circleColor = Colors.blue;
      } else {
        backgroundColor = Colors.red;
        borderColor = Colors.red;
        circleColor = Colors.red;
      }

      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: showResult || isBusy || isMatched
          ? null
          : () => onSelectOption(
        index,
        isLeftSide,
      ),

      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),

        padding: const EdgeInsets.all(8),

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius:
          BorderRadius.circular(8),

          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),

        child: Row(
          children: [

            // ================================================
            // OPTION LETTER
            // ================================================

            CircleAvatar(
              backgroundColor: circleColor,

              child: Text(
                String.fromCharCode(65 + index),

                style: TextStyle(
                  color: isMatched || isSelected
                      ? Colors.white
                      : Colors.black,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ================================================
            // OPTION TEXT
            // ================================================

            Expanded(
              child: Text(
                option['OptionText']
                    ?.toString() ??
                    '',

                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),

            if (isMatched)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD MATCHING SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final dynamic rawOptions =
    question is Map ? question['options'] : null;

    final List<dynamic> options =
    rawOptions is List
        ? rawOptions
        : <dynamic>[];

    final int half = options.length ~/ 2;

    final bool validOptions =
        options.isNotEmpty && options.length.isEven;

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,

        children: [

          // ==================================================
          // QUESTION FROM MYSQL
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

          const SizedBox(height: 20),

          // ==================================================
          // MATCHING OPTIONS
          // ==================================================

          Expanded(
            child: !validOptions
                ? Center(
              child: Text(
                l10n.quiz3InvalidPairs,

                textAlign: TextAlign.center,
              ),
            )

                : Row(
              children: [

                // ======================================
                // LEFT COLUMN
                // ======================================

                Expanded(
                  child: ListView.builder(
                    itemCount: half,

                    itemBuilder: (context, index) {
                      final dynamic option =
                      options[index];

                      if (option is! Map) {
                        return const SizedBox.shrink();
                      }

                      return _buildMatchingTile(
                        option: option,
                        index: index,
                        isLeftSide: true,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // ======================================
                // RIGHT COLUMN
                // ======================================

                Expanded(
                  child: ListView.builder(
                    itemCount: half,

                    itemBuilder: (context, index) {
                      final int actualIndex =
                          index + half;

                      final dynamic option =
                      options[actualIndex];

                      if (option is! Map) {
                        return const SizedBox.shrink();
                      }

                      return _buildMatchingTile(
                        option: option,
                        index: actualIndex,
                        isLeftSide: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // MATCHING RESULT
          // ==================================================

          if (showResult) ...[

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [

                  Text(
                    l10n.quiz3AllPairsCorrect,

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: isBusy
                        ? null
                        : onContinueQuiz,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,

                      padding:
                      const EdgeInsets.symmetric(
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
                ],
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
                _allPairsCorrect(options) &&
                    !isBusy
                    ? onSubmitAnswer
                    : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,

                  disabledBackgroundColor:
                  Colors.grey.shade400,

                  padding:
                  const EdgeInsets.symmetric(
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
        ],
      ),
    );
  }
}

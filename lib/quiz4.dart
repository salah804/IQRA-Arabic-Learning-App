
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'l10n/app_localizations.dart';
import 'l10n/app_localizations_en.dart';
import 'l10n/app_localizations_ar.dart';

// ============================================================
// IQRA - BILINGUAL PRONUNCIATION PRACTICE
// ANDROID + DESKTOP WEB + MOBILE WEB
// ============================================================

enum _SpeechStatus {
  preparing,
  ready,
  listening,
  noSpeech,
  complete,
  retry,
  unavailable,
}

enum _SpeechError {
  timeout,
  noMatch,
  network,
  audio,
  permission,
  general,
  initialization,
  start,
  unavailable,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ==========================================================
  // SPEECH RECOGNITION
  // ==========================================================

  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  bool _isInitializing = true;

  String _wordsSpoken = '';

  // Null means the platform did not provide
  // a valid confidence rating.
  double? _confidenceLevel;

  // ==========================================================
  // SELECTED LANGUAGE
  // ==========================================================

  String _selectedLanguage = 'Arabic';

  // Preserve the existing recognition locales.
  String _localeId = 'ar-SA';

  bool get _isArabic => _selectedLanguage == 'Arabic';

  // Screen translations follow the dropdown.
  AppLocalizations get _screenL10n {
    return _isArabic
        ? AppLocalizationsAr()
        : AppLocalizationsEn();
  }

  TextDirection get _screenDirection {
    return _isArabic
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // ==========================================================
  // NEW: BILINGUAL CONFIDENCE FALLBACK
  // No ARB changes required.
  // ==========================================================

  String get _confidenceUnavailableText {
    return _isArabic
        ? 'مستوى الثقة غير متاح في هذا المتصفح.'
        : 'Confidence is not available in this browser.';
  }

  // ==========================================================
  // STATUS AND ERRORS
  // ==========================================================

  _SpeechStatus _status = _SpeechStatus.preparing;
  _SpeechError? _error;

  String _statusText(AppLocalizations l10n) {
    switch (_status) {
      case _SpeechStatus.preparing:
        return l10n.speechPreparing;

      case _SpeechStatus.ready:
        return l10n.speechTapToSpeak;

      case _SpeechStatus.listening:
        return l10n.speechListeningNow;

      case _SpeechStatus.noSpeech:
        return l10n.speechNoSpeechDetected;

      case _SpeechStatus.complete:
        return l10n.speechRecognitionComplete;

      case _SpeechStatus.retry:
        return l10n.speechTapToTryAgain;

      case _SpeechStatus.unavailable:
        return l10n.speechUnavailable;
    }
  }

  String? _errorText(AppLocalizations l10n) {
    switch (_error) {
      case _SpeechError.timeout:
        return l10n.speechErrorTimeout;

      case _SpeechError.noMatch:
        return l10n.speechErrorNoMatch;

      case _SpeechError.network:
        return l10n.speechErrorNetwork;

      case _SpeechError.audio:
        return l10n.speechErrorAudio;

      case _SpeechError.permission:
        return l10n.speechErrorPermission;

      case _SpeechError.general:
        return l10n.speechErrorGeneric;

      case _SpeechError.initialization:
        return l10n.speechInitializationFailed;

      case _SpeechError.start:
        return l10n.speechUnableStart;

      case _SpeechError.unavailable:
        return l10n.speechUnavailable;

      case null:
        return null;
    }
  }

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final bool available =
      await _speechToText.initialize(
        onStatus: _onSpeechStatus,

        onError: (error) {
          debugPrint(
            'Speech recognition error: ${error.errorMsg}',
          );

          if (!mounted) return;

          _SpeechError errorType;

          switch (error.errorMsg) {
            case 'error_speech_timeout':
              errorType = _SpeechError.timeout;
              break;

            case 'error_no_match':
              errorType = _SpeechError.noMatch;
              break;

            case 'error_network':
              errorType = _SpeechError.network;
              break;

            case 'error_audio':
              errorType = _SpeechError.audio;
              break;

            case 'error_permission':
              errorType = _SpeechError.permission;
              break;

            default:
              errorType = _SpeechError.general;
          }

          setState(() {
            _error = errorType;

            if (_wordsSpoken.isEmpty) {
              _status = _SpeechStatus.retry;
            }
          });
        },
      );

      if (!mounted) return;

      setState(() {
        _speechEnabled = available;
        _isInitializing = false;

        _status = available
            ? _SpeechStatus.ready
            : _SpeechStatus.unavailable;
      });

      debugPrint('Speech available: $_speechEnabled');
      debugPrint('Speech locale: $_localeId');
    } catch (e) {
      debugPrint('Speech initialization error: $e');

      if (!mounted) return;

      setState(() {
        _speechEnabled = false;
        _isInitializing = false;

        _status = _SpeechStatus.unavailable;
        _error = _SpeechError.initialization;
      });
    }
  }

  // ==========================================================
  // CHANGE LANGUAGE
  // ==========================================================

  void _changeLanguage(String? value) {
    if (value == null || _speechToText.isListening) {
      return;
    }

    setState(() {
      _selectedLanguage = value;

      if (value == 'Arabic') {
        _localeId = 'ar-SA';
      } else {
        _localeId = 'en_US';
      }

      _wordsSpoken = '';
      _confidenceLevel = null;
      _error = null;

      _status = _speechEnabled
          ? _SpeechStatus.ready
          : _SpeechStatus.unavailable;
    });

    debugPrint(
      'Pronunciation language: $_selectedLanguage',
    );

    debugPrint('Recognition locale: $_localeId');
  }

  // ==========================================================
  // SPEECH STATUS
  // ==========================================================

  void _onSpeechStatus(String status) {
    debugPrint('Speech status: $status');

    if (!mounted) return;

    setState(() {
      if (status == 'listening') {
        _status = _SpeechStatus.listening;
      } else if (status == 'done') {
        _status = _wordsSpoken.trim().isEmpty
            ? _SpeechStatus.noSpeech
            : _SpeechStatus.complete;
      } else if (status == 'notListening') {
        if (_error == null) {
          _status = _wordsSpoken.trim().isEmpty
              ? _SpeechStatus.ready
              : _SpeechStatus.complete;
        }
      }
    });
  }

  // ==========================================================
  // START LISTENING
  // ==========================================================

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      setState(() {
        _error = _SpeechError.unavailable;
      });
      return;
    }

    if (_speechToText.isListening) return;

    setState(() {
      _wordsSpoken = '';
      _confidenceLevel = null;
      _error = null;

      _status = _SpeechStatus.listening;
    });

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _localeId,

        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),

        partialResults: true,
        cancelOnError: false,
      );

      if (!mounted) return;

      setState(() {});
    } catch (e) {
      debugPrint('Start listening error: $e');

      if (!mounted) return;

      setState(() {
        _error = _SpeechError.start;
        _status = _SpeechStatus.retry;
      });
    }
  }

  // ==========================================================
  // STOP LISTENING
  // ==========================================================

  Future<void> _stopListening() async {
    try {
      await _speechToText.stop();

      if (!mounted) return;

      setState(() {
        _status = _wordsSpoken.trim().isEmpty
            ? _SpeechStatus.retry
            : _SpeechStatus.complete;
      });
    } catch (e) {
      debugPrint('Stop listening error: $e');
    }
  }

  // ==========================================================
  // UPDATED: SPEECH RESULT
  //
  // Do not assume every browser returns confidence.
  // Do not invent a value when one is unavailable.
  // ==========================================================

  void _onSpeechResult(
      SpeechRecognitionResult result,
      ) {
    if (!mounted) return;

    final double rating = result.confidence;

    final bool hasValidConfidence =
        result.hasConfidenceRating &&
            rating.isFinite &&
            rating >= 0.0 &&
            rating <= 1.0;

    setState(() {
      _wordsSpoken = result.recognizedWords;

      // Keep actual confidence only when supplied.
      _confidenceLevel =
      hasValidConfidence ? rating : null;

      if (result.finalResult &&
          _wordsSpoken.trim().isNotEmpty) {
        _status = _SpeechStatus.complete;
      }
    });

    debugPrint(
      'Recognized words: ${result.recognizedWords}',
    );

    debugPrint(
      'Confidence available: $hasValidConfidence',
    );

    if (hasValidConfidence) {
      debugPrint(
        'Confidence: ${(rating * 100).toStringAsFixed(1)}%',
      );
    }
  }

  // ==========================================================
  // CLEAR RECOGNIZED TEXT
  // ==========================================================

  void _clearText() {
    setState(() {
      _wordsSpoken = '';
      _confidenceLevel = null;
      _error = null;

      _status = _speechEnabled
          ? _SpeechStatus.ready
          : _SpeechStatus.unavailable;
    });
  }

  // ==========================================================
  // COPY RECOGNIZED TEXT
  // ==========================================================

  Future<void> _copyText() async {
    if (_wordsSpoken.trim().isEmpty) return;

    await Clipboard.setData(
      ClipboardData(text: _wordsSpoken),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _screenL10n.speechTextCopied,
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ==========================================================
  // LANGUAGE SELECTOR
  // ==========================================================

  Widget _buildLanguageSelector(
      AppLocalizations l10n,
      bool isListening,
      ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [
          const Icon(
            Icons.language,
            color: Colors.blueGrey,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.speechRecognitionLanguageLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey,
                  ),
                ),

                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,

                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Arabic',
                        child: Text('العربية - Arabic'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'English',
                        child: Text('English'),
                      ),
                    ],

                    onChanged: isListening
                        ? null
                        : _changeLanguage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATUS CARD
  // ==========================================================

  Widget _buildStatusCard(
      AppLocalizations l10n,
      bool isListening,
      ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: isListening
            ? Colors.blueGrey.shade700
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(
            isListening
                ? Icons.graphic_eq
                : Icons.record_voice_over_outlined,
            color: isListening
                ? Colors.white
                : Colors.blueGrey,
            size: 30,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              _statusText(l10n),
              style: TextStyle(
                color: isListening
                    ? Colors.white
                    : Colors.blueGrey.shade800,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR CARD
  // ==========================================================

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(message),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RECOGNIZED TEXT CARD
  // ==========================================================

  Widget _buildRecognizedTextCard(
      AppLocalizations l10n,
      ) {
    final bool hasWords =
        _wordsSpoken.trim().isNotEmpty;

    return Container(
      width: double.infinity,

      constraints: const BoxConstraints(
        minHeight: 190,
      ),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.text_fields,
                color: Colors.blueGrey,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  l10n.speechRecognizedText,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              if (hasWords)
                IconButton(
                  onPressed: _copyText,
                  tooltip: l10n.speechCopy,
                  icon: const Icon(Icons.copy),
                ),

              if (hasWords)
                IconButton(
                  onPressed: _clearText,
                  tooltip: l10n.speechClear,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),

          const Divider(),
          const SizedBox(height: 10),

          Directionality(
            textDirection: _screenDirection,

            child: Text(
              hasWords
                  ? _wordsSpoken
                  : l10n.speechPlaceholder,

              textAlign: _isArabic
                  ? TextAlign.right
                  : TextAlign.left,

              style: TextStyle(
                fontSize: _isArabic ? 32 : 25,
                height: 1.6,
                fontWeight: FontWeight.w500,

                color: hasWords
                    ? Colors.black87
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // UPDATED: CONFIDENCE CARD
  //
  // Desktop / Android:
  //   Show actual percentage if available.
  //
  // Mobile Web:
  //   Show bilingual unavailable message when needed.
  // ==========================================================

  Widget _buildConfidenceCard(
      AppLocalizations l10n,
      ) {
    final double? confidence = _confidenceLevel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: Colors.blueGrey,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  l10n.speechRecognitionConfidence,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
              ),

              if (confidence != null)
                Text(
                  '${(confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (confidence != null)
            LinearProgressIndicator(
              value: confidence,
              minHeight: 8,
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.blueGrey,
                  size: 20,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    _confidenceUnavailableText,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // MICROPHONE CONTROL
  // ==========================================================

  Widget _buildMicrophone(
      AppLocalizations l10n,
      bool isListening,
      ) {
    return Column(
      children: [
        GestureDetector(
          onTap: !_speechEnabled
              ? null
              : isListening
              ? _stopListening
              : _startListening,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),

            width: isListening ? 105 : 90,
            height: isListening ? 105 : 90,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: !_speechEnabled
                  ? Colors.grey
                  : isListening
                  ? Colors.redAccent
                  : Colors.blueGrey.shade700,

              boxShadow: [
                BoxShadow(
                  color: (isListening
                      ? Colors.red
                      : Colors.blueGrey)
                      .withOpacity(0.30),

                  blurRadius: 20,
                  spreadRadius: isListening ? 7 : 2,
                ),
              ],
            ),

            child: Icon(
              isListening
                  ? Icons.stop
                  : Icons.mic,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),

        const SizedBox(height: 15),

        Text(
          isListening
              ? l10n.speechTapToStop
              : l10n.speechTapToSpeak,

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade800,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // BUILD SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = _screenL10n;

    final bool isListening = _speechToText.isListening;
    final String? errorMessage = _errorText(l10n);

    final bool hasRecognizedWords =
        _wordsSpoken.trim().isNotEmpty;

    return Directionality(
      textDirection: _screenDirection,

      child: Scaffold(
        backgroundColor: Colors.lime[300],

        appBar: AppBar(
          backgroundColor: const Color(0xFF607D8B),
          elevation: 0,
          centerTitle: true,

          iconTheme: const IconThemeData(
            color: Colors.white,
          ),

          title: Text(
            l10n.speechPronunciationTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: SafeArea(
          child: _isInitializing
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey[700],
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                _buildLanguageSelector(
                  l10n,
                  isListening,
                ),

                const SizedBox(height: 25),

                _buildStatusCard(
                  l10n,
                  isListening,
                ),

                if (errorMessage != null) ...[
                  const SizedBox(height: 15),
                  _buildErrorCard(errorMessage),
                ],

                const SizedBox(height: 25),

                _buildRecognizedTextCard(l10n),

                const SizedBox(height: 20),

                // ====================================
                // FIX:
                // Always display confidence section
                // once recognized text is available.
                // ====================================

                if (hasRecognizedWords)
                  _buildConfidenceCard(l10n),

                const SizedBox(height: 35),

                _buildMicrophone(
                  l10n,
                  isListening,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Learn Arabic step by step'**
  String get appTagline;

  /// No description provided for @drawerTagline.
  ///
  /// In en, this message translates to:
  /// **'Arabic Learning App'**
  String get drawerTagline;

  /// No description provided for @learnArabic.
  ///
  /// In en, this message translates to:
  /// **'Learn Arabic'**
  String get learnArabic;

  /// No description provided for @alphabetAndLessons.
  ///
  /// In en, this message translates to:
  /// **'Alphabet & lessons'**
  String get alphabetAndLessons;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'View or update your profile'**
  String get profileDescription;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get changePasswordDescription;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @checkForUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check for a newer IQRA version'**
  String get checkForUpdatesDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose English or Arabic'**
  String get languageDescription;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @footer.
  ///
  /// In en, this message translates to:
  /// **'IQRA • Learn Arabic with confidence'**
  String get footer;

  /// No description provided for @welcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to IQRA 👋'**
  String get welcomeHome;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn Arabic letters, practice quizzes and improve your pronunciation.'**
  String get welcomeDescription;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @startLearningDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn the Arabic alphabet and pronunciation'**
  String get startLearningDescription;

  /// No description provided for @arabicAlphabet.
  ///
  /// In en, this message translates to:
  /// **'Arabic Alphabet'**
  String get arabicAlphabet;

  /// No description provided for @arabicAlphabetDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn Arabic letters, sounds and Harakat.'**
  String get arabicAlphabetDescription;

  /// No description provided for @practiceQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Practice Quizzes'**
  String get practiceQuizzes;

  /// No description provided for @practiceQuizzesDescription.
  ///
  /// In en, this message translates to:
  /// **'Test what you have learned'**
  String get practiceQuizzesDescription;

  /// No description provided for @quiz1Instruction.
  ///
  /// In en, this message translates to:
  /// **'Choose the correct answer'**
  String get quiz1Instruction;

  /// No description provided for @quiz2Instruction.
  ///
  /// In en, this message translates to:
  /// **'Listen and choose the answer'**
  String get quiz2Instruction;

  /// No description provided for @quiz3Instruction.
  ///
  /// In en, this message translates to:
  /// **'Select the matching pairs'**
  String get quiz3Instruction;

  /// No description provided for @quiz4Instruction.
  ///
  /// In en, this message translates to:
  /// **'Practice Arabic pronunciation'**
  String get quiz4Instruction;

  /// No description provided for @motivation.
  ///
  /// In en, this message translates to:
  /// **'Practice a little every day to improve your Arabic faster.'**
  String get motivation;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @startLesson.
  ///
  /// In en, this message translates to:
  /// **'Start Lesson'**
  String get startLesson;

  /// No description provided for @quizLabel.
  ///
  /// In en, this message translates to:
  /// **'Quiz {number}'**
  String quizLabel(int number);

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to IQRA!'**
  String get welcome;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @quizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordButton;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful.'**
  String get loginSuccessful;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password.'**
  String get invalidCredentials;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid response received from server.'**
  String get invalidServerResponse;

  /// No description provided for @serverErrorStatus.
  ///
  /// In en, this message translates to:
  /// **'Server error: {statusCode}'**
  String serverErrorStatus(int statusCode);

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @femaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleLabel;

  /// No description provided for @maleLabel.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed.'**
  String get registrationFailed;

  /// No description provided for @connectionTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please check your internet connection.'**
  String get connectionTimedOut;

  /// No description provided for @unableToConnect.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection.'**
  String get unableToConnect;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get enterEmail;

  /// No description provided for @emailFound.
  ///
  /// In en, this message translates to:
  /// **'Email found.'**
  String get emailFound;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email does not exist.'**
  String get emailNotFound;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @checkEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Check Email'**
  String get checkEmailButton;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordMinLength;

  /// No description provided for @resetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful.'**
  String get resetSuccessful;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password.'**
  String get resetFailed;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordLabel;

  /// No description provided for @usernameMissing.
  ///
  /// In en, this message translates to:
  /// **'Username is missing. Please login again.'**
  String get usernameMissing;

  /// No description provided for @newPasswordMustDiffer.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from the current password.'**
  String get newPasswordMustDiffer;

  /// No description provided for @changePasswordSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get changePasswordSuccessful;

  /// No description provided for @changePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password.'**
  String get changePasswordFailed;

  /// No description provided for @refreshProfile.
  ///
  /// In en, this message translates to:
  /// **'Refresh Profile'**
  String get refreshProfile;

  /// No description provided for @addProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Profile Photo'**
  String get addProfilePhoto;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile. Check your internet connection.'**
  String get profileLoadFailed;

  /// No description provided for @profileFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all profile fields.'**
  String get profileFieldsRequired;

  /// No description provided for @profileUpdateSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdateSuccessful;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profileUpdateFailed;

  /// No description provided for @profileUpdateNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile. Check your internet connection.'**
  String get profileUpdateNetworkError;

  /// No description provided for @profileImagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to select image.'**
  String get profileImagePickFailed;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully.'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image.'**
  String get profilePhotoUploadFailed;

  /// No description provided for @profilePhotoUploadNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to upload image. Check your internet connection.'**
  String get profilePhotoUploadNetworkError;

  /// No description provided for @learnArabicAlphabetTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Arabic Alphabet'**
  String get learnArabicAlphabetTitle;

  /// No description provided for @learnLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn {letter}'**
  String learnLetterTitle(String letter);

  /// No description provided for @fathahLabel.
  ///
  /// In en, this message translates to:
  /// **'Fatḥah'**
  String get fathahLabel;

  /// No description provided for @dammaLabel.
  ///
  /// In en, this message translates to:
  /// **'Damma'**
  String get dammaLabel;

  /// No description provided for @kasrahLabel.
  ///
  /// In en, this message translates to:
  /// **'Kasrah'**
  String get kasrahLabel;

  /// No description provided for @playPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Play pronunciation'**
  String get playPronunciation;

  /// No description provided for @audioPlaybackError.
  ///
  /// In en, this message translates to:
  /// **'Unable to play the audio. Please try again.'**
  String get audioPlaybackError;

  /// No description provided for @quiz1LoadShort.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Quiz 1.'**
  String get quiz1LoadShort;

  /// No description provided for @quiz1LoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Quiz 1. Please check your internet connection and try again.'**
  String get quiz1LoadError;

  /// No description provided for @quizNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No Quiz 1 questions found.'**
  String get quizNoQuestions;

  /// No description provided for @quizTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get quizTryAgain;

  /// No description provided for @quizScoreSummary.
  ///
  /// In en, this message translates to:
  /// **'Score: {score} / {maxScore}'**
  String quizScoreSummary(int score, int maxScore);

  /// No description provided for @quizQuestionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizQuestionProgress(int current, int total);

  /// No description provided for @quizSelectAnswerFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an answer first.'**
  String get quizSelectAnswerFirst;

  /// No description provided for @quizCorrectAnswerMissing.
  ///
  /// In en, this message translates to:
  /// **'Correct answer could not be found.'**
  String get quizCorrectAnswerMissing;

  /// No description provided for @quizCorrectPoints.
  ///
  /// In en, this message translates to:
  /// **'Correct! +5 points'**
  String get quizCorrectPoints;

  /// No description provided for @quizIncorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer.'**
  String get quizIncorrectAnswer;

  /// No description provided for @quizCompletedScore.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed! Your score: {score}'**
  String quizCompletedScore(int score);

  /// No description provided for @quizUsernameNotFound.
  ///
  /// In en, this message translates to:
  /// **'Username not found. Please login again.'**
  String get quizUsernameNotFound;

  /// No description provided for @quizScoreSaved.
  ///
  /// In en, this message translates to:
  /// **'Quiz 1 score saved successfully.'**
  String get quizScoreSaved;

  /// No description provided for @quizScoreSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save score.'**
  String get quizScoreSaveFailed;

  /// No description provided for @quizScoreNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save score. Check your internet connection.'**
  String get quizScoreNetworkError;

  /// No description provided for @quizAudioError.
  ///
  /// In en, this message translates to:
  /// **'Unable to play sound.'**
  String get quizAudioError;

  /// No description provided for @quizAwesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get quizAwesome;

  /// No description provided for @quizIncorrectFeedback.
  ///
  /// In en, this message translates to:
  /// **'Incorrect. The correct answer is {answer}.'**
  String quizIncorrectFeedback(String answer);

  /// No description provided for @quizContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get quizContinue;

  /// No description provided for @quizSubmitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get quizSubmitAnswer;

  /// No description provided for @quiz2LoadShort.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Quiz 2.'**
  String get quiz2LoadShort;

  /// No description provided for @quiz2LoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Quiz 2. Please check your internet connection and try again.'**
  String get quiz2LoadError;

  /// No description provided for @quiz2NoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No Quiz 2 questions found.'**
  String get quiz2NoQuestions;

  /// No description provided for @quiz2ScoreSaved.
  ///
  /// In en, this message translates to:
  /// **'Quiz 2 score saved successfully.'**
  String get quiz2ScoreSaved;

  /// No description provided for @quiz3LoadShort.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Quiz 3.'**
  String get quiz3LoadShort;

  /// No description provided for @quiz3LoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Quiz 3. Please check your internet connection and try again.'**
  String get quiz3LoadError;

  /// No description provided for @quiz3NoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No Quiz 3 questions found.'**
  String get quiz3NoQuestions;

  /// No description provided for @quiz3MatchAllPairs.
  ///
  /// In en, this message translates to:
  /// **'Please match all pairs correctly first.'**
  String get quiz3MatchAllPairs;

  /// No description provided for @quiz3AllPairsCorrect.
  ///
  /// In en, this message translates to:
  /// **'Awesome! All pairs are correct.'**
  String get quiz3AllPairsCorrect;

  /// No description provided for @quiz3ScoreSaved.
  ///
  /// In en, this message translates to:
  /// **'Quiz 3 score saved successfully.'**
  String get quiz3ScoreSaved;

  /// No description provided for @quiz3InvalidPairs.
  ///
  /// In en, this message translates to:
  /// **'The matching pairs could not be displayed. Please try again.'**
  String get quiz3InvalidPairs;

  /// No description provided for @speechPronunciationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation Practice'**
  String get speechPronunciationTitle;

  /// No description provided for @speechRecognitionLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition language'**
  String get speechRecognitionLanguageLabel;

  /// No description provided for @speechPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing speech recognition...'**
  String get speechPreparing;

  /// No description provided for @speechTapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap the microphone to speak'**
  String get speechTapToSpeak;

  /// No description provided for @speechListeningNow.
  ///
  /// In en, this message translates to:
  /// **'Listening... speak now'**
  String get speechListeningNow;

  /// No description provided for @speechNoSpeechDetected.
  ///
  /// In en, this message translates to:
  /// **'No speech detected. Try again.'**
  String get speechNoSpeechDetected;

  /// No description provided for @speechRecognitionComplete.
  ///
  /// In en, this message translates to:
  /// **'Recognition complete'**
  String get speechRecognitionComplete;

  /// No description provided for @speechTapToTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Tap the microphone to try again'**
  String get speechTapToTryAgain;

  /// No description provided for @speechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available.'**
  String get speechUnavailable;

  /// No description provided for @speechRecognizedText.
  ///
  /// In en, this message translates to:
  /// **'Recognized Text'**
  String get speechRecognizedText;

  /// No description provided for @speechPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your speech will appear here'**
  String get speechPlaceholder;

  /// No description provided for @speechRecognitionConfidence.
  ///
  /// In en, this message translates to:
  /// **'Recognition confidence'**
  String get speechRecognitionConfidence;

  /// No description provided for @speechTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get speechTapToStop;

  /// No description provided for @speechCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get speechCopy;

  /// No description provided for @speechClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get speechClear;

  /// No description provided for @speechTextCopied.
  ///
  /// In en, this message translates to:
  /// **'Recognized text copied'**
  String get speechTextCopied;

  /// No description provided for @speechErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'No speech detected. Try again.'**
  String get speechErrorTimeout;

  /// No description provided for @speechErrorNoMatch.
  ///
  /// In en, this message translates to:
  /// **'I could not understand that. Try again.'**
  String get speechErrorNoMatch;

  /// No description provided for @speechErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get speechErrorNetwork;

  /// No description provided for @speechErrorAudio.
  ///
  /// In en, this message translates to:
  /// **'There was a microphone problem.'**
  String get speechErrorAudio;

  /// No description provided for @speechErrorPermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required.'**
  String get speechErrorPermission;

  /// No description provided for @speechErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'A speech recognition error occurred.'**
  String get speechErrorGeneric;

  /// No description provided for @speechInitializationFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to initialize speech recognition.'**
  String get speechInitializationFailed;

  /// No description provided for @speechUnableStart.
  ///
  /// In en, this message translates to:
  /// **'Unable to start listening. Try again.'**
  String get speechUnableStart;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

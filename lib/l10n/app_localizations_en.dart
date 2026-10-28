import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Learn Arabic step by step';

  @override
  String get drawerTagline => 'Arabic Learning App';

  @override
  String get learnArabic => 'Learn Arabic';

  @override
  String get alphabetAndLessons => 'Alphabet & lessons';

  @override
  String get profile => 'Profile';

  @override
  String get profileDescription => 'View or update your profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordDescription => 'Update your password';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checkForUpdatesDescription => 'Check for a newer IQRA version';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Choose English or Arabic';

  @override
  String get logout => 'Logout';

  @override
  String get footer => 'IQRA • Learn Arabic with confidence';

  @override
  String get welcomeHome => 'Welcome to IQRA 👋';

  @override
  String get welcomeDescription => 'Learn Arabic letters, practice quizzes and improve your pronunciation.';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get startLearningDescription => 'Learn the Arabic alphabet and pronunciation';

  @override
  String get arabicAlphabet => 'Arabic Alphabet';

  @override
  String get arabicAlphabetDescription => 'Learn Arabic letters, sounds and Harakat.';

  @override
  String get practiceQuizzes => 'Practice Quizzes';

  @override
  String get practiceQuizzesDescription => 'Test what you have learned';

  @override
  String get quiz1Instruction => 'Choose the correct answer';

  @override
  String get quiz2Instruction => 'Listen and choose the answer';

  @override
  String get quiz3Instruction => 'Select the matching pairs';

  @override
  String get quiz4Instruction => 'Practice Arabic pronunciation';

  @override
  String get motivation => 'Practice a little every day to improve your Arabic faster.';

  @override
  String get home => 'Home';

  @override
  String get startLesson => 'Start Lesson';

  @override
  String quizLabel(int number) {
    return 'Quiz $number';
  }

  @override
  String get welcome => 'Welcome to IQRA!';

  @override
  String get lessons => 'Lessons';

  @override
  String get quizzes => 'Quizzes';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get registerButton => 'Register';

  @override
  String get forgotPasswordButton => 'Forgot Password?';

  @override
  String get fillAllFields => 'Please fill in all fields.';

  @override
  String get loginSuccessful => 'Login successful.';

  @override
  String get invalidCredentials => 'Invalid username or password.';

  @override
  String get invalidServerResponse => 'Invalid response received from server.';

  @override
  String serverErrorStatus(int statusCode) {
    return 'Server error: $statusCode';
  }

  @override
  String get networkError => 'A network error occurred. Please check your internet connection.';

  @override
  String get emailLabel => 'Email';

  @override
  String get genderLabel => 'Gender';

  @override
  String get femaleLabel => 'Female';

  @override
  String get maleLabel => 'Male';

  @override
  String get ageLabel => 'Age';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get registrationSuccessful => 'Registration successful!';

  @override
  String get registrationFailed => 'Registration failed.';

  @override
  String get connectionTimedOut => 'Connection timed out. Please check your internet connection.';

  @override
  String get unableToConnect => 'Unable to connect to the server. Please check your internet connection.';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get enterEmail => 'Please enter your email address.';

  @override
  String get emailFound => 'Email found.';

  @override
  String get emailNotFound => 'Email does not exist.';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get checkEmailButton => 'Check Email';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters.';

  @override
  String get resetSuccessful => 'Password reset successful.';

  @override
  String get resetFailed => 'Failed to reset password.';

  @override
  String get currentPasswordLabel => 'Current Password';

  @override
  String get usernameMissing => 'Username is missing. Please login again.';

  @override
  String get newPasswordMustDiffer => 'New password must be different from the current password.';

  @override
  String get changePasswordSuccessful => 'Password changed successfully.';

  @override
  String get changePasswordFailed => 'Failed to change password.';

  @override
  String get refreshProfile => 'Refresh Profile';

  @override
  String get addProfilePhoto => 'Add Profile Photo';

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileLoadFailed => 'Unable to load profile. Check your internet connection.';

  @override
  String get profileFieldsRequired => 'Please fill in all profile fields.';

  @override
  String get profileUpdateSuccessful => 'Profile updated successfully.';

  @override
  String get profileUpdateFailed => 'Failed to update profile.';

  @override
  String get profileUpdateNetworkError => 'Unable to update profile. Check your internet connection.';

  @override
  String get profileImagePickFailed => 'Unable to select image.';

  @override
  String get profilePhotoUpdated => 'Profile photo updated successfully.';

  @override
  String get profilePhotoUploadFailed => 'Failed to upload image.';

  @override
  String get profilePhotoUploadNetworkError => 'Unable to upload image. Check your internet connection.';

  @override
  String get learnArabicAlphabetTitle => 'Learn Arabic Alphabet';

  @override
  String learnLetterTitle(String letter) {
    return 'Learn $letter';
  }

  @override
  String get fathahLabel => 'Fatḥah';

  @override
  String get dammaLabel => 'Damma';

  @override
  String get kasrahLabel => 'Kasrah';

  @override
  String get playPronunciation => 'Play pronunciation';

  @override
  String get audioPlaybackError => 'Unable to play the audio. Please try again.';

  @override
  String get quiz1LoadShort => 'Unable to load Quiz 1.';

  @override
  String get quiz1LoadError => 'Unable to load Quiz 1. Please check your internet connection and try again.';

  @override
  String get quizNoQuestions => 'No Quiz 1 questions found.';

  @override
  String get quizTryAgain => 'Try Again';

  @override
  String quizScoreSummary(int score, int maxScore) {
    return 'Score: $score / $maxScore';
  }

  @override
  String quizQuestionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizSelectAnswerFirst => 'Please select an answer first.';

  @override
  String get quizCorrectAnswerMissing => 'Correct answer could not be found.';

  @override
  String get quizCorrectPoints => 'Correct! +5 points';

  @override
  String get quizIncorrectAnswer => 'Incorrect answer.';

  @override
  String quizCompletedScore(int score) {
    return 'Quiz Completed! Your score: $score';
  }

  @override
  String get quizUsernameNotFound => 'Username not found. Please login again.';

  @override
  String get quizScoreSaved => 'Quiz 1 score saved successfully.';

  @override
  String get quizScoreSaveFailed => 'Failed to save score.';

  @override
  String get quizScoreNetworkError => 'Unable to save score. Check your internet connection.';

  @override
  String get quizAudioError => 'Unable to play sound.';

  @override
  String get quizAwesome => 'Awesome!';

  @override
  String quizIncorrectFeedback(String answer) {
    return 'Incorrect. The correct answer is $answer.';
  }

  @override
  String get quizContinue => 'Continue';

  @override
  String get quizSubmitAnswer => 'Submit Answer';

  @override
  String get quiz2LoadShort => 'Unable to load Quiz 2.';

  @override
  String get quiz2LoadError => 'Unable to load Quiz 2. Please check your internet connection and try again.';

  @override
  String get quiz2NoQuestions => 'No Quiz 2 questions found.';

  @override
  String get quiz2ScoreSaved => 'Quiz 2 score saved successfully.';

  @override
  String get quiz3LoadShort => 'Unable to load Quiz 3.';

  @override
  String get quiz3LoadError => 'Unable to load Quiz 3. Please check your internet connection and try again.';

  @override
  String get quiz3NoQuestions => 'No Quiz 3 questions found.';

  @override
  String get quiz3MatchAllPairs => 'Please match all pairs correctly first.';

  @override
  String get quiz3AllPairsCorrect => 'Awesome! All pairs are correct.';

  @override
  String get quiz3ScoreSaved => 'Quiz 3 score saved successfully.';

  @override
  String get quiz3InvalidPairs => 'The matching pairs could not be displayed. Please try again.';

  @override
  String get speechPronunciationTitle => 'Pronunciation Practice';

  @override
  String get speechRecognitionLanguageLabel => 'Speech recognition language';

  @override
  String get speechPreparing => 'Preparing speech recognition...';

  @override
  String get speechTapToSpeak => 'Tap the microphone to speak';

  @override
  String get speechListeningNow => 'Listening... speak now';

  @override
  String get speechNoSpeechDetected => 'No speech detected. Try again.';

  @override
  String get speechRecognitionComplete => 'Recognition complete';

  @override
  String get speechTapToTryAgain => 'Tap the microphone to try again';

  @override
  String get speechUnavailable => 'Speech recognition is not available.';

  @override
  String get speechRecognizedText => 'Recognized Text';

  @override
  String get speechPlaceholder => 'Your speech will appear here';

  @override
  String get speechRecognitionConfidence => 'Recognition confidence';

  @override
  String get speechTapToStop => 'Tap to stop';

  @override
  String get speechCopy => 'Copy';

  @override
  String get speechClear => 'Clear';

  @override
  String get speechTextCopied => 'Recognized text copied';

  @override
  String get speechErrorTimeout => 'No speech detected. Try again.';

  @override
  String get speechErrorNoMatch => 'I could not understand that. Try again.';

  @override
  String get speechErrorNetwork => 'Please check your internet connection.';

  @override
  String get speechErrorAudio => 'There was a microphone problem.';

  @override
  String get speechErrorPermission => 'Microphone permission is required.';

  @override
  String get speechErrorGeneric => 'A speech recognition error occurred.';

  @override
  String get speechInitializationFailed => 'Unable to initialize speech recognition.';

  @override
  String get speechUnableStart => 'Unable to start listening. Try again.';
}

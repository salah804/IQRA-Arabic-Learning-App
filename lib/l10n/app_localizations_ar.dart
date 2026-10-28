import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTagline => 'تعلّم العربية خطوة بخطوة';

  @override
  String get drawerTagline => 'تطبيق تعلّم اللغة العربية';

  @override
  String get learnArabic => 'تعلّم العربية';

  @override
  String get alphabetAndLessons => 'الحروف والدروس';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profileDescription => 'عرض ملفك الشخصي أو تحديثه';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordDescription => 'تحديث كلمة المرور';

  @override
  String get checkForUpdates => 'التحقق من التحديثات';

  @override
  String get checkForUpdatesDescription => 'التحقق من وجود إصدار أحدث من اقرأ';

  @override
  String get language => 'اللغة';

  @override
  String get languageDescription => 'اختر الإنجليزية أو العربية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get footer => 'اقرأ • تعلّم العربية بثقة';

  @override
  String get welcomeHome => 'مرحباً بك في اقرأ 👋';

  @override
  String get welcomeDescription => 'تعلّم الحروف العربية، وتدرّب على الاختبارات، وحسّن نطقك.';

  @override
  String get startLearning => 'ابدأ التعلّم';

  @override
  String get startLearningDescription => 'تعلّم الحروف العربية وطريقة نطقها';

  @override
  String get arabicAlphabet => 'الحروف العربية';

  @override
  String get arabicAlphabetDescription => 'تعلّم الحروف والأصوات والحركات العربية.';

  @override
  String get practiceQuizzes => 'اختبارات تدريبية';

  @override
  String get practiceQuizzesDescription => 'اختبر ما تعلمته';

  @override
  String get quiz1Instruction => 'اختر الإجابة الصحيحة';

  @override
  String get quiz2Instruction => 'استمع واختر الإجابة';

  @override
  String get quiz3Instruction => 'اختر الأزواج المتطابقة';

  @override
  String get quiz4Instruction => 'تدرّب على النطق العربي';

  @override
  String get motivation => 'تدرّب قليلاً كل يوم لتطوّر لغتك العربية بسرعة أكبر.';

  @override
  String get home => 'الرئيسية';

  @override
  String get startLesson => 'ابدأ الدرس';

  @override
  String quizLabel(int number) {
    return 'الاختبار $number';
  }

  @override
  String get welcome => 'مرحباً بك في اقرأ!';

  @override
  String get lessons => 'الدروس';

  @override
  String get quizzes => 'الاختبارات';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get registerButton => 'إنشاء حساب';

  @override
  String get forgotPasswordButton => 'نسيت كلمة المرور؟';

  @override
  String get fillAllFields => 'يرجى تعبئة جميع الحقول.';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح.';

  @override
  String get invalidCredentials => 'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get invalidServerResponse => 'تم استلام استجابة غير صالحة من الخادم.';

  @override
  String serverErrorStatus(int statusCode) {
    return 'خطأ في الخادم: $statusCode';
  }

  @override
  String get networkError => 'حدث خطأ في الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get femaleLabel => 'أنثى';

  @override
  String get maleLabel => 'ذكر';

  @override
  String get ageLabel => 'العمر';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get registrationSuccessful => 'تم إنشاء الحساب بنجاح!';

  @override
  String get registrationFailed => 'فشل إنشاء الحساب.';

  @override
  String get connectionTimedOut => 'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get unableToConnect => 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get enterEmail => 'يرجى إدخال عنوان بريدك الإلكتروني.';

  @override
  String get emailFound => 'تم العثور على البريد الإلكتروني.';

  @override
  String get emailNotFound => 'البريد الإلكتروني غير موجود.';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get checkEmailButton => 'التحقق من البريد الإلكتروني';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get passwordMinLength => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل.';

  @override
  String get resetSuccessful => 'تمت إعادة تعيين كلمة المرور بنجاح.';

  @override
  String get resetFailed => 'فشلت إعادة تعيين كلمة المرور.';

  @override
  String get currentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get usernameMissing => 'اسم المستخدم غير موجود. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get newPasswordMustDiffer => 'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور الحالية.';

  @override
  String get changePasswordSuccessful => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get changePasswordFailed => 'فشل تغيير كلمة المرور.';

  @override
  String get refreshProfile => 'تحديث الملف الشخصي';

  @override
  String get addProfilePhoto => 'إضافة صورة شخصية';

  @override
  String get changeProfilePhoto => 'تغيير الصورة الشخصية';

  @override
  String get updateProfile => 'حفظ التعديلات';

  @override
  String get profileLoadFailed => 'تعذر تحميل الملف الشخصي. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get profileFieldsRequired => 'يرجى تعبئة جميع حقول الملف الشخصي.';

  @override
  String get profileUpdateSuccessful => 'تم تحديث الملف الشخصي بنجاح.';

  @override
  String get profileUpdateFailed => 'فشل تحديث الملف الشخصي.';

  @override
  String get profileUpdateNetworkError => 'تعذر تحديث الملف الشخصي. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get profileImagePickFailed => 'تعذر اختيار الصورة.';

  @override
  String get profilePhotoUpdated => 'تم تحديث الصورة الشخصية بنجاح.';

  @override
  String get profilePhotoUploadFailed => 'فشل رفع الصورة.';

  @override
  String get profilePhotoUploadNetworkError => 'تعذر رفع الصورة. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get learnArabicAlphabetTitle => 'تعلّم الحروف العربية';

  @override
  String learnLetterTitle(String letter) {
    return 'تعلّم حرف $letter';
  }

  @override
  String get fathahLabel => 'الفتحة';

  @override
  String get dammaLabel => 'الضمة';

  @override
  String get kasrahLabel => 'الكسرة';

  @override
  String get playPronunciation => 'استمع إلى النطق';

  @override
  String get audioPlaybackError => 'تعذر تشغيل الصوت. يرجى المحاولة مرة أخرى.';

  @override
  String get quiz1LoadShort => 'تعذر تحميل الاختبار الأول.';

  @override
  String get quiz1LoadError => 'تعذر تحميل الاختبار الأول. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get quizNoQuestions => 'لم يتم العثور على أسئلة للاختبار الأول.';

  @override
  String get quizTryAgain => 'حاول مرة أخرى';

  @override
  String quizScoreSummary(int score, int maxScore) {
    return 'النتيجة: $score / $maxScore';
  }

  @override
  String quizQuestionProgress(int current, int total) {
    return 'السؤال $current من $total';
  }

  @override
  String get quizSelectAnswerFirst => 'يرجى اختيار إجابة أولاً.';

  @override
  String get quizCorrectAnswerMissing => 'تعذر العثور على الإجابة الصحيحة.';

  @override
  String get quizCorrectPoints => 'إجابة صحيحة! +5 نقاط';

  @override
  String get quizIncorrectAnswer => 'إجابة غير صحيحة.';

  @override
  String quizCompletedScore(int score) {
    return 'اكتمل الاختبار! نتيجتك: $score';
  }

  @override
  String get quizUsernameNotFound => 'لم يتم العثور على اسم المستخدم. يرجى تسجيل الدخول مجدداً.';

  @override
  String get quizScoreSaved => 'تم حفظ نتيجة الاختبار الأول بنجاح.';

  @override
  String get quizScoreSaveFailed => 'فشل حفظ النتيجة.';

  @override
  String get quizScoreNetworkError => 'تعذر حفظ النتيجة. تحقق من اتصالك بالإنترنت.';

  @override
  String get quizAudioError => 'تعذر تشغيل الصوت.';

  @override
  String get quizAwesome => 'رائع!';

  @override
  String quizIncorrectFeedback(String answer) {
    return 'إجابة غير صحيحة. الإجابة الصحيحة هي $answer.';
  }

  @override
  String get quizContinue => 'متابعة';

  @override
  String get quizSubmitAnswer => 'إرسال الإجابة';

  @override
  String get quiz2LoadShort => 'تعذر تحميل الاختبار الثاني.';

  @override
  String get quiz2LoadError => 'تعذر تحميل الاختبار الثاني. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get quiz2NoQuestions => 'لم يتم العثور على أسئلة للاختبار الثاني.';

  @override
  String get quiz2ScoreSaved => 'تم حفظ نتيجة الاختبار الثاني بنجاح.';

  @override
  String get quiz3LoadShort => 'تعذر تحميل الاختبار الثالث.';

  @override
  String get quiz3LoadError => 'تعذر تحميل الاختبار الثالث. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get quiz3NoQuestions => 'لم يتم العثور على أسئلة للاختبار الثالث.';

  @override
  String get quiz3MatchAllPairs => 'يرجى مطابقة جميع الأزواج بشكل صحيح أولاً.';

  @override
  String get quiz3AllPairsCorrect => 'رائع! جميع الأزواج متطابقة بشكل صحيح.';

  @override
  String get quiz3ScoreSaved => 'تم حفظ نتيجة الاختبار الثالث بنجاح.';

  @override
  String get quiz3InvalidPairs => 'تعذر عرض أزواج المطابقة. يرجى المحاولة مرة أخرى.';

  @override
  String get speechPronunciationTitle => 'التدرب على النطق';

  @override
  String get speechRecognitionLanguageLabel => 'لغة التعرف على الكلام';

  @override
  String get speechPreparing => 'جارٍ تجهيز التعرف على الكلام...';

  @override
  String get speechTapToSpeak => 'اضغط على الميكروفون للتحدث';

  @override
  String get speechListeningNow => 'أنا أستمع... تحدث الآن';

  @override
  String get speechNoSpeechDetected => 'لم يتم اكتشاف أي كلام. حاول مرة أخرى.';

  @override
  String get speechRecognitionComplete => 'اكتمل التعرف على الكلام';

  @override
  String get speechTapToTryAgain => 'اضغط على الميكروفون للمحاولة مرة أخرى';

  @override
  String get speechUnavailable => 'التعرف على الكلام غير متاح.';

  @override
  String get speechRecognizedText => 'النص الذي تم التعرف عليه';

  @override
  String get speechPlaceholder => 'سيظهر الكلام الذي تقوله هنا';

  @override
  String get speechRecognitionConfidence => 'مستوى الثقة في التعرف';

  @override
  String get speechTapToStop => 'اضغط للإيقاف';

  @override
  String get speechCopy => 'نسخ';

  @override
  String get speechClear => 'مسح';

  @override
  String get speechTextCopied => 'تم نسخ النص الذي تم التعرف عليه';

  @override
  String get speechErrorTimeout => 'لم يتم اكتشاف أي كلام. حاول مرة أخرى.';

  @override
  String get speechErrorNoMatch => 'تعذر فهم الكلام. حاول مرة أخرى.';

  @override
  String get speechErrorNetwork => 'يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get speechErrorAudio => 'حدثت مشكلة في الميكروفون.';

  @override
  String get speechErrorPermission => 'يجب السماح للتطبيق باستخدام الميكروفون.';

  @override
  String get speechErrorGeneric => 'حدث خطأ أثناء التعرف على الكلام.';

  @override
  String get speechInitializationFailed => 'تعذر تهيئة التعرف على الكلام.';

  @override
  String get speechUnableStart => 'تعذر بدء الاستماع. حاول مرة أخرى.';
}

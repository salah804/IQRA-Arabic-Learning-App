import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqra/quiz4.dart';
import 'package:aqra/login.dart';
import 'package:aqra/profile.dart';
import 'package:aqra/arabic_lessons.dart';
import 'package:aqra/change_password.dart';
import 'package:aqra/update_service.dart';

import 'l10n/app_localizations.dart';
import 'main.dart';
import 'quiz1.dart';
import 'quiz2.dart';
import 'quiz3.dart';

// Optional standalone entry point, retained from the original HomeScreen file.
// Normal app launches should use lib/main.dart so users see LoginPage first.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyQuizApp(initialLanguage: prefs.getString('language') ?? 'en'));
}

class MyQuizApp extends StatefulWidget {
  final String initialLanguage;

  const MyQuizApp({super.key, this.initialLanguage = 'en'});

  @override
  State<MyQuizApp> createState() => _MyQuizAppState();
}

class _MyQuizAppState extends State<MyQuizApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLanguage == 'ar' ? 'ar' : 'en');
  }

  Future<void> _changeLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'ar') return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    if (!mounted) return;
    setState(() => _locale = Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IQRA',
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.lime[300],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: HomeScreen(onLanguageSelected: _changeLanguage),
    );
  }
}

class HomeScreen extends StatefulWidget {
  // Used only by the optional MyQuizApp standalone entry point.
  final Future<void> Function(String)? onLanguageSelected;

  const HomeScreen({super.key, this.onLanguageSelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color brandColor = Color(0xFF607D8B);

  @override
  void initState() {
    super.initState();
    // Keep the automatic in-app update check from your existing app.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      UpdateService.checkForUpdate(context);
    });
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _selectLanguage(String languageCode) async {
    if (widget.onLanguageSelected != null) {
      await widget.onLanguageSelected!(languageCode);
    } else {
      await MyApp.setLanguage(context, languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activeLanguage = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.lime[300],
      appBar: AppBar(
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'IQRA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.appTagline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.profile,
            onPressed: () => _openPage(context, const Profile()),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 5),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        // Scrollable so the added language option won't overflow small screens.
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
              decoration: const BoxDecoration(color: brandColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 36,
                      color: brandColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'IQRA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.drawerTagline,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined, color: brandColor),
              title: Text(l10n.learnArabic),
              subtitle: Text(l10n.alphabetAndLessons),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _openPage(context, ArabicLessons());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: brandColor),
              title: Text(l10n.profile),
              subtitle: Text(l10n.profileDescription),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _openPage(context, const Profile());
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline, color: brandColor),
              title: Text(l10n.changePassword),
              subtitle: Text(l10n.changePasswordDescription),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _openPage(context, ChangePasswordPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.system_update_alt, color: brandColor),
              title: Text(l10n.checkForUpdates),
              subtitle: Text(l10n.checkForUpdatesDescription),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                Navigator.pop(context);
                await Future<void>.delayed(
                  const Duration(milliseconds: 250),
                );
                if (!mounted) return;
                await UpdateService.checkForUpdate(
                  context,
                  manualCheck: true,
                );
              },
            ),
            PopupMenuButton<String>(
              tooltip: l10n.language,
              initialValue: activeLanguage,
              onSelected: _selectLanguage,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'ar', child: Text('العربية')),
              ],
              child: ListTile(
                leading: const Icon(Icons.language, color: brandColor),
                title: Text(l10n.language),
                subtitle: Text(
                  activeLanguage == 'ar' ? 'العربية' : 'English',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                l10n.logout,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.footer,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.welcomeHome,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.welcomeDescription,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.lime[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 38,
                        color: brandColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SectionTitle(
                title: l10n.startLearning,
                subtitle: l10n.startLearningDescription,
                icon: Icons.school_rounded,
              ),
              const SizedBox(height: 14),
              _LessonCard(
                title: l10n.arabicAlphabet,
                subtitle: l10n.arabicAlphabetDescription,
                imagePath: 'assets/Arabic.jpg',
                onTap: () => _openPage(context, ArabicLessons()),
              ),
              const SizedBox(height: 30),
              _SectionTitle(
                title: l10n.practiceQuizzes,
                subtitle: l10n.practiceQuizzesDescription,
                icon: Icons.quiz_outlined,
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 750 ? 3 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                    children: [
                      QuizTile(
                        quizNumber: 1,
                        instruction: l10n.quiz1Instruction,
                        imagePath: 'assets/quiz1.png',
                        icon: Icons.check_circle_outline,
                        onTap: () => _openPage(context, Quiz1(quizID: 1)),
                      ),
                      QuizTile(
                        quizNumber: 2,
                        instruction: l10n.quiz2Instruction,
                        imagePath: 'assets/quiz2.png',
                        icon: Icons.headphones_rounded,
                        onTap: () => _openPage(context, Quiz2(quizID: 2)),
                      ),
                      QuizTile(
                        quizNumber: 3,
                        instruction: l10n.quiz3Instruction,
                        imagePath: 'assets/quiz3.png',
                        icon: Icons.compare_arrows_rounded,
                        onTap: () => _openPage(context, Quiz3(quizID: 3)),
                      ),
                      QuizTile(
                        quizNumber: 4,
                        instruction: l10n.quiz4Instruction,
                        imagePath: 'assets/quiz4.png',
                        icon: Icons.mic_rounded,
                        onTap: () => _openPage(context, const HomePage()),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: brandColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.motivation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: Colors.white,
        indicatorColor: Colors.lime[200],
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_circle_outlined),
            selectedIcon: const Icon(Icons.account_circle),
            label: l10n.profile,
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 1) _openPage(context, const Profile());
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF607D8B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const _LessonCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 205,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455A64),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                l10n.startLesson,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF607D8B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Color(0xFF607D8B),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.lime[100],
                          child: const Center(
                            child: Icon(
                              Icons.menu_book,
                              size: 65,
                              color: Color(0xFF607D8B),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final int quizNumber;
  final String instruction;
  final String imagePath;
  final IconData icon;
  final VoidCallback onTap;

  const QuizTile({
    super.key,
    required this.quizNumber,
    required this.instruction,
    required this.imagePath,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.blueGrey[50],
                            child: Icon(
                              icon,
                              size: 55,
                              color: Colors.blueGrey,
                            ),
                          );
                        },
                      ),
                      PositionedDirectional(
                        top: 9,
                        start: 9,
                        child: Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF607D8B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$quizNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 19, color: const Color(0xFF607D8B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              l10n.quizLabel(quizNumber),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF455A64),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        instruction,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

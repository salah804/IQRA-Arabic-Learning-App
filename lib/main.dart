
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'login.dart';

// ============================================================
// IQRA - MAIN APPLICATION
// ENGLISH / ARABIC + RESPONSIVE WEB DESIGN
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the previously selected language.
  final prefs = await SharedPreferences.getInstance();

  final savedLanguage =
      prefs.getString('language') ?? 'en';

  runApp(
    MyApp(
      initialLanguage: savedLanguage,
    ),
  );
}

// ============================================================
// IQRA APPLICATION
// ============================================================

class MyApp extends StatefulWidget {
  final String initialLanguage;

  const MyApp({
    super.key,
    required this.initialLanguage,
  });

  // ==========================================================
  // CHANGE LANGUAGE FROM OTHER SCREENS
  // ==========================================================

  static Future<void> setLanguage(
      BuildContext context,
      String languageCode,
      ) async {
    final state =
    context.findAncestorStateOfType<_MyAppState>();

    if (state != null) {
      await state.changeLanguage(languageCode);
    }
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

// ============================================================
// APPLICATION STATE
// ============================================================

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  // ==========================================================
  // INITIALIZE LANGUAGE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _locale = Locale(
      widget.initialLanguage == 'ar' ? 'ar' : 'en',
    );
  }

  // ==========================================================
  // SAVE AND CHANGE LANGUAGE
  // ==========================================================

  Future<void> changeLanguage(
      String languageCode,
      ) async {
    if (languageCode != 'en' &&
        languageCode != 'ar') {
      return;
    }

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'language',
      languageCode,
    );

    if (!mounted) return;

    setState(() {
      _locale = Locale(languageCode);
    });
  }

  // ==========================================================
  // RESPONSIVE WEB LAYOUT
  //
  // Android and iOS:
  //   Original full-screen mobile layout.
  //
  // Mobile browsers:
  //   Original full-screen responsive layout.
  //
  // Laptop and desktop browsers:
  //   - Center horizontally and vertically.
  //   - Maximum width: 480 px.
  //   - Maximum height: 800 px.
  //   - Soft blue-gray gradient background.
  //   - Rounded corners.
  //   - Beautiful shadow.
  //
  // ==========================================================

  Widget _buildResponsiveLayout(
      BuildContext context,
      Widget? child,
      ) {
    final Widget appContent =
        child ?? const SizedBox.shrink();

    // ========================================================
    // ANDROID / IOS
    // Keep the original mobile design unchanged.
    // ========================================================

    if (!kIsWeb) {
      return appContent;
    }

    // ========================================================
    // FLUTTER WEB
    // ========================================================

    return LayoutBuilder(
      builder: (context, constraints) {

        // Detect laptop/desktop browser.
        final bool isDesktop =
            constraints.maxWidth > 600;

        // ====================================================
        // MOBILE WEB
        // Keep the website full-screen on phones.
        // ====================================================

        if (!isDesktop) {
          return appContent;
        }

        // ====================================================
        // DESKTOP WEB SETTINGS
        // ====================================================

        const double maxAppWidth = 480.0;
        const double maxAppHeight = 800.0;
        const double verticalMargin = 24.0;

        // Limit the width of the application.
        final double appWidth = maxAppWidth;

        // Limit the height while leaving room at the top
        // and bottom of the browser window.
        final double appHeight =
        (constraints.maxHeight -
            verticalMargin * 2)
            .clamp(0.0, maxAppHeight)
            .toDouble();

        // Rounded corners for the centered application.
        final BorderRadius appBorderRadius =
        BorderRadius.circular(22);

        // ====================================================
        // DESKTOP BACKGROUND
        // Soft blue-gray colors that match the IQRA header.
        // ====================================================

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF4F8FA),
                Color(0xFFE0EBF0),
                Color(0xFFBDCFD7),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),

          // ==================================================
          // CENTER THE APPLICATION
          // HORIZONTALLY AND VERTICALLY
          // ==================================================

          child: Center(
            child: Container(
              width: appWidth,
              height: appHeight,

              // ==============================================
              // ROUNDED CORNERS + SHADOW
              // ==============================================

              decoration: BoxDecoration(
                borderRadius: appBorderRadius,

                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 35,
                    spreadRadius: 1,
                    offset: Offset(0, 12),
                  ),
                ],

                border: Border.all(
                  color: const Color(0x99FFFFFF),
                  width: 1,
                ),
              ),

              // ==============================================
              // CLIP APP CONTENT TO ROUNDED CORNERS
              // ==============================================

              child: ClipRRect(
                borderRadius: appBorderRadius,

                // ============================================
                // IMPORTANT:
                // Tell Flutter the real app dimensions.
                // This keeps cards, forms, and navigation
                // correctly sized on desktop.
                // ============================================

                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: Size(
                      appWidth,
                      appHeight,
                    ),
                  ),

                  child: appContent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // BUILD APPLICATION
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // ======================================================
      // APPLICATION SETTINGS
      // ======================================================

      title: 'IQRA',

      debugShowCheckedModeBanner: false,

      // ======================================================
      // LANGUAGE SETTINGS
      // ======================================================

      locale: _locale,

      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ======================================================
      // APP THEME
      // ======================================================

      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      // ======================================================
      // RESPONSIVE WEB DESIGN
      // ======================================================

      builder: (context, child) {
        return _buildResponsiveLayout(
          context,
          child,
        );
      },

      // ======================================================
      // FIRST SCREEN
      // ======================================================

      home: LoginPage(),
    );
  }
}

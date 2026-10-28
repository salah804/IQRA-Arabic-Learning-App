
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqra/api_config.dart';

import 'l10n/app_localizations.dart';
import 'main.dart' show MyApp;
import 'home_screen.dart';
import 'register.dart';
import 'forgot_password.dart';

// ============================================================
// IQRA BILINGUAL LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _isLoading = false;

  // ==========================================================
  // SHOW SUCCESS / ERROR MESSAGE
  // ==========================================================

  void _showMessage(
      String message, {
        bool isError = true,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? Colors.red : Colors.green,
      ),
    );
  }

  // ==========================================================
  // LOGIN FUNCTION
  // ==========================================================

  Future<void> _login() async {
    if (_isLoading) return;

    final username =
    _usernameController.text.trim();

    final password =
    _passwordController.text.trim();

    // Validate input
    if (username.isEmpty || password.isEmpty) {
      _showMessage(
        AppLocalizations.of(context)!.fillAllFields,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ======================================================
      // ONLINE LOGIN REQUEST
      // ======================================================

      http.Response response;

      try {
        response = await http.post(
          Uri.parse(
            '${ApiConfig.baseUrl}/login.php',
          ),
          body: {
            'username': username,
            'password': password,
          },
        ).timeout(
          const Duration(seconds: 30),
        );
      } catch (e) {
        if (!mounted) return;

        _showMessage(
          AppLocalizations.of(context)!.networkError,
        );
        return;
      }

      if (!mounted) return;

      // ======================================================
      // CHECK HTTP RESPONSE
      // ======================================================

      if (response.statusCode != 200) {
        _showMessage(
          AppLocalizations.of(context)!
              .serverErrorStatus(response.statusCode),
        );
        return;
      }

      // ======================================================
      // DECODE SERVER RESPONSE
      // ======================================================

      Map<String, dynamic> responseData;

      try {
        final decoded = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException(
            'Expected JSON object',
          );
        }

        responseData = decoded;
      } catch (e) {
        if (!mounted) return;

        _showMessage(
          AppLocalizations.of(context)!
              .invalidServerResponse,
        );
        return;
      }

      // ======================================================
      // LOGIN SUCCESS
      // ======================================================

      if (responseData['success'] == true) {
        final userData = responseData['user'];

        final returnedUsername =
        userData is Map
            ? userData['username']?.toString()
            : null;

        if (returnedUsername == null ||
            returnedUsername.isEmpty) {
          _showMessage(
            AppLocalizations.of(context)!
                .invalidServerResponse,
          );
          return;
        }

        // Save username
        final prefs =
        await SharedPreferences.getInstance();

        await prefs.setString(
          'username',
          returnedUsername,
        );

        if (!mounted) return;

        _showMessage(
          AppLocalizations.of(context)!
              .loginSuccessful,
          isError: false,
        );

        // Navigate to HomeScreen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
              (route) => false,
        );
      } else {

        // ====================================================
        // WRONG USERNAME OR PASSWORD
        // ====================================================

        final serverMessage =
            responseData['message']
                ?.toString()
                .trim() ??
                '';

        final normalized =
        serverMessage.toLowerCase();

        final isCommonLoginError =
            serverMessage.isEmpty ||
                normalized.contains('invalid') ||
                normalized.contains('incorrect') ||
                normalized.contains('wrong password') ||
                normalized.contains('not found');

        final l10n =
        AppLocalizations.of(context)!;

        _showMessage(
          isCommonLoginError
              ? l10n.invalidCredentials
              : serverMessage,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // BUILD LOGIN SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final l10n =
    AppLocalizations.of(context)!;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    return Scaffold(

      // ======================================================
      // APP BAR WITH LANGUAGE SWITCHER
      // ======================================================

      appBar: AppBar(
        title: Text(
          l10n.welcomeBack,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blueGrey[600],

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [

          // English / Arabic language selector
          PopupMenuButton<String>(
            tooltip: l10n.language,

            icon: const Icon(
              Icons.language,
              color: Colors.white,
            ),

            onSelected: (code) async {
              await MyApp.setLanguage(
                context,
                code,
              );
            },

            itemBuilder: (_) => [

              // English
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    if (languageCode == 'en')
                      const Icon(
                        Icons.check,
                        size: 18,
                      ),

                    const SizedBox(width: 8),

                    const Text('English'),
                  ],
                ),
              ),

              // Arabic
              PopupMenuItem<String>(
                value: 'ar',
                child: Row(
                  children: [
                    if (languageCode == 'ar')
                      const Icon(
                        Icons.check,
                        size: 18,
                      ),

                    const SizedBox(width: 8),

                    const Text('العربية'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),

              width: double.infinity,

              color: Colors.lime[300],

              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                    children: [

                      // =======================================
                      // IQRA LOGO
                      // =======================================

                      Image.asset(
                        'assets/iqra.png',
                        height: 250,
                      ),

                      const SizedBox(height: 5),

                      // =======================================
                      // LOGIN TITLE
                      // =======================================

                      Text(
                        l10n.loginTitle,

                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // USERNAME
                      // =======================================

                      TextField(
                        controller:
                        _usernameController,

                        textInputAction:
                        TextInputAction.next,

                        decoration: InputDecoration(
                          labelText:
                          l10n.usernameLabel,

                          filled: true,

                          fillColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),

                          prefixIcon:
                          const Icon(Icons.person),

                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // PASSWORD
                      // =======================================

                      TextField(
                        controller:
                        _passwordController,

                        obscureText: true,

                        textInputAction:
                        TextInputAction.done,

                        onSubmitted: (_) {
                          if (!_isLoading) {
                            _login();
                          }
                        },

                        decoration: InputDecoration(
                          labelText:
                          l10n.passwordLabel,

                          filled: true,

                          fillColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),

                          prefixIcon:
                          const Icon(Icons.lock),

                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // LOGIN BUTTON
                      // =======================================

                      ElevatedButton(
                        onPressed:
                        _isLoading ? null : _login,

                        child: _isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          l10n.loginTitle,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // =======================================
                      // REGISTER ACCOUNT
                      // =======================================

                      Wrap(
                        alignment:
                        WrapAlignment.center,

                        crossAxisAlignment:
                        WrapCrossAlignment.center,

                        spacing: 5,

                        children: [

                          Text(
                            l10n.dontHaveAccount,

                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      RegisterPage(),
                                ),
                              );
                            },

                            child: Text(
                              l10n.registerButton,

                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // FORGOT PASSWORD
                      // =======================================

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  ForgotPasswordPage(),
                            ),
                          );
                        },

                        child: Text(
                          l10n.forgotPasswordButton,

                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}

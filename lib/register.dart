
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:aqra/api_config.dart';

import 'l10n/app_localizations.dart';
import 'main.dart' show MyApp;
import 'login.dart';

// ============================================================
// IQRA BILINGUAL REGISTRATION PAGE
// ============================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _ageController =
  TextEditingController();

  final TextEditingController _phoneNumberController =
  TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  String? selectedGender;

  // ==========================================================
  // TOAST MESSAGE
  // ==========================================================

  void _showToast(
      String message, {
        bool success = false,
      }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor:
      success ? Colors.green : Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // ==========================================================
  // REGISTER USER
  // ==========================================================

  Future<void> _register() async {
    if (_isLoading) return;

    final l10n = AppLocalizations.of(context)!;

    final String username =
    _usernameController.text.trim();

    final String email =
    _emailController.text.trim();

    final String password =
        _passwordController.text;

    final String gender =
        selectedGender ?? '';

    final String age =
    _ageController.text.trim();

    final String phoneNumber =
    _phoneNumberController.text.trim();

    // ========================================================
    // CHECK EMPTY FIELDS
    // ========================================================

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        gender.isEmpty ||
        age.isEmpty ||
        phoneNumber.isEmpty) {
      _showToast(l10n.fillAllFields);
      return;
    }

    // ========================================================
    // EMAIL VALIDATION
    // ========================================================

    if (!email.contains('@') ||
        !email.contains('.')) {
      _showToast(l10n.invalidEmail);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      // ======================================================
      // ONLINE PHP REGISTRATION REQUEST
      // ======================================================

      final http.Response response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/register.php',
        ),
        body: {
          'username': username,
          'email': email,
          'password': password,

          // Keep original backend values.
          'gender': gender,

          'age': age,
          'phoneNumber': phoneNumber,
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      if (!mounted) return;

      // ======================================================
      // HTTP ERROR
      // ======================================================

      if (response.statusCode != 200) {
        _showToast(
          AppLocalizations.of(context)!
              .serverErrorStatus(
            response.statusCode,
          ),
        );
        return;
      }

      // ======================================================
      // DECODE JSON RESPONSE
      // ======================================================

      final String responseBody =
      utf8.decode(response.bodyBytes);

      Map<String, dynamic> responseData;

      try {
        final decoded = jsonDecode(responseBody);

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid JSON response',
          );
        }

        responseData = decoded;
      } catch (e) {
        debugPrint('Registration JSON error: $e');

        if (!mounted) return;

        _showToast(
          AppLocalizations.of(context)!
              .invalidServerResponse,
        );

        return;
      }

      // ======================================================
      // SUPPORT PHP SUCCESS VALUES
      // ======================================================

      final dynamic successValue =
      responseData['success'];

      final bool isSuccess =
          successValue == true ||
              successValue == 1 ||
              successValue == '1' ||
              successValue.toString().toLowerCase() ==
                  'true';

      if (!mounted) return;

      final currentL10n =
      AppLocalizations.of(context)!;

      // ======================================================
      // REGISTRATION SUCCESS
      // ======================================================

      if (isSuccess) {
        _showToast(
          currentL10n.registrationSuccessful,
          success: true,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      } else {

        // ====================================================
        // REGISTRATION FAILED
        // ====================================================

        final String serverMessage =
            responseData['message']
                ?.toString()
                .trim() ??
                '';

        _showToast(
          serverMessage.isNotEmpty
              ? serverMessage
              : currentL10n.registrationFailed,
        );
      }

    } on TimeoutException {

      // ======================================================
      // CONNECTION TIMEOUT
      // ======================================================

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .connectionTimedOut,
      );

    } on http.ClientException {

      // ======================================================
      // CONNECTION FAILED
      // ======================================================

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .unableToConnect,
      );

    } catch (e, stackTrace) {

      // ======================================================
      // NETWORK / UNEXPECTED ERROR
      // ======================================================

      debugPrint('Registration error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .networkError,
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
  // REUSABLE TEXT FIELD
  // ==========================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction textInputAction =
        TextInputAction.next,
    bool obscureText = false,
    Widget? suffixIcon,
    VoidCallback? onSubmitted,
    TextDirection? textDirection,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      textDirection: textDirection,

      onSubmitted: onSubmitted == null
          ? null
          : (_) => onSubmitted(),

      decoration: InputDecoration(
        labelText: label,

        filled: true,
        fillColor: Colors.white,

        prefixIcon: Icon(icon),

        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(10),
        ),

        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      style: const TextStyle(fontSize: 18),
    );
  }

  // ==========================================================
  // BUILD SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    return Scaffold(

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        title: Text(
          l10n.registerButton,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blueGrey,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        // ====================================================
        // LANGUAGE SWITCHER
        // ====================================================

        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.language,

            icon: const Icon(
              Icons.language,
              color: Colors.white,
            ),

            onSelected: (language) async {
              await MyApp.setLanguage(
                context,
                language,
              );
            },

            itemBuilder: (_) => [
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

      body: Container(
        width: double.infinity,
        height: double.infinity,

        color: Colors.lime[300],

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [

                const SizedBox(height: 20),

                // =============================================
                // USERNAME
                // =============================================

                _buildTextField(
                  controller: _usernameController,
                  label: l10n.usernameLabel,
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                // =============================================
                // EMAIL
                // =============================================

                _buildTextField(
                  controller: _emailController,
                  label: l10n.emailLabel,
                  icon: Icons.email_outlined,
                  keyboardType:
                  TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                ),

                const SizedBox(height: 20),

                // =============================================
                // PASSWORD
                // =============================================

                _buildTextField(
                  controller: _passwordController,
                  label: l10n.passwordLabel,
                  icon: Icons.lock,

                  obscureText: !_passwordVisible,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        _passwordVisible =
                        !_passwordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================
                // GENDER
                // =============================================

                DropdownButtonFormField<String>(
                  value: selectedGender,

                  isExpanded: true,

                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },

                  // UI labels are translated.
                  // PHP receives Male or Female.
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Female',
                      child: Text(
                        l10n.femaleLabel,
                      ),
                    ),

                    DropdownMenuItem<String>(
                      value: 'Male',
                      child: Text(
                        l10n.maleLabel,
                      ),
                    ),
                  ],

                  decoration: InputDecoration(
                    labelText: l10n.genderLabel,

                    filled: true,
                    fillColor: Colors.white,

                    prefixIcon: const Icon(
                      Icons.people_outline,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),

                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================
                // AGE
                // =============================================

                _buildTextField(
                  controller: _ageController,
                  label: l10n.ageLabel,
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                // =============================================
                // PHONE NUMBER
                // =============================================

                _buildTextField(
                  controller:
                  _phoneNumberController,
                  label: l10n.phoneNumberLabel,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textInputAction:
                  TextInputAction.done,

                  onSubmitted: () {
                    if (!_isLoading) {
                      _register();
                    }
                  },
                ),

                const SizedBox(height: 30),

                // =============================================
                // REGISTER BUTTON
                // =============================================

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed:
                    _isLoading ? null : _register,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                      width: 25,
                      height: 25,

                      child:
                      CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                        : Text(
                      l10n.registerButton,

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =============================================
                // BACK TO LOGIN
                // =============================================

                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const LoginPage(),
                      ),
                    );
                  },

                  child: Text(
                    l10n.alreadyHaveAccount,

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }
}

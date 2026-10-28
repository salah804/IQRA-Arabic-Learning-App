
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:aqra/api_config.dart';
import 'l10n/app_localizations.dart';

// ============================================================
// IQRA BILINGUAL FORGOT PASSWORD PAGE
// ============================================================

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _newPasswordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // ==========================================================
  // STATE
  // ==========================================================

  bool _showPasswordFields = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isCheckingEmail = false;
  bool _isResettingPassword = false;

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void _showMessage(
      String message, {
        bool success = false,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        success ? Colors.green : Colors.red,
      ),
    );
  }

  // ==========================================================
  // CHECK PHP SUCCESS RESPONSE
  // ==========================================================

  bool _isSuccess(dynamic value) {
    return value == true ||
        value == 1 ||
        value == '1' ||
        value.toString().toLowerCase() == 'true';
  }

  // ==========================================================
  // DECODE SERVER JSON
  // ==========================================================

  Map<String, dynamic>? _decodeResponse(
      http.Response response,
      ) {
    try {
      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (e) {
      debugPrint('JSON parsing error: $e');
      return null;
    }
  }

  // ==========================================================
  // CHECK EMAIL
  // ==========================================================

  Future<void> _checkEmail() async {
    if (_isCheckingEmail || _isResettingPassword) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    final String email =
    _emailController.text.trim();

    // Empty email
    if (email.isEmpty) {
      _showMessage(l10n.enterEmail);
      return;
    }

    // Invalid email
    if (!email.contains('@') ||
        !email.contains('.')) {
      _showMessage(l10n.invalidEmail);
      return;
    }

    setState(() {
      _isCheckingEmail = true;
    });

    try {

      // ======================================================
      // CHECK EMAIL ONLINE
      // ======================================================

      final http.Response response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/check_email.php',
        ),
        body: {
          'email': email,
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      if (!mounted) return;

      final currentL10n =
      AppLocalizations.of(context)!;

      // HTTP Error
      if (response.statusCode != 200) {
        _showMessage(
          currentL10n.serverErrorStatus(
            response.statusCode,
          ),
        );
        return;
      }

      // Decode JSON
      final responseData =
      _decodeResponse(response);

      if (responseData == null) {
        _showMessage(
          currentL10n.invalidServerResponse,
        );
        return;
      }

      // ======================================================
      // EMAIL FOUND
      // ======================================================

      if (_isSuccess(responseData['success'])) {
        setState(() {
          _showPasswordFields = true;
        });

        _showMessage(
          currentL10n.emailFound,
          success: true,
        );
      } else {

        // ====================================================
        // EMAIL NOT FOUND / SERVER REJECTION
        // ====================================================

        final String serverMessage =
            responseData['message']
                ?.toString()
                .trim() ??
                '';

        _showMessage(
          serverMessage.isNotEmpty
              ? serverMessage
              : currentL10n.emailNotFound,
        );
      }

    } on TimeoutException {
      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!
            .connectionTimedOut,
      );

    } catch (e) {
      debugPrint('Check email error: $e');

      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!
            .networkError,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isCheckingEmail = false;
        });
      }
    }
  }

  // ==========================================================
  // RESET PASSWORD
  // ==========================================================

  Future<void> _resetPassword() async {
    if (_isResettingPassword || !_showPasswordFields) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    final String email =
    _emailController.text.trim();

    final String newPassword =
        _newPasswordController.text;

    final String confirmPassword =
        _confirmPasswordController.text;

    // Empty fields
    if (newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(l10n.fillAllFields);
      return;
    }

    // Passwords do not match
    if (newPassword != confirmPassword) {
      _showMessage(l10n.passwordsDoNotMatch);
      return;
    }

    // Minimum password length
    if (newPassword.length < 6) {
      _showMessage(l10n.passwordMinLength);
      return;
    }

    setState(() {
      _isResettingPassword = true;
    });

    try {

      // ======================================================
      // RESET PASSWORD ONLINE
      // ======================================================

      final http.Response response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/reset_password.php',
        ),
        body: {
          'email': email,
          'password': newPassword,
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      if (!mounted) return;

      final currentL10n =
      AppLocalizations.of(context)!;

      if (response.statusCode != 200) {
        _showMessage(
          currentL10n.serverErrorStatus(
            response.statusCode,
          ),
        );
        return;
      }

      final responseData =
      _decodeResponse(response);

      if (responseData == null) {
        _showMessage(
          currentL10n.invalidServerResponse,
        );
        return;
      }

      // ======================================================
      // RESET SUCCESS
      // ======================================================

      if (_isSuccess(responseData['success'])) {
        _showMessage(
          currentL10n.resetSuccessful,
          success: true,
        );

        _newPasswordController.clear();
        _confirmPasswordController.clear();

        await Future<void>.delayed(
          const Duration(milliseconds: 700),
        );

        if (!mounted) return;

        // Return to Login screen
        Navigator.pop(context);
      } else {

        // ====================================================
        // RESET FAILED
        // ====================================================

        final String serverMessage =
            responseData['message']
                ?.toString()
                .trim() ??
                '';

        _showMessage(
          serverMessage.isNotEmpty
              ? serverMessage
              : currentL10n.resetFailed,
        );
      }

    } on TimeoutException {
      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!
            .connectionTimedOut,
      );

    } catch (e) {
      debugPrint('Reset password error: $e');

      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!
            .networkError,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isResettingPassword = false;
        });
      }
    }
  }

  // ==========================================================
  // PASSWORD INPUT HELPER
  // ==========================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool visible,
    required VoidCallback onToggle,
    TextInputAction inputAction =
        TextInputAction.next,
    VoidCallback? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      textInputAction: inputAction,

      onSubmitted: onSubmitted == null
          ? null
          : (_) => onSubmitted(),

      decoration: InputDecoration(
        labelText: label,

        filled: true,
        fillColor: Colors.white,

        prefixIcon: Icon(icon),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(10),
        ),

        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),

        suffixIcon: IconButton(
          icon: Icon(
            visible
                ? Icons.visibility
                : Icons.visibility_off,
          ),

          onPressed: onToggle,
        ),
      ),

      style: const TextStyle(fontSize: 18),
    );
  }

  // ==========================================================
  // BUILD PAGE
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
          l10n.forgotPasswordTitle,

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

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              width: double.infinity,

              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),

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
                      // FORGOT PASSWORD IMAGE
                      // =======================================

                      if (!_showPasswordFields)
                        Image.asset(
                          'assets/forgot.png',
                          height: 200,
                          width: 300,
                        ),

                      // =======================================
                      // RESET PASSWORD IMAGE
                      // =======================================

                      if (_showPasswordFields)
                        Image.asset(
                          'assets/password.png',
                          height: 300,
                          width: 350,
                        ),

                      const SizedBox(height: 20),

                      // =======================================
                      // EMAIL FIELD
                      // =======================================

                      TextField(
                        controller: _emailController,

                        readOnly: _showPasswordFields,

                        keyboardType:
                        TextInputType.emailAddress,

                        textDirection: TextDirection.ltr,

                        textInputAction:
                        TextInputAction.done,

                        onSubmitted: (_) {
                          if (!_showPasswordFields &&
                              !_isCheckingEmail) {
                            _checkEmail();
                          }
                        },

                        decoration: InputDecoration(
                          labelText: l10n.emailLabel,

                          filled: true,

                          fillColor: _showPasswordFields
                              ? Colors.grey[200]
                              : Colors.white,

                          prefixIcon: const Icon(
                            Icons.email_outlined,
                          ),

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),

                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),

                          suffixIcon: _showPasswordFields
                              ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                              : null,
                        ),

                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // PASSWORD FIELDS
                      // =======================================

                      if (_showPasswordFields) ...[

                        // NEW PASSWORD
                        _passwordField(
                          controller:
                          _newPasswordController,

                          label: l10n.newPasswordLabel,

                          icon: Icons.lock_reset,

                          visible: _newPasswordVisible,

                          onToggle: () {
                            setState(() {
                              _newPasswordVisible =
                              !_newPasswordVisible;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // CONFIRM PASSWORD
                        _passwordField(
                          controller:
                          _confirmPasswordController,

                          label:
                          l10n.confirmPasswordLabel,

                          icon:
                          Icons.lock_person_outlined,

                          visible:
                          _confirmPasswordVisible,

                          inputAction:
                          TextInputAction.done,

                          onToggle: () {
                            setState(() {
                              _confirmPasswordVisible =
                              !_confirmPasswordVisible;
                            });
                          },

                          onSubmitted: () {
                            if (!_isResettingPassword) {
                              _resetPassword();
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        // RESET BUTTON
                        _actionButton(
                          label: l10n.resetPasswordButton,

                          loading: _isResettingPassword,

                          onPressed: _resetPassword,
                        ),

                      ] else ...[

                        // CHECK EMAIL BUTTON
                        _actionButton(
                          label: l10n.checkEmailButton,

                          loading: _isCheckingEmail,

                          onPressed: _checkEmail,
                        ),
                      ],
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
  // ACTION BUTTON
  // ==========================================================

  Widget _actionButton({
    required String label,
    required bool loading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCE93D8),
          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),

        child: loading
            ? const SizedBox(
          width: 24,
          height: 24,

          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        )
            : Text(
          label,

          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
}

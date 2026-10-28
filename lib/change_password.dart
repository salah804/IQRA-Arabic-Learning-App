
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqra/api_config.dart';
import 'l10n/app_localizations.dart';

// ============================================================
// IQRA BILINGUAL CHANGE PASSWORD PAGE
// ============================================================

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends State<ChangePasswordPage> {

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _currentPasswordController =
  TextEditingController();

  final TextEditingController _newPasswordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // ==========================================================
  // PASSWORD VISIBILITY
  // ==========================================================

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  bool _isLoading = false;

  String username = '';

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // ==========================================================
  // LOAD USERNAME
  // ==========================================================

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    final savedUsername =
        prefs.getString('username') ?? '';

    if (!mounted) return;

    setState(() {
      username = savedUsername;
    });
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void _showMessage(
      String message, {
        bool success = false,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
          success ? Colors.green : Colors.red,
        ),
      );
  }

  // ==========================================================
  // CHANGE PASSWORD
  // ==========================================================

  Future<void> _changePassword() async {
    if (_isLoading) return;

    final l10n = AppLocalizations.of(context)!;

    final currentPassword =
        _currentPasswordController.text;

    final newPassword =
        _newPasswordController.text;

    final confirmPassword =
        _confirmPasswordController.text;

    // ========================================================
    // CHECK USERNAME
    // ========================================================

    if (username.isEmpty) {
      _showMessage(l10n.usernameMissing);
      return;
    }

    // ========================================================
    // CHECK EMPTY FIELDS
    // ========================================================

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(l10n.fillAllFields);
      return;
    }

    // ========================================================
    // CHECK PASSWORD MATCH
    // ========================================================

    if (newPassword != confirmPassword) {
      _showMessage(l10n.passwordsDoNotMatch);
      return;
    }

    // ========================================================
    // CHECK SAME PASSWORD
    // ========================================================

    if (currentPassword == newPassword) {
      _showMessage(l10n.newPasswordMustDiffer);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      // ======================================================
      // ONLINE PHP PASSWORD CHANGE REQUEST
      // ======================================================

      final Uri url = Uri.parse(
        '${ApiConfig.baseUrl}/change_password.php',
      );

      final http.Response response = await http.post(
        url,
        body: {
          'username': username,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      ).timeout(
        const Duration(seconds: 30),
      );

      if (!mounted) return;

      final currentL10n =
      AppLocalizations.of(context)!;

      // ======================================================
      // HTTP ERROR
      // ======================================================

      if (response.statusCode != 200) {
        _showMessage(
          currentL10n.serverErrorStatus(
            response.statusCode,
          ),
        );
        return;
      }

      // ======================================================
      // DECODE JSON RESPONSE
      // ======================================================

      Map<String, dynamic> responseData;

      try {
        final responseBody =
        utf8.decode(response.bodyBytes);

        final decoded = jsonDecode(responseBody);

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid server response',
          );
        }

        responseData = decoded;
      } catch (e) {
        debugPrint('Change password JSON error: $e');

        _showMessage(
          currentL10n.invalidServerResponse,
        );
        return;
      }

      // ======================================================
      // PASSWORD CHANGED SUCCESSFULLY
      // ======================================================

      if (responseData['success'] == true) {
        _showMessage(
          currentL10n.changePasswordSuccessful,
          success: true,
        );

        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        await Future<void>.delayed(
          const Duration(milliseconds: 700),
        );

        if (!mounted) return;

        Navigator.pop(context);
      } else {

        // ====================================================
        // PASSWORD CHANGE FAILED
        // ====================================================

        final serverMessage =
            responseData['message']
                ?.toString()
                .trim() ??
                '';

        _showMessage(
          serverMessage.isNotEmpty
              ? serverMessage
              : currentL10n.changePasswordFailed,
        );
      }

    } on TimeoutException {

      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!
            .connectionTimedOut,
      );

    } catch (e) {

      debugPrint('Change password error: $e');

      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!.networkError,
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
  // REUSABLE PASSWORD FIELD
  // ==========================================================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool visible,
    required VoidCallback onVisibilityPressed,
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
          borderRadius: BorderRadius.circular(10),
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
          onPressed: onVisibilityPressed,
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
          l10n.changePassword,
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
                      // IMAGE
                      // =======================================

                      Image.asset(
                        'assets/forgot password1.png',
                        width: 400,
                        height: 300,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 10),

                      // =======================================
                      // CURRENT PASSWORD
                      // =======================================

                      _buildPasswordField(
                        controller:
                        _currentPasswordController,

                        label: l10n.currentPasswordLabel,

                        icon: Icons.lock_outline,

                        visible: _currentPasswordVisible,

                        onVisibilityPressed: () {
                          setState(() {
                            _currentPasswordVisible =
                            !_currentPasswordVisible;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // NEW PASSWORD
                      // =======================================

                      _buildPasswordField(
                        controller:
                        _newPasswordController,

                        label: l10n.newPasswordLabel,

                        icon: Icons.lock_reset,

                        visible: _newPasswordVisible,

                        onVisibilityPressed: () {
                          setState(() {
                            _newPasswordVisible =
                            !_newPasswordVisible;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // =======================================
                      // CONFIRM PASSWORD
                      // =======================================

                      _buildPasswordField(
                        controller:
                        _confirmPasswordController,

                        label: l10n.confirmPasswordLabel,

                        icon: Icons.lock_person_outlined,

                        visible: _confirmPasswordVisible,

                        inputAction:
                        TextInputAction.done,

                        onVisibilityPressed: () {
                          setState(() {
                            _confirmPasswordVisible =
                            !_confirmPasswordVisible;
                          });
                        },

                        onSubmitted: () {
                          if (!_isLoading) {
                            _changePassword();
                          }
                        },
                      ),

                      const SizedBox(height: 25),

                      // =======================================
                      // CHANGE PASSWORD BUTTON
                      // =======================================

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _changePassword,

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFCE93D8),

                            foregroundColor:
                            Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,

                            child:
                            CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            l10n.changePassword,

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.bold,
                            ),
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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
}

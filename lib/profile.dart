
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:aqra/api_config.dart';
import 'l10n/app_localizations.dart';

// ============================================================
// IQRA BILINGUAL PROFILE
// ============================================================

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // ==========================================================
  // PROFILE DATA
  // ==========================================================

  Uint8List? imageBytes;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _isEditingEmail = false;
  bool _isEditingAge = false;
  bool _isEditingPhoneNumber = false;

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isUpdating = false;
  bool _isUploadingImage = false;

  String _currentUsername = '';

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ==========================================================
  // TOAST HELPER
  // ==========================================================

  void _showToast(
      String message, {
        bool success = false,
      }) {
    if (!mounted) return;

    Fluttertoast.showToast(
      msg: message,
      backgroundColor:
      success ? Colors.green : Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  String _serverMessage(
      dynamic response,
      String fallback,
      ) {
    if (response is Map) {
      final message = (
          response['error'] ??
              response['message'] ??
              ''
      ).toString().trim();

      if (message.isNotEmpty) {
        return message;
      }
    }

    return fallback;
  }

  // ==========================================================
  // CACHE HELPERS
  // ==========================================================

  String _cacheKey(String username, String key) {
    return 'profile_${username}_$key';
  }

  Future<File> _getProfileImageCacheFile(
      String username,
      ) async {
    final directory =
    await getApplicationDocumentsDirectory();

    final safeUsername = username.replaceAll(
      RegExp(r'[^a-zA-Z0-9_-]'),
      '_',
    );

    return File(
      '${directory.path}/profile_$safeUsername.jpg',
    );
  }

  // ==========================================================
  // LOAD USER
  // CACHE FIRST, SERVER SECOND
  // ==========================================================

  Future<void> _loadUserData() async {
    try {
      final prefs =
      await SharedPreferences.getInstance();

      final username =
          prefs.getString('username') ?? '';

      if (!mounted) return;

      if (username.isEmpty) {
        _showToast(
          AppLocalizations.of(context)!
              .usernameMissing,
        );

        setState(() {
          _isLoading = false;
        });
        return;
      }

      _currentUsername = username;

      final hasCache =
      await _loadProfileCache(username);

      if (!mounted) return;

      await _fetchUserData(
        username,
        showLoader: !hasCache,
        showErrors: !hasCache,
      );
    } catch (e) {
      debugPrint('LOAD PROFILE ERROR: $e');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .profileLoadFailed,
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ==========================================================
  // LOAD PROFILE CACHE
  // ==========================================================

  Future<bool> _loadProfileCache(
      String username,
      ) async {
    try {
      final prefs =
      await SharedPreferences.getInstance();

      final hasCache = prefs.getBool(
        _cacheKey(username, 'cached'),
      ) ?? false;

      if (!hasCache) return false;

      final cachedUsername = prefs.getString(
        _cacheKey(username, 'username'),
      ) ?? username;

      final cachedEmail = prefs.getString(
        _cacheKey(username, 'email'),
      ) ?? '';

      final cachedGender = prefs.getString(
        _cacheKey(username, 'gender'),
      ) ?? '';

      final cachedAge = prefs.getString(
        _cacheKey(username, 'age'),
      ) ?? '';

      final cachedPhone = prefs.getString(
        _cacheKey(username, 'phone'),
      ) ?? '';

      Uint8List? cachedImage;

      try {
        final imageFile =
        await _getProfileImageCacheFile(username);

        if (await imageFile.exists()) {
          cachedImage =
          await imageFile.readAsBytes();
        }
      } catch (e) {
        debugPrint('CACHE IMAGE ERROR: $e');
      }

      if (!mounted) return false;

      setState(() {
        _usernameController.text = cachedUsername;
        _emailController.text = cachedEmail;
        _genderController.text = cachedGender;
        _ageController.text = cachedAge;
        _phoneNumberController.text = cachedPhone;

        imageBytes = cachedImage;
        _isLoading = false;
      });

      debugPrint('PROFILE: Loaded from cache');
      return true;

    } catch (e) {
      debugPrint('PROFILE CACHE ERROR: $e');
      return false;
    }
  }

  // ==========================================================
  // SAVE PROFILE CACHE
  // ==========================================================

  Future<void> _saveProfileCache(
      String username,
      ) async {
    try {
      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        _cacheKey(username, 'username'),
        _usernameController.text.trim(),
      );

      await prefs.setString(
        _cacheKey(username, 'email'),
        _emailController.text.trim(),
      );

      await prefs.setString(
        _cacheKey(username, 'gender'),
        _genderController.text.trim(),
      );

      await prefs.setString(
        _cacheKey(username, 'age'),
        _ageController.text.trim(),
      );

      await prefs.setString(
        _cacheKey(username, 'phone'),
        _phoneNumberController.text.trim(),
      );

      await prefs.setBool(
        _cacheKey(username, 'cached'),
        true,
      );

      final imageFile =
      await _getProfileImageCacheFile(username);

      if (imageBytes != null) {
        await imageFile.writeAsBytes(
          imageBytes!,
          flush: false,
        );
      } else if (await imageFile.exists()) {
        await imageFile.delete();
      }

      debugPrint('PROFILE: Cache saved');

    } catch (e) {
      debugPrint('PROFILE CACHE SAVE ERROR: $e');
    }
  }

  // ==========================================================
  // FETCH PROFILE FROM PHP SERVER
  // ==========================================================

  Future<void> _fetchUserData(
      String username, {
        bool showLoader = false,
        bool showErrors = true,
      }) async {

    if (mounted) {
      setState(() {
        if (showLoader) {
          _isLoading = true;
        } else {
          _isRefreshing = true;
        }
      });
    }

    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/getUserDetails.php',
      ).replace(
        queryParameters: {
          'username': username,
        },
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      final responseBody =
      utf8.decode(response.bodyBytes);

      final decoded = jsonDecode(responseBody);

      if (decoded is! Map<String, dynamic> ||
          decoded['success'] != true ||
          decoded['data'] is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid profile response',
        );
      }

      final Map<String, dynamic> data =
      decoded['data'];

      // ======================================================
      // DECODE PROFILE IMAGE
      // ======================================================

      final imageData = data['image'];

      Uint8List? serverImageBytes;
      bool imageDecoded = false;

      if (imageData != null &&
          imageData.toString().trim().isNotEmpty) {
        try {
          String imageString =
          imageData.toString().trim();

          if (imageString.contains('base64,')) {
            imageString =
                imageString.split('base64,').last;
          }

          serverImageBytes =
              base64Decode(imageString);

          imageDecoded = true;

        } catch (e) {
          debugPrint('IMAGE DECODE ERROR: $e');
        }
      }

      if (!mounted) return;

      setState(() {
        _usernameController.text =
            data['Username']?.toString() ??
                username;

        _emailController.text =
            data['Email']?.toString() ?? '';

        _genderController.text =
            data['Gender']?.toString() ?? '';

        _ageController.text =
            data['Age']?.toString() ?? '';

        _phoneNumberController.text =
            data['Phonenumber']?.toString() ?? '';

        if (imageDecoded) {
          imageBytes = serverImageBytes;
        } else if (imageData == null ||
            imageData.toString().trim().isEmpty) {
          imageBytes = null;
        }

        _isLoading = false;
      });

      await _saveProfileCache(username);

    } catch (e) {
      debugPrint('PROFILE FETCH ERROR: $e');

      if (showErrors && mounted) {
        _showToast(
          AppLocalizations.of(context)!
              .profileLoadFailed,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  // ==========================================================
  // REFRESH PROFILE
  // ==========================================================

  Future<void> _refreshProfile() async {
    if (_currentUsername.isEmpty ||
        _isRefreshing ||
        _isUpdating) {
      return;
    }

    await _fetchUserData(
      _currentUsername,
      showLoader: false,
      showErrors: true,
    );
  }

  // ==========================================================
  // UPDATE PROFILE
  // ==========================================================

  Future<void> _updateProfile() async {
    if (_isUpdating) return;

    final l10n = AppLocalizations.of(context)!;

    final prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    final username =
        prefs.getString('username') ?? '';

    if (username.isEmpty) {
      _showToast(l10n.usernameMissing);
      return;
    }

    final email =
    _emailController.text.trim();

    // Stored as backend-compatible value
    final gender =
    _genderController.text.trim();

    final age =
    _ageController.text.trim();

    final phoneNumber =
    _phoneNumberController.text.trim();

    if (email.isEmpty ||
        gender.isEmpty ||
        age.isEmpty ||
        phoneNumber.isEmpty) {
      _showToast(l10n.profileFieldsRequired);
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/update_profile.php',
      );

      final response = await http.post(
        url,
        body: {
          'username': username,
          'email': email,
          'gender': gender,
          'age': age,
          'phone_number': phoneNumber,
        },
      ).timeout(
        const Duration(seconds: 15),
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        _showToast(
          AppLocalizations.of(context)!
              .serverErrorStatus(response.statusCode),
        );
        return;
      }

      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is Map<String, dynamic> &&
          decoded['success'] == true) {

        setState(() {
          _isEditingEmail = false;
          _isEditingAge = false;
          _isEditingPhoneNumber = false;
        });

        await _saveProfileCache(username);

        if (!mounted) return;

        _showToast(
          AppLocalizations.of(context)!
              .profileUpdateSuccessful,
          success: true,
        );

      } else {
        _showToast(
          _serverMessage(
            decoded,
            AppLocalizations.of(context)!
                .profileUpdateFailed,
          ),
        );
      }

    } catch (e) {
      debugPrint('PROFILE UPDATE ERROR: $e');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .profileUpdateNetworkError,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  // ==========================================================
  // SELECT PROFILE PHOTO
  // ==========================================================

  Future<void> _pickImage() async {
    if (_isUploadingImage) return;

    try {
      final picker = ImagePicker();

      final XFile? pickedImage =
      await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 800,
      );

      if (pickedImage == null) return;

      final pickedImageBytes =
      await pickedImage.readAsBytes();

      if (!mounted) return;

      await _uploadImage(pickedImageBytes);

    } catch (e) {
      debugPrint('IMAGE PICKER ERROR: $e');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .profileImagePickFailed,
      );
    }
  }

  // ==========================================================
  // UPLOAD PHOTO TO PHP SERVER
  // ==========================================================

  Future<void> _uploadImage(
      Uint8List newImageBytes,
      ) async {
    if (_isUploadingImage) return;

    final prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    final username =
        prefs.getString('username') ?? '';

    if (username.isEmpty) {
      _showToast(
        AppLocalizations.of(context)!
            .usernameMissing,
      );
      return;
    }

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/upload_image.php',
      );

      final request =
      http.MultipartRequest('POST', url);

      request.fields['username'] = username;

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          newImageBytes,
          filename: 'profile.jpg',
        ),
      );

      final streamedResponse =
      await request.send().timeout(
        const Duration(seconds: 30),
      );

      final responseBody =
      await streamedResponse.stream.bytesToString();

      if (!mounted) return;

      if (streamedResponse.statusCode != 200) {
        _showToast(
          AppLocalizations.of(context)!
              .serverErrorStatus(
            streamedResponse.statusCode,
          ),
        );
        return;
      }

      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic> &&
          decoded['success'] == true) {

        setState(() {
          imageBytes = newImageBytes;
        });

        await _saveProfileCache(username);

        if (!mounted) return;

        _showToast(
          AppLocalizations.of(context)!
              .profilePhotoUpdated,
          success: true,
        );

      } else {
        _showToast(
          _serverMessage(
            decoded,
            AppLocalizations.of(context)!
                .profilePhotoUploadFailed,
          ),
        );
      }

    } catch (e) {
      debugPrint('UPLOAD IMAGE ERROR: $e');

      if (!mounted) return;

      _showToast(
        AppLocalizations.of(context)!
            .profilePhotoUploadNetworkError,
      );

    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  // ==========================================================
  // READ-ONLY TEXT FIELD
  // ==========================================================

  Widget _buildReadOnlyField(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: TextField(
        controller: controller,
        readOnly: true,

        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon),
          suffixIcon:
          const Icon(Icons.lock_outline),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // EDITABLE TEXT FIELD
  // ==========================================================

  Widget _buildEditableField(
      String label,
      TextEditingController controller,
      bool isEditing,
      VoidCallback onEdit, {
        IconData? icon,
        TextInputType? keyboardType,
        TextDirection? textDirection,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child: TextField(
        controller: controller,
        readOnly: !isEditing,
        keyboardType: keyboardType,
        textDirection: textDirection,

        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,

          prefixIcon:
          icon == null ? null : Icon(icon),

          suffixIcon: IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
            ),
            onPressed: onEdit,
          ),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BILINGUAL GENDER FIELD
  // ==========================================================

  Widget _buildGenderField(
      AppLocalizations l10n,
      ) {
    final rawGender =
    _genderController.text.trim();

    final normalized = rawGender.toLowerCase();

    String displayedGender = rawGender;

    if (normalized == 'male') {
      displayedGender = l10n.maleLabel;
    } else if (normalized == 'female') {
      displayedGender = l10n.femaleLabel;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.genderLabel,

          filled: true,
          fillColor: Colors.white,

          prefixIcon:
          const Icon(Icons.people_outline),

          suffixIcon: PopupMenuButton<String>(
            icon: const Icon(Icons.edit),

            onSelected: (value) {
              setState(() {
                // Preserve backend values
                _genderController.text = value;
              });
            },

            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'Male',
                child: Text(l10n.maleLabel),
              ),
              PopupMenuItem(
                value: 'Female',
                child: Text(l10n.femaleLabel),
              ),
            ],
          ),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
          ),
        ),

        child: Text(
          displayedGender.isEmpty
              ? ' '
              : displayedGender,

          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD PROFILE SCREEN
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
          l10n.profile,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor:
        const Color(0xFF607D8B),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [
          IconButton(
            tooltip: l10n.refreshProfile,

            onPressed: _isRefreshing
                ? null
                : _refreshProfile,

            icon: _isRefreshing
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.refresh),
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _refreshProfile,

        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          child: Container(
            width: double.infinity,

            constraints: BoxConstraints(
              minHeight:
              MediaQuery.of(context)
                  .size.height - 100,
            ),

            padding: const EdgeInsets.all(20),
            color: Colors.lime[300],

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [

                // =====================================
                // PROFILE PHOTO
                // =====================================

                Center(
                  child: GestureDetector(
                    onTap: _isUploadingImage
                        ? null
                        : _pickImage,

                    child: Stack(
                      children: [

                        CircleAvatar(
                          radius: 60,
                          backgroundColor:
                          Colors.white,

                          backgroundImage:
                          imageBytes != null
                              ? MemoryImage(
                            imageBytes!,
                          )
                              : null,

                          child: imageBytes == null
                              ? Icon(
                            Icons.person_outline,
                            size: 65,
                            color:
                            Colors.grey[500],
                          )
                              : null,
                        ),

                        if (_isUploadingImage)
                          Positioned.fill(
                            child: Container(
                              decoration:
                              BoxDecoration(
                                color: Colors.black
                                    .withOpacity(0.25),
                                shape:
                                BoxShape.circle,
                              ),

                              child: const Center(
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        PositionedDirectional(
                          bottom: 0,
                          end: 0,

                          child: Container(
                            padding:
                            const EdgeInsets.all(7),

                            decoration:
                            const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.camera_alt,
                              color:
                              Color(0xFF607D8B),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    imageBytes == null
                        ? l10n.addProfilePhoto
                        : l10n.changeProfilePhoto,

                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================
                // USERNAME
                // =====================================

                _buildReadOnlyField(
                  l10n.usernameLabel,
                  _usernameController,
                  Icons.person,
                ),

                // =====================================
                // EMAIL
                // =====================================

                _buildEditableField(
                  l10n.emailLabel,
                  _emailController,
                  _isEditingEmail,

                      () {
                    setState(() {
                      _isEditingEmail =
                      !_isEditingEmail;
                    });
                  },

                  icon: Icons.email_outlined,
                  keyboardType:
                  TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                ),

                // =====================================
                // GENDER
                // =====================================

                _buildGenderField(l10n),

                // =====================================
                // AGE
                // =====================================

                _buildEditableField(
                  l10n.ageLabel,
                  _ageController,
                  _isEditingAge,

                      () {
                    setState(() {
                      _isEditingAge =
                      !_isEditingAge;
                    });
                  },

                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),

                // =====================================
                // PHONE
                // =====================================

                _buildEditableField(
                  l10n.phoneNumberLabel,
                  _phoneNumberController,
                  _isEditingPhoneNumber,

                      () {
                    setState(() {
                      _isEditingPhoneNumber =
                      !_isEditingPhoneNumber;
                    });
                  },

                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                ),

                const SizedBox(height: 15),

                // =====================================
                // UPDATE PROFILE BUTTON
                // =====================================

                ElevatedButton(
                  onPressed: _isUpdating
                      ? null
                      : _updateProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFCE93D8),

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                  ),

                  child: _isUpdating
                      ? const SizedBox(
                    width: 25,
                    height: 25,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    l10n.updateProfile,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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
    _genderController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }
}

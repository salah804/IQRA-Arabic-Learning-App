import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aqra/api_config.dart';


// ==========================================================
// UPDATE SERVICE
// ==========================================================

class UpdateService {
  UpdateService._();

  static bool _alreadyChecked = false;


  // ========================================================
  // CHECK FOR UPDATE
  // ========================================================

  static Future<void> checkForUpdate(
      BuildContext context, {
        bool manualCheck = false,
      }) async {
    if (_alreadyChecked && !manualCheck) {
      return;
    }

    if (!manualCheck) {
      _alreadyChecked = true;
    }

    try {
      // ====================================================
      // CURRENT INSTALLED APP VERSION
      // ====================================================

      final PackageInfo packageInfo =
      await PackageInfo.fromPlatform();

      final String currentVersion =
          packageInfo.version;

      final int currentBuild =
          int.tryParse(
            packageInfo.buildNumber,
          ) ??
              0;

      debugPrint(
        'CURRENT VERSION: $currentVersion',
      );

      debugPrint(
        'CURRENT BUILD: $currentBuild',
      );

      // ====================================================
      // SERVER URL
      // Cache-busting query avoids stale update data.
      // ====================================================

      final Uri url = Uri.parse(
        '${ApiConfig.baseUrl}/latest_version.php',
      ).replace(
        queryParameters: {
          't': DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
        },
      );

      // ====================================================
      // REQUEST
      // ====================================================

      final http.Response response =
      await http
          .get(url)
          .timeout(
        const Duration(
          seconds: 10,
        ),
      );

      debugPrint(
        'UPDATE CHECK STATUS: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server error ${response.statusCode}',
        );
      }

      final String responseBody =
      utf8.decode(
        response.bodyBytes,
      );

      final dynamic decoded =
      jsonDecode(
        responseBody,
      );

      if (decoded is! Map<String, dynamic>) {
        throw Exception(
          'Invalid update response.',
        );
      }

      if (decoded['success'] != true) {
        throw Exception(
          decoded['message']
              ?.toString() ??
              decoded['error']
                  ?.toString() ??
              'Update check failed.',
        );
      }

      // ====================================================
      // SERVER VERSION DATA
      // ====================================================

      final String latestVersion =
          decoded['version']
              ?.toString()
              .trim() ??
              '';

      final int latestBuild =
          int.tryParse(
            decoded['build']
                ?.toString() ??
                '',
          ) ??
              0;

      final String apkUrl =
          decoded['apk_url']
              ?.toString()
              .trim() ??
              '';

      final String message =
          decoded['message']
              ?.toString()
              .trim() ??
              'A new IQRA update is available.';

      final bool forceUpdate =
          decoded['force_update'] == true ||
              decoded['force_update']
                  ?.toString()
                  .toLowerCase() ==
                  'true';

      debugPrint(
        'SERVER VERSION: $latestVersion',
      );

      debugPrint(
        'SERVER BUILD: $latestBuild',
      );

      // ====================================================
      // UPDATE AVAILABLE
      // ====================================================

      if (latestBuild > currentBuild) {
        if (!context.mounted) {
          return;
        }

        await _showUpdateDialog(
          context: context,
          latestVersion: latestVersion,
          currentVersion: currentVersion,
          message: message,
          apkUrl: apkUrl,
          forceUpdate: forceUpdate,
        );

        return;
      }

      // ====================================================
      // ALREADY UP TO DATE
      // ====================================================

      debugPrint(
        'IQRA IS UP TO DATE ✅',
      );

      if (manualCheck && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              latestVersion.isEmpty
                  ? 'IQRA is already up to date ✅'
                  : 'IQRA is already up to date ✅  Version $currentVersion',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint(
        'UPDATE CHECK ERROR: $e',
      );

      // Automatic checks fail silently so the app
      // still opens normally when the server is offline.
      if (manualCheck && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to check for updates right now.',
            ),
          ),
        );
      }
    }
  }


  // ========================================================
  // UPDATE DIALOG
  // ========================================================

  static Future<void> _showUpdateDialog({
    required BuildContext context,
    required String latestVersion,
    required String currentVersion,
    required String message,
    required String apkUrl,
    required bool forceUpdate,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: !forceUpdate,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'Update Available',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'A new version of IQRA is available.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  'Current version: $currentVersion',
                ),
                Text(
                  'New version: ${latestVersion.isEmpty ? 'New update' : latestVersion}',
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  message,
                ),
                if (forceUpdate) ...[
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'This update is required to continue using IQRA.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (!forceUpdate)
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                    ).pop();
                  },
                  child: const Text(
                    'Later',
                  ),
                ),
              ElevatedButton.icon(
                onPressed: apkUrl.isEmpty
                    ? null
                    : () async {
                  final bool opened =
                  await _openDownloadPage(
                    apkUrl,
                  );

                  if (!opened &&
                      dialogContext.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Unable to open the update download link.',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.download,
                ),
                label: const Text(
                  'Update Now',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // ========================================================
  // OPEN APK DOWNLOAD LINK
  // ========================================================

  static Future<bool> _openDownloadPage(
      String apkUrl,
      ) async {
    final Uri? uri =
    Uri.tryParse(
      apkUrl,
    );

    if (uri == null ||
        !(uri.scheme == 'https' ||
            uri.scheme == 'http')) {
      debugPrint(
        'INVALID APK URL: $apkUrl',
      );

      return false;
    }

    try {
      final bool launched =
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint(
          'Could not open APK URL.',
        );
      }

      return launched;
    } catch (e) {
      debugPrint(
        'APK DOWNLOAD ERROR: $e',
      );

      return false;
    }
  }
}

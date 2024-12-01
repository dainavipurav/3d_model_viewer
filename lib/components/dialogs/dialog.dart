import 'package:flutter/material.dart';
import 'package:threed_viewer/components/dialogs/info_dialog.dart';

class AppDialog {
  static Future<void> showAppDialog(
    BuildContext context, {
    String? title,
    final VoidCallback? onTap,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return InfoDialog(
          title: title,
          message: message,
          onTap: onTap,
        );
      },
    );
  }
}

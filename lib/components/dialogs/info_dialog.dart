import 'package:flutter/material.dart';
import 'package:threed_viewer/common/app_colors.dart';
import 'package:threed_viewer/utils/strings.dart';

class InfoDialog extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onTap;
  const InfoDialog({
    super.key,
    this.title,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 300,
        ),
        child: AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            title ?? AppStrings.appName,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.background,
          content: Text(message,
              style: TextStyle(color: AppColors.white.withOpacity(0.7))),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (onTap != null) onTap!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(AppStrings.ok),
            ),
          ],
        ),
      ),
    );
  }
}

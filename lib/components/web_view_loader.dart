import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:threed_viewer/common/app_colors.dart';
import 'package:threed_viewer/utils/strings.dart';

class WebViewLoader extends StatelessWidget {
  const WebViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: MediaQuery.of(context).size.width,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: CircularProgressIndicator(
                    color: AppColors.white.withOpacity(0.8),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    AppStrings.loadingMsg,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

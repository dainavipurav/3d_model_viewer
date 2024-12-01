import 'package:flutter/material.dart';
import 'package:threed_viewer/common/app_colors.dart';

abstract class DesignContants {
  static MenuStyle menuStyle = const MenuStyle(
    padding: WidgetStatePropertyAll(EdgeInsets.zero),
    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
    maximumSize: WidgetStatePropertyAll(Size(double.infinity, 36)),
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
  );

  static ButtonStyle barButtonStyle = const ButtonStyle(
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 6.0)),
    minimumSize: WidgetStatePropertyAll(Size(0.0, 32.0)),
    overlayColor: WidgetStatePropertyAll(AppColors.secondry),
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
  );

  static ButtonStyle menuButtonStyle = const ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size.fromHeight(36.0)),
    padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0)),
    iconSize: WidgetStatePropertyAll(18),
    overlayColor: WidgetStatePropertyAll(AppColors.secondry),
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

class AppWindowManager {
  static Future<void> setWindowDefaultSize() async {

    const double minWidth = 600;
    const double minHeight = (minWidth * (9 / 16)) + 120;

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 550),
      center: true,
      title: '3D Viewer',
      // windowButtonVisibility: false,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(const Size(minWidth, minHeight));
      await windowManager.show();
      await windowManager.focus();
    });
  }
}

final windowStateProvider = StateNotifierProvider<WindowStateNotifier, String>(
  (ref) => WindowStateNotifier(),
);

class WindowStateNotifier extends StateNotifier<String> {
  WindowStateNotifier() : super('Normal');

  void setWindowResized() {
    state = 'Resized';
  }

  void setWindowMaximized() {
    state = 'Maximized';
  }

  void setWindowMinimized() {
    state = 'Minimized';
  }
}

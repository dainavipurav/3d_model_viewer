import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/pages/home_page.dart';
import 'package:threed_viewer/utils/logger.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [Logger()],
      child: const MaterialApp(home: HomePage()),
    );
  }
}

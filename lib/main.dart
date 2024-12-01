import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threed_viewer/app.dart';
import 'package:threed_viewer/core/app_window_manager.dart';
import 'package:threed_viewer/core/server/app_local_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await AppLocalServer.startServer();
  await AppWindowManager.setWindowDefaultSize();
  runApp(const App());
}

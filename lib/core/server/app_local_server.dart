import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:developer' as developer;

class AppLocalServer {

  /// Starts the InAppLocalhostServer.
  ///
  /// You can optionally pass a custom port. If no port is provided, 
  /// the default port `51492` will be used. If the server fails to 
  /// start, an error with details is thrown.
  /// 
  static Future<void> startServer({int? port}) async {
    final int serverPort = port ?? 51492;

    try {
      final localhostServer = InAppLocalhostServer(port: serverPort);

      if (!kIsWeb) {
        developer.log('Starting server on port: $serverPort', name: 'AppLocalServer');
        await localhostServer.start();
        developer.log('Server started successfully on port: $serverPort', name: 'AppLocalServer');
      } else {
        developer.log('Web environment detected. Server start skipped.', name: 'AppLocalServer');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Failed to start server on port: $serverPort. Error: $e\nStackTrace: $stackTrace',
        name: 'AppLocalServer',
        level: 1000,
      );
      throw UnimplementedError('Unable to start server on port $serverPort: $e');
    }
  }
}

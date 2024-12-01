import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/providers/providers.dart';
import 'package:threed_viewer/utils/enums.dart';
import 'dart:async';

class MediaService {
  static Future<String?> pickFile({
    required WidgetRef ref,
    List<String> allowedExtensions = const ['obj', 'stl', 'glb'],
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result == null) {
        ref.read(errorStateProvider.notifier).state =
            FilePickerError.fileNotFound;
        return null;
      }

      if (result.files.single.path == null) {
        ref.read(errorStateProvider.notifier).state =
            FilePickerError.pathNotFound;
        return null;
      }

      final filePath = result.files.single.path!;
      final extension = filePath.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(extension)) {
        ref.read(errorStateProvider.notifier).state =
            FilePickerError.unSupportedFile;
        return null;
      }

      return filePath.replaceAll('\\', '/');
    } catch (e) {
      ref.read(errorStateProvider.notifier).state =
          FilePickerError.unSupportedFile;
      ref.read(loadingValueProvider.notifier).state = false;
    }

    return null;
  }

  static bool isObjFile(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return extension == 'obj';
  }

  static Future<Uint8List> loadFileAsyncWithIsolate(String filePath) async {
    final receivePort = ReceivePort();

    final isolate = await Isolate.spawn(_readBytes, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final byteArrayReceivePort = ReceivePort();
    sendPort.send([filePath, byteArrayReceivePort.sendPort]);

    final byteArray = await byteArrayReceivePort.first as Uint8List;

    isolate.kill();
    receivePort.close();
    byteArrayReceivePort.close();

    return byteArray;
  }

  static void _readBytes(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    final message = await port.first as List;
    final filePath = message[0] as String;
    final replySendPort = message[1] as SendPort;

    final bytes = await File(filePath).readAsBytes();
    replySendPort.send(bytes);
  }
}

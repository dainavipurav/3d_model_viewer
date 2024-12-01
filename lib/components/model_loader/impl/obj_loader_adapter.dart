import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threed_viewer/components/model_loader/model_loader.dart';

class ObjLoaderAdapter implements ModelLoader {
  @override
  Future<void> load(String modelByteArray, InAppWebViewController controller,
      [String? materialByteArray]) async {
    try {
      final jsCode =
          'loadFileFromDevice(new Uint8Array([$modelByteArray]), new Uint8Array([$materialByteArray]), "obj");';
      await controller.evaluateJavascript(source: jsCode);
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:threed_viewer/components/model_loader/model_loader.dart';

class GlbLoaderAdapter implements ModelLoader {
  @override
  Future<void> load(String modelByteArray, InAppWebViewController controller,
      [String? materialByteArray]) async {
    try {
      final jsCode =
          'loadFileFromDevice(new Uint8Array([$modelByteArray]), null, "glb");';
      await controller.evaluateJavascript(source: jsCode);
    } catch (e) {
      rethrow;
    }
  }
}

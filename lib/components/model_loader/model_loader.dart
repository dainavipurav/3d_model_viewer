import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract interface class ModelLoader {
  Future<void> load(String modelByteArray, InAppWebViewController ref, [String? materialByteArray]);
}

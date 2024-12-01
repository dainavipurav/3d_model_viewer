import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/pages/home_view_model.dart';
import 'package:threed_viewer/utils/enums.dart';

final webViewControllerProvider =
    StateProvider<InAppWebViewController?>((ref) => null);

final loadingValueProvider = StateProvider<bool>(
  (ref) => false,
);

final errorStateProvider = StateProvider<FilePickerError?>((ref) {
  return null;
});

final filePathProvider = StateProvider<String?>(
  (ref) => null,
);

final homeViewModelProvider = Provider<HomeViewModel>((ref) => HomeViewModel());

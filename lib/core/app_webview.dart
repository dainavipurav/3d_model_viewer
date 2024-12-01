import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/components/dialogs/dialog.dart';
import 'package:threed_viewer/components/web_view_loader.dart';
import 'package:threed_viewer/utils/strings.dart';

import '../providers/providers.dart';

Future<void> updateModelView(WidgetRef ref) async {
  ref.read(loadingValueProvider.notifier).state = true;

  final webviewControllerState =
      ref.read(webViewControllerProvider.notifier).state;

  try {
    if (webviewControllerState == null) return;
    await webviewControllerState.evaluateJavascript(
        source: 'onWindowResize();');
  } catch (e) {
    rethrow;
  }
  ref.read(loadingValueProvider.notifier).state = false;
}

class AppWebview extends ConsumerStatefulWidget {
  const AppWebview({super.key});

  @override
  ConsumerState<AppWebview> createState() => _AppWebviewState();
}

class _AppWebviewState extends ConsumerState<AppWebview>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    updateModelView(ref);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
      allowFileAccess: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      transparentBackground: true,
      overScrollMode: OverScrollMode.NEVER,
      disableHorizontalScroll: true,
      disableVerticalScroll: true,
    );

    return Stack(
      children: [
        InAppWebView(
          initialSettings: settings,
          initialUrlRequest: URLRequest(
            url: WebUri('${AppStrings.localhostUrl}/assets/html/index.html'),
          ),
          onConsoleMessage: (controller, consoleMessage) {
            print('Webview console message : $consoleMessage');
          },
          onLoadStart: (controller, url) {
            ref.read(loadingValueProvider.notifier).state = true;
          },
          onLoadStop: (controller, url) {
            ref.read(loadingValueProvider.notifier).state = false;
          },
          onReceivedError: (controller, request, error) {
            ref.read(loadingValueProvider.notifier).state = false;
          },
          onWebViewCreated: (controller) async {
            ref.read(webViewControllerProvider.notifier).state = controller;
            injectJsChannels(ref, context);
            print(controller.platform);
            print('onWebViewCreated ${controller.getUrl()}');
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
        ),
        if (ref.watch(loadingValueProvider))
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: WebViewLoader(),
          ),
      ],
    );
  }

  Widget errorWidget(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void injectJsChannels(WidgetRef ref, BuildContext context) {
    final webviewControllerState =
        ref.read(webViewControllerProvider.notifier).state;

    webviewControllerState!.addJavaScriptHandler(
      handlerName: 'showLoader',
      callback: (jsMessage) {
        ref.read(loadingValueProvider.notifier).state = true;
      },
    );

    webviewControllerState.addJavaScriptHandler(
      handlerName: 'hideLoader',
      callback: (jsMessage) {
        ref.read(loadingValueProvider.notifier).state = false;
      },
    );

    webviewControllerState.addJavaScriptHandler(
      handlerName: 'setError',
      callback: (jsMessage) {
        AppDialog.showAppDialog(
          context,
          message: jsMessage.toString(),
          title: 'Error',
        );
      },
    );

    webviewControllerState.addJavaScriptHandler(
      handlerName: 'refreshView',
      callback: (jsMessage) async {
        try {
          await webviewControllerState.evaluateJavascript(
              source: 'onWindowResize();');
        } catch (e) {
          rethrow;
        }
      },
    );
  }
}

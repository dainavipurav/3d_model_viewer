import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/common/app_colors.dart';
import 'package:threed_viewer/components/app_file_picker.dart';
import 'package:threed_viewer/components/desktop_menu_bar.dart';
import 'package:threed_viewer/components/dialogs/dialog.dart';
import 'package:threed_viewer/components/info_bar.dart';
import 'package:threed_viewer/components/model_loader/model_loader.dart';
import 'package:threed_viewer/components/model_loader/model_loader_factory.dart';
import 'package:threed_viewer/core/app_webview.dart';
import 'package:threed_viewer/providers/providers.dart';
import 'package:threed_viewer/utils/strings.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomePage> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filePicker = ref.watch(filePathProvider);
    final webViewController = ref.watch(webViewControllerProvider);

    return DesktopMenuBar(
      onImport: () async {
        String? modelFilepath;
        String? materialFilePath;

        Uint8List modelByteArray;
        Uint8List materialByteArray;

        modelFilepath = await MediaService.pickFile(
            ref: ref, allowedExtensions: ['obj', 'glb', 'stl']);

        if (modelFilepath == null) {
          if (!context.mounted) return;
          ref.read(loadingValueProvider.notifier).state = false;
          AppDialog.showAppDialog(
            context,
            message: ref.read(errorStateProvider.notifier).state!.displayName,
            title: 'Error',
          );

          return;
        }

        if (MediaService.isObjFile(modelFilepath)) {
          if (!context.mounted) return;

          await AppDialog.showAppDialog(
            context,
            message: AppStrings.resourceRequiredMsg,
            title: AppStrings.resourceRequired,
            onTap: () async {
              materialFilePath = await MediaService.pickFile(
                ref: ref,
                allowedExtensions: ['mtl'],
              );

              if (materialFilePath == null) {
                ref.read(loadingValueProvider.notifier).state = false;
                if (!context.mounted) return;
                AppDialog.showAppDialog(
                  context,
                  message:
                      ref.read(errorStateProvider.notifier).state!.displayName,
                  title: 'Error',
                );
                return;
              }

              ref.read(loadingValueProvider.notifier).state = true;
              modelByteArray =
                  await MediaService.loadFileAsyncWithIsolate(modelFilepath!);
              materialByteArray = await MediaService.loadFileAsyncWithIsolate(
                  materialFilePath!);

              ref.read(filePathProvider.notifier).state = modelFilepath;

              await loadModel(
                modelFilepath,
                modelByteArray.map((byte) => byte.toString()).join(','),
                materialByteArray.map((byte) => byte.toString()).join(','),
                webViewController!,
              );

              ref.read(loadingValueProvider.notifier).state = false;
              return;
            },
          );

          return;
        }

        ref.read(loadingValueProvider.notifier).state = true;
        modelByteArray =
            await MediaService.loadFileAsyncWithIsolate(modelFilepath);

        await loadModel(
          modelFilepath,
          modelByteArray.map((byte) => byte.toString()).join(','),
          null,
          webViewController!,
        );

        ref.read(filePathProvider.notifier).state = modelFilepath;
        ref.read(loadingValueProvider.notifier).state = false;
      },
      body: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            InfoBar(
              bgColor: AppColors.background,
              height: 28,
              isGradient: true,
              title: 'Current File: ',
              message: filePicker?.split('/').last ?? 'Demo 3D Model',
              icon: const Icon(
                Icons.view_in_ar,
                color: Colors.white,
                size: 14,
              ),
              textSize: 12,
            ),
            const Expanded(child: AppWebview()),
            InfoBar(
              bgColor: AppColors.primary,
              height: 20,
              title: 'Path:',
              message: filePicker?.replaceAll('/', ' > ').replaceFirst(
                        '>',
                        '',
                      ) ??
                  'Demo 3D Model',
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 14,
              ),
              textSize: 11,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadModel(
    String filePath,
    String modelByteArray,
    String? materialByteArray,
    InAppWebViewController controller,
  ) async {
    try {
      ModelLoader loader = ModelLoaderFactory.getLoader(filePath);
      await loader.load(modelByteArray, controller, materialByteArray);
    } catch (e) {
      throw Exception("Not able to load model: $e");
    }
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/components/app_file_picker.dart';
import 'package:threed_viewer/components/dialogs/dialog.dart';
import 'package:threed_viewer/components/model_loader/model_loader.dart';
import 'package:threed_viewer/components/model_loader/model_loader_factory.dart';
import 'package:threed_viewer/providers/providers.dart';
import 'package:threed_viewer/utils/strings.dart';

class HomeViewModel {
  Future<void> onImport(BuildContext context, {required WidgetRef ref}) async {
    String? modelFilepath;
    String? materialFilePath;

    Uint8List modelByteArray;
    Uint8List materialByteArray;

    modelFilepath = await MediaService.pickFile(
        ref: ref, allowedExtensions: ['obj', 'glb', 'stl']);

    final webViewController = ref.watch(webViewControllerProvider);
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
              message: ref.read(errorStateProvider.notifier).state!.displayName,
              title: 'Error',
            );
            return;
          }

          ref.read(loadingValueProvider.notifier).state = true;
          modelByteArray =
              await MediaService.loadFileAsyncWithIsolate(modelFilepath!);
          materialByteArray =
              await MediaService.loadFileAsyncWithIsolate(materialFilePath!);

          ref.read(filePathProvider.notifier).state = modelFilepath;

          if (!context.mounted) return;
          await loadModel(
            context,
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
    modelByteArray = await MediaService.loadFileAsyncWithIsolate(modelFilepath);

    if (!context.mounted) return;
    await loadModel(
      context,
      modelFilepath,
      modelByteArray.map((byte) => byte.toString()).join(','),
      null,
      webViewController!,
    );

    ref.read(filePathProvider.notifier).state = modelFilepath;
    ref.read(loadingValueProvider.notifier).state = false;
  }

  Future<void> loadModel(
    BuildContext context,
    String filePath,
    String modelByteArray,
    String? materialByteArray,
    InAppWebViewController controller,
  ) async {
    try {
      ModelLoader loader = ModelLoaderFactory.getLoader(filePath);
      await loader.load(modelByteArray, controller, materialByteArray);
    } catch (e) {
      if (!context.mounted) return;
      await AppDialog.showAppDialog(
        context,
        message: "Not able to load model: $e",
      );
      throw Exception("Not able to load model: $e");
    }
  }
}

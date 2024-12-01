import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threed_viewer/common/app_colors.dart';
import 'package:threed_viewer/components/desktop_menu_bar.dart';
import 'package:threed_viewer/components/info_bar.dart';
import 'package:threed_viewer/core/app_webview.dart';
import 'package:threed_viewer/providers/providers.dart';
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
    final viewModel = ref.watch(homeViewModelProvider);

    return DesktopMenuBar(
      onImport: () async => await viewModel.onImport(context, ref: ref),
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
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:threed_viewer/common/design_constants.dart';

class DesktopMenuBar extends ConsumerWidget {
  final Widget body;
  const DesktopMenuBar({required this.body, required this.onImport, super.key});

  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<BarButton> menus = [
      BarButton(
        text: const Text(
          'File',
          style: TextStyle(color: Colors.white),
        ),
        submenu: SubMenu(
          menuItems: [
            MenuButton(
              onTap: onImport,
              text: const Text('Import'),
              shortcutText: 'Ctrl+I',
              shortcut:
                  const SingleActivator(LogicalKeyboardKey.keyI, control: true),
            ),
            const MenuButton(
              onTap: null,
              text: Text('Save as'),
              shortcutText: 'Ctrl+Shift+S',
            ),
            const MenuDivider(),
            const MenuButton(
              onTap: null,
              text: Text('Open File'),
            ),
            const MenuButton(
              onTap: null,
              text: Text('Open Folder'),
            ),
            const MenuDivider(),
            const MenuButton(
              text: Text('Preferences'),
              icon: Icon(Icons.settings),
              submenu: SubMenu(
                menuItems: [
                  MenuButton(
                    icon: Icon(Icons.brightness_4_outlined),
                    text: Text('Change theme'),
                    submenu: SubMenu(
                      menuItems: [
                        MenuButton(
                          onTap: null,
                          icon: Icon(Icons.light_mode),
                          text: Text('Light theme'),
                        ),
                        MenuButton(
                          onTap: null,
                          icon: Icon(Icons.dark_mode),
                          text: Text('Dark theme'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              shortcutText: 'Ctrl+Q',
              text: const Text('Close Window'),
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      BarButton(
        text: const Text(
          'Edit',
          style: TextStyle(color: Colors.white),
        ),
        submenu: SubMenu(
          menuItems: [
            MenuButton(
              onTap: () {},
              text: const Text('Undo'),
              shortcutText: 'Ctrl+Z',
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Redo'),
              shortcutText: 'Ctrl+Y',
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('Cut'),
              shortcutText: 'Ctrl+X',
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Copy'),
              shortcutText: 'Ctrl+C',
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Paste'),
              shortcutText: 'Ctrl+V',
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('Find'),
              shortcutText: 'Ctrl+F',
            ),
          ],
        ),
      ),
      BarButton(
        text: const Text(
          'Help',
          style: TextStyle(color: Colors.white),
        ),
        submenu: SubMenu(
          menuItems: [
            MenuButton(
              onTap: () {},
              text: const Text('Check for updates'),
            ),
            // const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('View License'),
            ),
            // const MenuDivider(),
            MenuButton(
              onTap: () {},
              icon: const Icon(Icons.info),
              text: const Text('About'),
            ),
          ],
        ),
      ),
    ];
    return MenuBarWidget(
      enabled: true,
      barButtons: menus,
      barButtonStyle: DesignContants.barButtonStyle,
      barStyle: DesignContants.menuStyle,
      menuButtonStyle: DesignContants.menuButtonStyle,
      child: Scaffold(body: body),
    );
  }
}

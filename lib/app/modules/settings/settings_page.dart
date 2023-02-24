import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends GetView {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("settings_page_settings".tr),actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.info))
      ],),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor
        ),
        sections: [
        SettingsSection(
          title: Text('settings_page_application'.tr),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              leading: const Icon(Icons.cloud_outlined),
              title: Text('settings_page_dark_mode'.tr),
              onToggle: (v) => Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light),
              initialValue: Get.isDarkMode,
            ),
          ]
        )
        ]
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localizeit/app/routes/pages.dart';
import 'package:localizeit/app/core/values/i18n.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setWindowSize(const Size(1000,800));
    DesktopWindow.setMinWindowSize(const Size(1000,800));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LocalizeIt',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      getPages: AppPages.pages,
      initialRoute: '/home',
      locale: const Locale('en', 'US'),
      translations: AppTranslations(),
      debugShowCheckedModeBanner: false,
    );
  }
}



import 'package:get/get.dart';
import 'package:localizeit/app/modules/home/home_binding.dart';
import 'package:localizeit/app/modules/home/home_page.dart';
import 'package:localizeit/app/modules/settings/settings_page.dart';
import 'package:localizeit/app/routes/routes.dart';

abstract class AppPages {

  static final pages = [
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.settings, page: () => SettingsPage())
  ];

}
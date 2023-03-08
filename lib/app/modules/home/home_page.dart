import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'home_controller.dart';

class HomePage extends GetView {
  HomePage({super.key});

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LocalizeIt"),
        /* actions: [
          IconButton(
              onPressed: () {
                Get.toNamed("/settings");
              },
              icon: const Icon(Icons.settings))
        ], */
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => homeController.addNewKey(),
          label: Text("home_page_add_key".tr)),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  DropdownButton(value: "get", onChanged: (v) {}, items: const [
                    DropdownMenuItem(value: "get", child: Text("GetX")),
                   /*  DropdownMenuItem(
                        value: "flutter_i18n", child: Text("Flutter_i18n")),
                    DropdownMenuItem(
                        value: "flutter_easy_localization", child: Text("Easy localization")), */
                  ]),
                  ElevatedButton(
                      onPressed: () => homeController.importProject(context),
                      child: Text("home_page_import".tr)),
                  ElevatedButton(
                      onPressed: () => homeController.export(context),
                      child: Text("home_page_export".tr)),
                 /*  SizedBox(
                    width: 300,
                    child: CheckboxListTile(
                      value: true,
                      onChanged: (v) {},
                      title: Text("home_page_add_export_empty_strings".tr),
                    ),
                  ), */
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () =>
                          homeController.openLanguagePickerDialog(context),
                      child: Text("home_page_add_new_language".tr)),
                  ElevatedButton(
                      onPressed: () => homeController.reset(),
                      child: Text("home_page_reset".tr)),
                ],
              ),
              Expanded(
                child: PlutoGrid(
                  columns: homeController.columns,
                  rows: homeController.rows,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    homeController.stateManager = event.stateManager;
                    homeController.stateManager.setShowColumnFilter(true);
                  },
                  noRowsWidget: _buildPlutoGridNoRowsWidget(),
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  configuration: PlutoGridConfiguration(
                      style: Get.isDarkMode ? const PlutoGridStyleConfig.dark() : const PlutoGridStyleConfig()
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildPlutoGridNoRowsWidget() {
    return Center(child: Column(
      children: [
        const Spacer(),
        Text("home_page_no_rows".tr),
        const Spacer(),
      ],
    ));
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:localizeit/app/services/export/export_service_interface.dart';
import 'package:localizeit/app/services/export/getx/getx_export_service.dart';
import 'package:pluto_grid/pluto_grid.dart';

class HomeController extends GetxController {
  /// PlutoGrid state manager
  ///
  ///
  late final PlutoGridStateManager stateManager;

  /// PlutoGrid columns
  ///
  /// We initialize the grids starting without languages
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      frozen: PlutoColumnFrozen.start,
      title: 'key',
      field: 'key',
      type: PlutoColumnType.text(),
    ),
  ];

  /// PlutoGrid rows
  final List<PlutoRow> rows = [];

  /// Languagaes
  ///
  /// This array handles the selected languages
  List<Language> languages = [];

  /// Export Service
  /// 
  /// 
  IExportService exportService = GetExportService();

  /// Open language picker dialog
  ///
  /// It opens a dialog picker with a list of languages availables.
  /// When the user clicks on a language it will be added to the grid.
  /// 
  /// TODO: We need to improve or replace this method, actually isoCode contains
  ///       only language code without including country, so there is 'en' but not 'en-US'.
  void openLanguagePickerDialog(context) => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: LanguagePickerDialog(
                titlePadding: const EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration:
                    InputDecoration(hintText: 'home_controller_search'.tr),
                isSearchable: true,
                title: Text('home_controller_select_your_language'.tr),
                onValuePicked: (Language language) => addNewLanguage(language),
                itemBuilder: _buildLanguagePickerDialogItem)),
      );

  /// Build language picker dialog item
  ///
  ///
  Widget _buildLanguagePickerDialogItem(Language language) => Row(
        children: <Widget>[
          Text(language.name),
          const SizedBox(width: 8.0),
          Flexible(child: Text("(${language.isoCode})")),
          const SizedBox(width: 8.0),
          if (languages.contains(language))
            Flexible(child: Text("home_controller_added".tr))
        ],
      );

  /// Add new language
  Future<void> addNewLanguage(Language language) async {
    if (languages.contains(language)) {
      Get.snackbar(
      "home_controller_warning".tr,
      "${language.name} is already selected.",
      icon: const Icon(Icons.warning, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(10),
    );
  
      return;
    }

    languages.add(language);

    addNewColumn(language.name, language.isoCode);
  }

  /// Add new key
  Future<void> addNewKey() async {
    stateManager.appendNewRows();
  }

  /// Add new column
  Future<void> addNewColumn(String title, String field,
      {PlutoColumnType? type}) async {
    stateManager.insertColumns(1, [
      PlutoColumn(
          title: title, field: field, type: type ?? PlutoColumnType.text())
    ]);
  }

  /// Import project
  ///
  ///
  Future<void> importProject(context) async {
    String? inputFolder = await FilePicker.platform.getDirectoryPath();

    if (inputFolder == null) {
      return;
    }

    // Show loading
    stateManager.setShowLoading(true);

    List<String> keys = exportService.import(inputFolder);

    loadGrid(keys);

    stateManager.setShowLoading(false);
  }

  /// Export
  ///
  ///
  Future<void> export(context) async {    
    if (languages.isEmpty) {
      Get.snackbar(
        "home_controller_warning".tr,
        "You can't export without translate keys for at least one language",
        icon: const Icon(Icons.warning, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(10),
      );

      return;
    }
    
    String? outputFolder = await FilePicker.platform.getDirectoryPath();

    if (outputFolder == null) {
      return;
    }

    stateManager.setShowLoading(true);

    List<PlutoRow> rows = stateManager.rows;

    bool exportStatus = exportService.export(languages, rows, outputFolder);

    if (!exportStatus) {
      Get.snackbar(
        "home_controller_error".tr,
        "There was a problem exporting the translations...",
        icon: const Icon(Icons.warning, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(10),
      );

      stateManager.setShowLoading(false);

      return;
    }

    stateManager.setShowLoading(false);

    Get.snackbar(
        "home_controller_success".tr,
        "Exporting completed.",
        icon: const Icon(Icons.warning, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(10),
    );
  }

  /// Save file in a given output folder
  ///
  /// TODO: Show an alert if writeAsString gives an exception.
  Future<void> saveFile(Map<String, String> export, String outputFolder) async {
    try {
      export.forEach((key, value) {
        File file = File("$outputFolder/$key");

        file.writeAsString(value);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadGrid(List<String> keys) async {
    List<PlutoColumn> columns = languages
        .map((e) => PlutoColumn(
            title: e.name, field: e.isoCode, type: PlutoColumnType.text()))
        .toList();

    List<PlutoRow> rows = generateRowsByKeys(keys);

    stateManager.insertColumns(1, columns);
    stateManager.appendRows(rows);
  }

  // Generate rows for every key
  List<PlutoRow> generateRowsByKeys(List<String> keys) {
    List<PlutoRow> rows = [];

    for (var element in keys) {
      rows.add(PlutoRow(
        cells: {
          'key': PlutoCell(value: element),
          for (Language language in languages)
            language.isoCode: PlutoCell(value: ""),
        },
      ));
    }

    return rows;
  }

  /// Reset
  Future<void> reset() async {
    languages = [];
    stateManager.removeColumns(stateManager.columns);
    stateManager.removeAllRows();
  }
}

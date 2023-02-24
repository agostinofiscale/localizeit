import 'dart:io';

import 'package:jinja/jinja.dart';
import 'package:language_picker/languages.dart';
import 'package:localizeit/app/services/export/export_service_interface.dart';
import 'package:localizeit/app/services/export/getx/templates/i18n_template.dart';
import 'package:localizeit/app/services/export/getx/templates/language_template.dart';
import 'package:localizeit/app/utils/file.dart';
import 'package:pluto_grid/pluto_grid.dart';

class GetExportService implements IExportService {

  final Environment _environment = Environment(
    loader: MapLoader({
      "i18n_template": i18nTemplate,
      "language_template": languageTemplate
    }
  ));
  
  /// Import
  /// 
  /// TODO: Check for doubles
  @override
  List<String> import(String inputFolder) {
    final directory = Directory(inputFolder);

    List<String> keys = [];

    /// First match contains full strings,
    /// first group contains string inner quotes and the second group contains the end character(s)
    final regex = RegExp(r'''['"](.*?)['"](:|,|\.tr)''');

    directory.listSync().forEach((file) {
      if (file is File && file.path.endsWith('.dart')) {
        final content = file.readAsStringSync();
        final matches = regex.allMatches(content);

        if (matches.isNotEmpty) {
          for (var match in matches) {
            if (match.group(2) == ".tr") {
              keys.add(
                match.group(1)!
              );
            }
          }
        }
      } else if (file is Directory) {
        keys.addAll(
          import(file.path)
        );
      }
    });

    return keys;
  }

  @override
  bool export(
    List<Language> languages,
    List<PlutoRow> rows,
    String outputFolder
  ) {
    var translations = {
      for (Language language in languages) 
      language.isoCode : {}
    };

    for (var row in rows) {
      // Get key
      var key = row.cells["key"]?.value;

      if (key == null) {
        continue;
      }

      for (Language language in languages) {
          translations[language.isoCode]?[key] = row.cells[language.isoCode]?.value;
      }
    }

    try {
      // Generates a files for each languages that contains its translations.
      for (Language language in languages) {
        String languageTemplateContents = _renderLanguageTemplate(
          language.isoCode,
          Map<String, String>.from(translations[language.isoCode]!)
        );

        saveFile("$outputFolder/${language.isoCode}.dart", languageTemplateContents);
      }

      // Generate a file using that extends Translation class to use into
      // GetMaterialApp.
      String i18nTemplateContents = _renderI18nTemplate(
        languages.map((Language language) => language.isoCode).toList()
      );

      saveFile("$outputFolder/i18n.dart", i18nTemplateContents);
    } catch (e) {

      return false;
    }

    return true;
  }

  /// Render a string using i18n_template.dart as template
  String _renderI18nTemplate(
    List<String> isoCodes
  ) {
    return _environment.getTemplate("i18n_template").render(
      {
        "languages": isoCodes
      }
    );
  }

  /// Render a string using i18n_template.dart as template
  String _renderLanguageTemplate(
    String isoCode, 
    Map<String, String> translations
  ) {
    return _environment.getTemplate("language_template").render(
        {
          "isoCode": isoCode,
          "translations": translations
        }
      );
  }
}

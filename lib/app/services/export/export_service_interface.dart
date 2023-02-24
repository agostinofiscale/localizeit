import 'package:language_picker/languages.dart';
import 'package:pluto_grid/pluto_grid.dart';

abstract class IExportService {
  
  ///
  List<String> import(
    String inputFolder
  );

  ///
  bool export(
    List<Language> languages,
    List<PlutoRow> rows,
    String outputFolder
  );

}
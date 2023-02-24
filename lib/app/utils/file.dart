import 'dart:io';

saveFile(path, contents) async {
  File file = File(path);

  file = await file.writeAsString(contents);

  return await file.length();
}
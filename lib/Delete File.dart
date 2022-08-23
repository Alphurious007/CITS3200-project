import 'dart:io';

class Storage {
  Future<String> deleteFile(String filename, String folder) async {
    final file = File('$folder/$filename');
    final content = file.readAsString();
    try {
      if (await file.exists()) {
        await file.delete();
        return content;
      }
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}

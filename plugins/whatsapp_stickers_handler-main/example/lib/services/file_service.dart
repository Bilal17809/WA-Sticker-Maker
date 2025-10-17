import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  ///

  /// Picks images from phone
  static Future<List<String>> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['webp', 'png', 'jpg'],
      allowMultiple: true,
    );

    return result?.paths.nonNulls.toList() ?? [];
  }

  /// Deletes the given files
  static Future<void> deleteFiles(List<String> files) async {
    files.forEach((file) async => await File(file).delete());
  }

  /// Deletes the folder
  static Future<void> deleteFolder(String folder) async {
    String path = await getDirectory(folder);
    await Directory(path).delete(recursive: true);
  }

  /// Returns the folder in the application directory
  static Future<String> getDirectory(String folderName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, folderName);
  }
}

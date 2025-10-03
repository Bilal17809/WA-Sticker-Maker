import 'dart:io';
import 'package:http/http.dart' as http;
import '/core/utils/utils.dart';

class DownloadService {
  final http.Client _http;

  DownloadService({http.Client? client}) : _http = client ?? http.Client();

  Future<File?> downloadToFile(
    String url,
    String outDir,
    String baseName,
  ) async {
    try {
      final resp = await _http.get(Uri.parse(url));
      if (resp.statusCode != 200) return null;
      final ext = ExtensionUtil.extensionFromUrl(url);
      final file = File('$outDir/$baseName$ext')..createSync(recursive: true);
      await file.writeAsBytes(resp.bodyBytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  void dispose() => _http.close();
}

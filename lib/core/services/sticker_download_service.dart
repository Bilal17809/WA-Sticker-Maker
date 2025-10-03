import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class StickerDownloadService {
  final http.Client _client;

  StickerDownloadService({http.Client? client})
    : _client = client ?? http.Client();

  Future<List<String>> downloadStickers({
    required List<dynamic> stickers,
    required String targetDirectory,
  }) async {
    final paths = <String>[];

    for (final sticker in stickers) {
      try {
        final response = await _client.get(
          Uri.parse(sticker.imageUrl as String),
        );
        if (response.statusCode != 200) continue;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = _getExtension(sticker.imageUrl as String);
        final fileName = 'sticker_${timestamp}_${sticker.id}$ext';
        final filePath = '$targetDirectory/$fileName';
        await File(filePath).writeAsBytes(response.bodyBytes);
        paths.add(filePath);
      } catch (_) {
        continue;
      }
    }
    return paths;
  }

  String _getExtension(String url) {
    final parts = url.split('.');
    return parts.isEmpty ? '.png' : '.${parts.last.split('?').first}';
  }

  void dispose() => _client.close();
}

import 'dart:io';
import 'services.dart';

class StickerDownloadService {
  final DownloadService _downloader;
  final StickerConversionService _converter;

  StickerDownloadService({
    DownloadService? downloader,
    StickerConversionService? converter,
  }) : _downloader = downloader ?? DownloadService(),
       _converter = converter ?? StickerConversionService();

  Future<List<String>> downloadStickers({
    required List<dynamic> stickers,
    required String targetDirectory,
    bool convertToWebP = true,
  }) async {
    final dir = Directory(targetDirectory);
    if (!await dir.exists()) await dir.create(recursive: true);
    final paths = <String>[];
    for (final s in stickers) {
      try {
        final ts = DateTime.now().millisecondsSinceEpoch;
        final base = 'sticker_${ts}_${s.id}';
        final file = await _downloader.downloadToFile(
          s.imageUrl as String,
          targetDirectory,
          base,
        );
        if (file == null) continue;
        if (convertToWebP) {
          final out = '$targetDirectory/$base.webp';
          final converted = await _converter.convertFileToWebP512(file, out);
          if (converted != null) {
            if (_converter.removeOriginal) {
              try {
                await file.delete();
              } catch (_) {}
            }
            paths.add(converted);
          } else {
            paths.add(file.path);
          }
        } else {
          paths.add(file.path);
        }
      } catch (_) {}
    }
    return paths;
  }

  void dispose() {
    _downloader.dispose();
  }
}

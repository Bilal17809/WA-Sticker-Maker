import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '/core/utils/utils.dart';

class StickerConversionService {
  final int maxWebPSize;
  final List<int> qualities;
  final bool removeOriginal;

  StickerConversionService({
    this.maxWebPSize = 100 * 1024,
    this.qualities = const [75, 50, 30],
    this.removeOriginal = true,
  });

  Future<String?> convertFileToWebP512(File input, String outPath) async {
    if (!await input.exists()) return null;
    try {
      final bytes = await input.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;
      final resized512 = _resizeAndPadTo512(image);
      final tempPngPath = '${outPath}_temp.png';
      final pngBytes = img.encodePng(resized512, level: 0);
      await File(tempPngPath).writeAsBytes(pngBytes);
      for (final quality in qualities) {
        final result = await FlutterImageCompress.compressAndGetFile(
          tempPngPath,
          outPath,
          format: CompressFormat.webp,
          quality: quality,
        );
        if (result != null) {
          final file = File(result.path);
          final size = await file.length();
          if (size <= maxWebPSize) {
            try {
              await File(tempPngPath).delete();
            } catch (_) {}
            if (result.path != outPath) {
              await file.copy(outPath);
              await file.delete();
            }
            if (removeOriginal) {
              try {
                await File(tempPngPath).delete();
              } catch (_) {}
            }
            return outPath;
          } else {
            try {
              await file.delete();
            } catch (_) {}
          }
        }
      }
      try {
        await File(tempPngPath).delete();
      } catch (_) {}
      return null;
    } catch (_) {
      try {
        if (await File(outPath).exists()) await File(outPath).delete();
      } catch (_) {}
      try {
        final tmp = File('${outPath}_temp.png');
        if (await tmp.exists()) await tmp.delete();
      } catch (_) {}
      return null;
    }
  }

  Future<List<String>> convertBase64ToWebp(
    List<String> base64Images,
    String targetDirectory,
  ) async {
    final dir = Directory(targetDirectory);
    if (!await dir.exists()) await dir.create(recursive: true);
    final paths = <String>[];
    for (var i = 0; i < base64Images.length; i++) {
      try {
        final bytes = Base64Utils.maybeDecode(base64Images[i]);
        if (bytes == null) continue;
        final ts = DateTime.now().millisecondsSinceEpoch;
        final tempPath = '$targetDirectory/temp_$ts$i.png';
        final tempFile = File(tempPath)..createSync(recursive: true);
        await tempFile.writeAsBytes(bytes);
        final outPath = '$targetDirectory/ai_sticker_$ts$i.webp';
        final converted = await convertFileToWebP512(tempFile, outPath);
        if (converted != null) {
          try {
            await tempFile.delete();
          } catch (_) {}
          paths.add(converted);
        } else {
          paths.add(tempPath);
        }
      } catch (_) {}
    }
    return paths;
  }

  img.Image _resizeAndPadTo512(img.Image original) {
    const targetSize = 512;
    int newWidth, newHeight;
    if (original.width > original.height) {
      newWidth = targetSize;
      newHeight = (targetSize * original.height / original.width).round();
    } else {
      newHeight = targetSize;
      newWidth = (targetSize * original.width / original.height).round();
    }
    if (newWidth > targetSize) newWidth = targetSize;
    if (newHeight > targetSize) newHeight = targetSize;
    final resized = img.copyResize(
      original,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.cubic,
    );
    final canvas = img.Image(
      width: targetSize,
      height: targetSize,
      numChannels: 4,
    );
    img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));
    final x = (targetSize - newWidth) ~/ 2;
    final y = (targetSize - newHeight) ~/ 2;
    img.compositeImage(canvas, resized, dstX: x, dstY: y);
    return canvas;
  }
}

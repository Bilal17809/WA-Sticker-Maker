import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

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
    final filter =
        'scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2:color=0x00000000';
    for (final q in qualities) {
      final cmd =
          '-i "${input.path}" -vf "$filter" -vcodec libwebp -quality $q -y "$outPath"';
      final session = await FFmpegKit.execute(cmd);
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        final f = File(outPath);
        if (await f.exists() && await f.length() <= maxWebPSize) return outPath;
      }
    }
    final fallback =
        '-i "${input.path}" -vf "$filter" -vcodec libwebp -lossless 0 -q:v 50 -y "$outPath"';
    final session2 = await FFmpegKit.execute(fallback);
    final returnCode2 = await session2.getReturnCode();
    if (ReturnCode.isSuccess(returnCode2)) {
      final f = File(outPath);
      if (await f.exists() && await f.length() <= maxWebPSize) return outPath;
    }
    try {
      final p = File(outPath);
      if (await p.exists()) await p.delete();
    } catch (_) {}
    return null;
  }
}

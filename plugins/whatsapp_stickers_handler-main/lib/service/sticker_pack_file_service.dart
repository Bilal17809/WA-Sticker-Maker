import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';

class StickerPackFileService {
  ///

  /// Converts [bytes] to [format]
  Future<Uint8List> convertImageTo(
    Uint8List bytes,
    CompressFormat format,
  ) async {
    return await FlutterImageCompress.compressWithList(bytes, format: format);
  }

  /// Creates file at [path] and saves [bytes] to it
  Future<String> saveBytesToFile(Uint8List bytes, String path) async {
    File file = File(path)..createSync(recursive: true);
    return (await file.writeAsBytes(bytes)).path;
  }

  /// Compresses and returns [bytes] with [format] to be smaller than [maxBytes]
  ///
  /// Incrementally reduces quality by 5% until smaller than [maxBytes]
  Future<Uint8List> compressFileTo(
    Uint8List bytes,
    int maxBytes,
    CompressFormat format,
  ) async {
    Uint8List compressed;
    int quality = 105;

    // Reduces the quality until the file is compressed enough
    do {
      compressed = await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality -= 5,
        format: format,
      );
    } while (compressed.lengthInBytes > maxBytes);

    return compressed;
  }

  /// Resizes image at [imagePath] to a height and width of [size]
  ///
  /// The aspect ratio is maintained filling the remaining pace transparently
  Future<Image?> scaleImageToSquare(String imagePath, int size) async {
    Image? image = (await decodeImageFile(imagePath));
    if (image == null) return null;

    // Scales image down to max [size] while maintaining aspect ratio
    bool isPortrait = image.width < image.height;
    image = copyResize(
      image,
      height: isPortrait ? size : null,
      width: isPortrait ? null : size,
    );

    // Creates a blank canvas with width and height of size
    // Puts image on top of canvas
    Image blankCanvas = Image(height: size, width: size, numChannels: 4);
    return compositeImage(blankCanvas, image, center: true);
  }

  /// Returns if file at [webpPath] is animated
  bool isWebpAnimated(String webpPath) {
    Uint8List bytes = File(webpPath).readAsBytesSync();

    for (int i = 12; i < bytes.length - 8; i++) {
      final chunkType = String.fromCharCodes(bytes.sublist(i + 4, i + 8));
      if (chunkType == 'ANIM') {
        return true;
      }
    }
    return false;
  }
}

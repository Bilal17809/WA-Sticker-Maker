import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack_exception.dart';
import 'package:whatsapp_stickers_handler/service/sticker_pack_file_service.dart';

class StickerPackUtil {
  ///

  StickerPackFileService _fileService = StickerPackFileService();

  /// Creates valid stickers from images at [imagePaths]
  ///
  /// Saves stickers in [directory] and names files with [namingFunction]
  /// Resizes and compresses image if necessary
  Future<List<String>> createStickersFromImages(
    List<String> imagePaths,
    String directory, [
    String Function(String)? namingFunction,
    Function(StickerPackException)? handleException,
  ]) async {
    String Function(String) createName = namingFunction ?? (name) => name;

    List<String> stickers = [];
    for (String image in imagePaths) {
      try {
        String fileName = join(directory, createName(basename(image)));
        stickers.add(await createStickerFromImage(image, fileName));
      } on StickerPackException catch (e) {
        if (handleException != null) handleException(e);
      }
    }

    return stickers;
  }

  /// Creates valid sticker from image at [imagePath] and saves it to
  /// [stickerPath]
  ///
  /// Resizes and compresses image if necessary
  Future<String> createStickerFromImage(
    String imagePath,
    String stickerPath,
  ) async {
    if (!stickerPath.endsWith('.webp')) stickerPath += '.webp';

    _validateImage(imagePath);

    // If is animated webp: validate and return without sizing/compressing
    if (isStickerAnimated(imagePath)) {
      return await _handleAnimatedSticker(imagePath, stickerPath);
    }

    // Resize to 512x512
    Image? scaledImage = await _fileService.scaleImageToSquare(imagePath, 512);

    // Compress to max 95KB
    Uint8List bytes = await _fileService.compressFileTo(
      encodePng(scaledImage!),
      95000,
      CompressFormat.webp,
    );

    return await _fileService.saveBytesToFile(bytes, stickerPath);
  }

  /// Converts the webp at [webpPath] to tray image png
  ///
  /// Saves it in same folder
  Future<String> saveWebpAsTrayImage(String webpPath) async {
    Uint8List bytes = File(webpPath).readAsBytesSync();
    // Compress to jpg because png does not compress
    Uint8List pngBytes = await _fileService.compressFileTo(
      bytes,
      45000,
      CompressFormat.jpeg,
    );
    String pngPath = '${withoutExtension(webpPath)}.png';
    return await _fileService.saveBytesToFile(pngBytes, pngPath);
  }

  /// Returns if the sticker at [stickerPath] is animated
  bool isStickerAnimated(String stickerPath) {
    return extension(stickerPath).toLowerCase() == '.webp' &&
        _fileService.isWebpAnimated(stickerPath);
  }

  /// Validates animated sticker at [imagePath] and returns it if valid
  Future<String> _handleAnimatedSticker(
    String imagePath,
    String stickerPath,
  ) async {
    _validateAnimatedSticker(imagePath);

    Uint8List bytes = File(imagePath).readAsBytesSync();
    return await _fileService.saveBytesToFile(bytes, stickerPath);
  }

  /// Validates if a sticker can be created from the image at [imagePath]
  void _validateImage(String imagePath) {
    // Validate extension
    String ext = extension(imagePath).toLowerCase();
    if (!['.webp', '.png', '.jpg', '.jpeg'].contains(ext)) {
      throw StickerPackException(
        'Converting image to sticker is not possible for extension $ext',
      );
    }

    // Check if file exists
    if (!File(imagePath).existsSync()) {
      throw StickerPackException(
        'File: "${basename(imagePath)}" does not exist',
      );
    }
  }

  /// Validates if a sticker can be created from the animated webp at
  /// [imagePath]
  void _validateAnimatedSticker(String imagePath) {
    // Check if sticker is smaller than 500KBs
    Uint8List bytes = File(imagePath).readAsBytesSync();
    if (bytes.lengthInBytes > 500000) {
      throw StickerPackException(
        'Animated sticker cannot be larger than 500KB: ${basename(imagePath)}',
      );
    }

    // Check if file is 512x512
    Image image = decodeWebP(bytes)!;
    if (image.width != 512 || image.height != 512) {
      throw StickerPackException(
        'Sticker is not 512x512 pixels: ${basename(imagePath)}',
      );
    }
  }
}

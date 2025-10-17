import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack_exception.dart';
import 'package:whatsapp_stickers_handler/service/sticker_pack_util.dart';
import 'package:whatsapp_stickers_handler/validation/validators.dart';

class StickerPackValidator {
  ///

  static StickerPackUtil _stickerPackUtil = StickerPackUtil();

  /// Validates [stickerPack]
  static void validateStickerPack(StickerPack stickerPack) {
    Validators.illegalCharacters('Identifier', stickerPack.identifier);
    Validators.stringLength('Identifier', stickerPack.identifier);
    Validators.stringLength('Name', stickerPack.name);
    Validators.stringLength('Publisher', stickerPack.publisher);

    _validateTrayImage(stickerPack.trayImage);

    _validateStickers(stickerPack.stickers);
  }

  /// Validates [trayImage]
  static void _validateTrayImage(String? trayImage) {
    if (trayImage == null) {
      _throwException('Tray image is required');
      return;
    }

    // Check if file exists
    File trayFile = File(trayImage);
    if (!trayFile.existsSync()) {
      _throwException('Tray image file not available', trayImage);
    }

    // Check if file is png
    if (extension(trayImage).toLowerCase() != '.png') {
      _throwException('Tray image is not a png', trayImage);
    }

    // Check if tray image is smaller than 50KB
    Uint8List bytes = trayFile.readAsBytesSync();
    if (bytes.lengthInBytes > 50000) {
      _throwException('Tray image cannot be larger than 50KB', trayImage);
    }
  }

  /// Validates [stickers]
  static void _validateStickers(List<String> stickers) {
    if (stickers.length < 3) {
      _throwException('A sticker pack must contain at least 3 stickers');
    }

    if (stickers.length > 30) {
      _throwException('A sticker pack can only contain up to 30 stickers');
    }

    stickers.forEach(_validateSticker);
  }

  /// Validates [sticker]
  static void _validateSticker(String sticker) {
    // Check if file exists
    File stickerFile = File(sticker);
    if (!stickerFile.existsSync()) {
      _throwException('Sticker file not available', sticker);
    }

    // Check if file is webp
    if (extension(sticker).toLowerCase() != '.webp') {
      _throwException('Sticker is not a webp', sticker);
    }

    // Check if file is 512x512
    Uint8List bytes = stickerFile.readAsBytesSync();
    Image image = decodeWebP(bytes)!;
    if (image.width != 512 || image.height != 512) {
      _throwException('Sticker is not 512x512 pixels', sticker);
    }

    // Check if sticker is animated and then smaller than 500KB
    bool isAnimated = _stickerPackUtil.isStickerAnimated(sticker);
    if (isAnimated && bytes.lengthInBytes > 500000) {
      _throwException('Animated sticker cannot be larger than 500KB', sticker);
    }

    // Check if sticker is not animated and then smaller than 100KB
    if (!isAnimated && bytes.lengthInBytes > 100000) {
      _throwException('Sticker cannot be larger than 100KB', sticker);
    }
  }

  /// Throws [StickerPackException] with [message] and basename of [file]
  static void _throwException(String message, [String? file]) {
    String details = file == null ? message : '$message: ${basename(file)}';
    throw StickerPackException(details);
  }
}

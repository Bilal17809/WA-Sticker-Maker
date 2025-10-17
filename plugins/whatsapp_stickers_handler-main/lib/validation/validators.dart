import 'package:whatsapp_stickers_handler/model/sticker_pack_exception.dart';

class Validators {
  static RegExp _legalCharacters = RegExp(r'^[a-zA-Z0-9_-]+$');

  /// Throws a [StickerPackException] when the [string] exceeds 128 characters
  static void stringLength(String name, String string) {
    if (string.length > 128) {
      throw StickerPackException('$name can only be up to 128 characters');
    }
  }

  /// Throws a [StickerPackException] when the [string] contains illegal
  /// characters
  static void illegalCharacters(String name, String string) {
    if (!_legalCharacters.hasMatch(string)) {
      throw StickerPackException(
        '$name can only contain alphanumeric characters and "_" and "-"',
      );
    }
  }
}

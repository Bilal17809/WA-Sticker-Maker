import 'package:flutter/services.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack_exception.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:whatsapp_stickers_handler_example/util/util.dart';

class WhatsAppService {
  ///

  static WhatsappStickersHandler whatsappStickersHandler =
      WhatsappStickersHandler();

  static Future<bool> get isWhatsAppInstalled async {
    bool? result = await doAndCatch(() async {
      return await whatsappStickersHandler.isWhatsAppInstalled;
    });
    return result ?? false;
  }

  static void launchWhatsApp() {
    doAndCatch(() async {
      whatsappStickersHandler.launchWhatsApp();
    });
  }

  static Future<bool> isStickerPackInstalled(String identifier) async {
    bool? result = await doAndCatch(() async {
      return await whatsappStickersHandler.isStickerPackInstalled(identifier);
    });
    return result ?? false;
  }

  static Future<void> addStickerPack(StickerPack stickerPack) async {
    await doAndCatch(() async {
      await whatsappStickersHandler.addStickerPack(stickerPack);
    });
  }

  static Future<void> updateStickerPack(StickerPack stickerPack) async {
    await doAndCatch(() async {
      await whatsappStickersHandler.updateStickerPack(stickerPack);
    });
  }

  static Future<void> deleteStickerPack(String identifier) async {
    await doAndCatch(() async {
      await whatsappStickersHandler.deleteStickerPack(identifier);
    });
  }

  /// Calls [dewit], returns value and handles Exceptions
  static Future<T?> doAndCatch<T>(Future<T> Function() dewit) async {
    try {
      return await dewit();
    } on StickerPackException catch (e) {
      Util.showSnackBar(e.message);
    } on PlatformException catch (e) {
      Util.showSnackBar(e.message ?? 'An unexpected error occurred');
    }
    return null;
  }
}

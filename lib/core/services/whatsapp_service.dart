import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

class WhatsAppService {
  static final WhatsappStickersHandler whatsappStickersHandler =
      WhatsappStickersHandler();

  static Future<bool> get isWhatsAppInstalled async {
    return await whatsappStickersHandler.isWhatsAppInstalled;
  }

  static Future<bool> isStickerPackInstalled(String identifier) async {
    return await whatsappStickersHandler.isStickerPackInstalled(identifier);
  }

  static Future<void> addStickerPack(StickerPack stickerPack) async {
    await whatsappStickersHandler.addStickerPack(stickerPack);
  }

  static Future<void> updateStickerPack(StickerPack stickerPack) async {
    await whatsappStickersHandler.updateStickerPack(stickerPack);
  }
}

import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

class WhatsAppService {
  static WhatsappStickersHandler whatsappStickersHandler =
      WhatsappStickersHandler();

  /// Returns if WhatsApp is installed
  static Future<bool> get isWhatsAppInstalled async {
    return await whatsappStickersHandler.isWhatsAppInstalled;
  }

  /// Launches WhatsApp
  static void launchWhatsApp() {
    whatsappStickersHandler.launchWhatsApp();
  }

  /// Checks if a sticker pack with the given [identifier] is available in
  /// WhatsApp
  static Future<bool> isStickerPackInstalled(String identifier) async {
    return await whatsappStickersHandler.isStickerPackInstalled(identifier);
  }

  /// Adds [stickerPack] to the sticker pack list that is exposed to WhatsApp
  /// and sends request to add the pack to Whatsapp
  static Future<void> addStickerPack(StickerPack stickerPack) async {
    await whatsappStickersHandler.addStickerPack(stickerPack);
  }

  /// Updates [stickerPack] in the sticker pack list that is exposed to WhatsApp
  static Future<void> updateStickerPack(StickerPack stickerPack) async {
    await whatsappStickersHandler.updateStickerPack(stickerPack);
  }

  /// Deletes sticker pack from the sticker pack list that is exposed to WhatsApp
  /// The sticker pack still needs to be deleted manually in the WhatsApp UI
  static Future<void> deleteStickerPack(String identifier) async {
    await whatsappStickersHandler.deleteStickerPack(identifier);
  }
}

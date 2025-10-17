import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/validation/sticker_pack_validator.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler_platform_interface.dart';

class WhatsappStickersHandler {
  /// Returns if WhatsApp is installed
  Future<bool> get isWhatsAppInstalled async {
    return await WhatsappStickersHandlerPlatform.instance.isWhatsAppInstalled;
  }

  /// Launches WhatsApp
  void launchWhatsApp() async {
    WhatsappStickersHandlerPlatform.instance.launchWhatsApp();
  }

  /// Checks if a [StickerPack] with the given [identifier] is available in
  /// WhatsApp
  Future<bool> isStickerPackInstalled(String identifier) async {
    return await WhatsappStickersHandlerPlatform.instance
        .isStickerPackInstalled(identifier);
  }

  /// Adds [stickerPack] to Whatsapp
  ///
  /// Saves [stickerPack] to the sticker pack list that is exposed via the
  /// ContentProvider
  /// Does not save the actual sticker files anywhere
  /// Also sends request to add the pack to Whatsapp
  Future<void> addStickerPack(StickerPack stickerPack) async {
    StickerPackValidator.validateStickerPack(stickerPack);
    await WhatsappStickersHandlerPlatform.instance.addStickerPack(stickerPack);
  }

  /// Updates [stickerPack] in Whatsapp
  ///
  /// Updates [stickerPack] in the sticker pack list that is exposed via the
  /// ContentProvider
  Future<void> updateStickerPack(StickerPack stickerPack) async {
    StickerPackValidator.validateStickerPack(stickerPack);
    await WhatsappStickersHandlerPlatform.instance.updateStickerPack(
      stickerPack,
    );
  }

  /// Deletes [StickerPack] with [identifier] from the storage
  ///
  /// Deletes StickerPack from the sticker pack list that is exposed via the
  /// ContentProvider
  /// The [StickerPack] still needs to be deleted manually in the WhatsApp UI
  Future<void> deleteStickerPack(String identifier) async {
    await WhatsappStickersHandlerPlatform.instance.deleteStickerPack(
      identifier,
    );
  }
}

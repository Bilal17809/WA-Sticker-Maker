import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler_method_channel.dart';

abstract class WhatsappStickersHandlerPlatform extends PlatformInterface {
  /// Constructs a WhatsappStickersHandlerPlatform.
  WhatsappStickersHandlerPlatform() : super(token: _token);

  static final Object _token = Object();

  static WhatsappStickersHandlerPlatform _instance =
      MethodChannelWhatsappStickersHandler();

  /// The default instance of [WhatsappStickersHandlerPlatform] to use.
  ///
  /// Defaults to [MethodChannelWhatsappStickersHandler].
  static WhatsappStickersHandlerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WhatsappStickersHandlerPlatform] when
  /// they register themselves.
  static set instance(WhatsappStickersHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns if WhatsApp is installed
  Future<bool> get isWhatsAppInstalled async {
    throw UnimplementedError('isWhatsAppInstalled has not been implemented.');
  }

  /// Launches WhatsApp
  void launchWhatsApp() async {
    throw UnimplementedError('launchWhatsApp() has not been implemented.');
  }

  /// Checks if a [StickerPack] with the given [identifier] is available in
  /// WhatsApp
  Future<bool> isStickerPackInstalled(String identifier) async {
    throw UnimplementedError(
      'isStickerPackInstalled() has not been implemented.',
    );
  }

  /// Adds [stickerPack] to Whatsapp
  ///
  /// Saves [stickerPack] to the sticker pack list that is exposed via the
  /// ContentProvider
  /// Does not save the actual sticker files anywhere
  /// Also sends request to add the pack to Whatsapp
  Future<void> addStickerPack(StickerPack stickerPack) async {
    throw UnimplementedError('addStickerPack() has not been implemented.');
  }

  /// Updates [stickerPack] in Whatsapp
  ///
  /// Updates [stickerPack] in the sticker pack list that is exposed via the
  /// ContentProvider
  Future<void> updateStickerPack(StickerPack stickerPack) async {
    throw UnimplementedError('updateStickerPack() has not been implemented.');
  }

  /// Deletes [StickerPack] with [identifier] from the storage
  ///
  /// Deletes StickerPack from the sticker pack list that is exposed via the
  /// ContentProvider
  /// The [StickerPack] still needs to be deleted manually in the WhatsApp UI
  Future<void> deleteStickerPack(String identifier) async {
    throw UnimplementedError('deleteStickerPack() has not been implemented.');
  }
}

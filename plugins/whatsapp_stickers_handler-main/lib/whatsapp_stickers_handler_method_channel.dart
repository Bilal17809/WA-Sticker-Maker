// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler_platform_interface.dart';

/// An implementation of [WhatsappStickersHandlerPlatform] that uses method channels.
class MethodChannelWhatsappStickersHandler
    extends WhatsappStickersHandlerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('whatsapp_stickers_handler');

  /// Returns if WhatsApp is installed
  @override
  Future<bool> get isWhatsAppInstalled async {
    return await methodChannel.invokeMethod<bool>('isWhatsAppInstalled') ??
        false;
  }

  /// Launches WhatsApp
  @override
  void launchWhatsApp() async {
    await methodChannel.invokeMethod('launchWhatsApp');
  }

  /// Checks if a [StickerPack] with the given [identifier] is available in
  /// WhatsApp
  @override
  Future<bool> isStickerPackInstalled(String identifier) async {
    final bool? isInstalled = await methodChannel.invokeMethod<bool>(
      'isStickerPackAdded',
      {'identifier': identifier},
    );
    return isInstalled ?? false;
  }

  /// Adds [stickerPack] to Whatsapp
  ///
  /// Saves [stickerPack] to the sticker pack list that is exposed via the
  /// ContentProvider
  /// Does not save the actual sticker files anywhere
  /// Also sends request to add the pack to Whatsapp
  @override
  Future<void> addStickerPack(StickerPack stickerPack) async {
    return await methodChannel.invokeMethod('addStickerPack', stickerPack.json);
  }

  /// Updates [stickerPack] in Whatsapp
  ///
  /// Updates [stickerPack] in the sticker pack list that is exposed via the
  /// ContentProvider
  @override
  Future<void> updateStickerPack(StickerPack stickerPack) async {
    return await methodChannel.invokeMethod(
      'updateStickerPack',
      stickerPack.json,
    );
  }

  /// Deletes [StickerPack] with [identifier] from the storage
  ///
  /// Deletes StickerPack from the sticker pack list that is exposed via the
  /// ContentProvider
  /// The [StickerPack] still needs to be deleted manually in the WhatsApp UI
  @override
  Future<void> deleteStickerPack(String identifier) async {
    return await methodChannel.invokeMethod('deleteStickerPack', {
      'identifier': identifier,
    });
  }
}

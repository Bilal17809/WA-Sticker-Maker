import 'package:nanoid/nanoid.dart';
import 'package:path/path.dart';
import 'package:ulid/ulid.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/service/sticker_pack_file_service.dart';
import 'package:whatsapp_stickers_handler/service/sticker_pack_util.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';
import 'package:whatsapp_stickers_handler_example/services/file_service.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_storage_service.dart';
import 'package:whatsapp_stickers_handler_example/services/whatsapp_service.dart';
import 'package:whatsapp_stickers_handler_example/util/util.dart';

class StickerService {
  ///

  static StickerPackUtil _stickerPackUtil = StickerPackUtil();
  static StickerPackFileService _stickerPackFileService =
      StickerPackFileService();

  /// Returns all sticker packs
  static Future<List<StickerPack>> getAllStickerPacks() async {
    return await StickerStorageService.getAllStickerPacks();
  }

  /// Creates and adds a sticker pack with the given name
  static Future<StickerPack> createStickerPack(
    StickerPackProvider prov,
    String name,
  ) async {
    StickerPack stickerPack = StickerPack(
      identifier: nanoid(8),
      name: name,
      publisher: 'publisher',
    );
    await StickerStorageService.addStickerPack(stickerPack);
    prov.addStickerPack(stickerPack);
    return stickerPack;
  }

  /// Deletes the sticker pack with the given identifier
  static Future<void> deleteStickerPack(
    StickerPackProvider prov,
    String identifier,
  ) async {
    await StickerStorageService.deleteStickerPack(identifier);
    prov.deleteStickerPack(identifier);
    await FileService.deleteFolder(identifier);
    await WhatsAppService.deleteStickerPack(identifier);
  }

  /// Adds stickers to sticker pack
  /// Saves stickers to application directory
  static Future<void> addStickersToStickerPack(
    StickerPackProvider prov,
    StickerPack stickerPack,
    List<String> stickers,
  ) async {
    // Gets all sticker of correct animation type
    List<String> allowedStickers = _getStickersWithRightAnimationType(
      stickerPack,
      stickers,
    );

    // Saves stickers in directory
    List<String> stickerFiles = await _stickerPackUtil.createStickersFromImages(
      allowedStickers,
      await FileService.getDirectory(stickerPack.identifier),
      (_) => Ulid().toString(),
      (error) => Util.showSnackBar(error.message),
    );
    if (stickerFiles.isEmpty) return;

    // Update stickers and animationType in sticker pack
    await _addSavedFilesToStickerPack(
      prov,
      stickerPack,
      stickerFiles,
      stickerPack.stickers.isEmpty
          ? _stickerPackFileService.isWebpAnimated(stickerFiles.first)
          : stickerPack.animatedStickerPack,
    );
  }

  /// Deletes stickers from sticker pack
  static Future<void> deleteStickersFromStickerPack(
    StickerPackProvider prov,
    StickerPack stickerPack,
    List<String> stickers,
  ) async {
    stickers.forEach((sticker) => stickerPack.stickers.remove(sticker));
    await StickerService._updateStickerPack(prov, stickerPack);
    await FileService.deleteFiles(stickers);
  }

  /// Update the StickerPack metadata
  static Future<void> updateMetadata(
    StickerPackProvider prov,
    StickerPack stickerPack,
  ) async {
    await StickerService._updateStickerPack(prov, stickerPack);
  }

  /// Converts sticker to png and sets it as tray image
  static Future<void> setStickerAsTrayImage(
    StickerPackProvider prov,
    StickerPack stickerPack,
    String sticker,
  ) async {
    // Skip if old and new image are the same
    String? oldTrayImage = stickerPack.trayImage;
    if (oldTrayImage?.contains(basenameWithoutExtension(sticker)) == true) {
      return;
    }

    String trayPng = await _stickerPackUtil.saveWebpAsTrayImage(sticker);
    stickerPack.trayImage = trayPng;
    await StickerService._updateStickerPack(prov, stickerPack);

    // Delete old tray image
    if (oldTrayImage != null) {
      await FileService.deleteFiles([oldTrayImage]);
    }
  }

  /// Updates the sticker pack
  static Future<void> _updateStickerPack(
    StickerPackProvider prov,
    StickerPack stickerPack,
  ) async {
    await StickerStorageService.updateStickerPack(stickerPack);
    prov.updateStickerPack(stickerPack);

    if (await WhatsAppService.isStickerPackInstalled(stickerPack.identifier)) {
      await WhatsAppService.updateStickerPack(stickerPack);
    }
  }

  /// Saves stickers to sticker pack and updates everything
  static Future<void> _addSavedFilesToStickerPack(
    StickerPackProvider prov,
    StickerPack stickerPack,
    List<String> savedFiles, [
    bool? newAnimatedStickerPack,
  ]) async {
    stickerPack.stickers.addAll(savedFiles);
    if (newAnimatedStickerPack != null) {
      stickerPack.animatedStickerPack = newAnimatedStickerPack;
    }
    await StickerService._updateStickerPack(prov, stickerPack);

    if (stickerPack.trayImage == null) {
      await setStickerAsTrayImage(prov, stickerPack, savedFiles.first);
    }
  }

  /// Returns the stickers that are of the same animation type as the pack
  /// Shows snack bar when stickers contain some of wrong animation type
  static List<String> _getStickersWithRightAnimationType(
    StickerPack stickerPack,
    List<String> stickers,
  ) {
    List<String> animated =
        stickers.where(_stickerPackUtil.isStickerAnimated).toList();

    List<String> notAnimated =
        stickers
            .where((sticker) => !_stickerPackUtil.isStickerAnimated(sticker))
            .toList();
    bool isEmpty = stickerPack.stickers.isEmpty;

    if (isEmpty && animated.isNotEmpty && notAnimated.isNotEmpty ||
        !isEmpty && stickerPack.animatedStickerPack && notAnimated.isNotEmpty ||
        !isEmpty && !stickerPack.animatedStickerPack && animated.isNotEmpty) {
      Util.showSnackBar(
        'Some stickers are of the wrong animation type and are not added',
      );
    }

    if (isEmpty) {
      return notAnimated.isNotEmpty ? notAnimated : animated;
    }
    return stickerPack.animatedStickerPack ? animated : notAnimated;
  }
}

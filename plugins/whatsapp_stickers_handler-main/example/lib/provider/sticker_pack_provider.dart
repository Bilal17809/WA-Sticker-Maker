import 'package:flutter/cupertino.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';

class StickerPackProvider extends ChangeNotifier {
  ///

  static List<StickerPack> stickerPacks = [];

  /// Gets stored values from prefs
  Future<void> initialize(List<StickerPack> initialStickerPacks) async {
    stickerPacks = initialStickerPacks;
    notifyListeners();
  }

  /// Adds sticker pack order
  void addStickerPack(StickerPack stickerPack) {
    stickerPacks.add(stickerPack);
    notifyListeners();
  }

  /// Updates sticker packs
  void updateStickerPack(StickerPack newStickerPack) {
    int index = stickerPacks.indexWhere(
      (stickerPack) => stickerPack.identifier == newStickerPack.identifier,
    );
    stickerPacks[index] = newStickerPack;

    notifyListeners();
  }

  /// Deletes sticker packs
  void deleteStickerPack(String identifier) {
    stickerPacks.removeWhere(
      (stickerPack) => stickerPack.identifier == identifier,
    );

    notifyListeners();
  }
}

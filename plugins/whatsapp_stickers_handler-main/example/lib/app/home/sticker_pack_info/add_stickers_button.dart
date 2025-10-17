import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';
import 'package:whatsapp_stickers_handler_example/services/file_service.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_service.dart';

class AddStickersButton extends StatelessWidget {
  ///

  AddStickersButton(this.stickerPack);

  final StickerPack stickerPack;

  /// Adds stickers from user
  void addStickers(StickerPackProvider prov) async {
    List<String> images = await FileService.pickImages();
    if (images.isEmpty) return;

    await StickerService.addStickersToStickerPack(prov, stickerPack, images);
  }

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    StickerPackProvider prov = context.watch<StickerPackProvider>();

    return FloatingActionButton(
      onPressed: () => addStickers(prov),
      child: Icon(Icons.add),
    );
  }
}

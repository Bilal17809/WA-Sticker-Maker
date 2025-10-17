import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/widgets/dialogs.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_service.dart';

class StickerPackMetadata extends StatefulWidget {
  ///

  StickerPackMetadata(this.stickerPack, this.prov);

  final StickerPack stickerPack;
  final StickerPackProvider prov;

  @override
  State<StickerPackMetadata> createState() => _StickerPackMetadataState();
}

class _StickerPackMetadataState extends State<StickerPackMetadata> {
  ///

  late StickerPack stickerPack = widget.stickerPack;

  /// Sets tray image
  void setTrayImage() {
    if (stickerPack.stickers.length <= 1) return;

    Dialogs.selectSticker(
      context: context,
      title: 'Select Tray Sticker',
      stickers: stickerPack.stickers,
      onTap:
          (sticker) => StickerService.setStickerAsTrayImage(
            widget.prov,
            stickerPack,
            sticker,
          ),
    );
  }

  /// Renames sticker pack
  void renameStickerPack() {
    Dialogs.textField(
      context: context,
      title: 'Sticker Pack Name',
      value: stickerPack.name,
      onSubmit: (name) async {
        stickerPack.name = name;
        await StickerService.updateMetadata(widget.prov, stickerPack);
      },
    );
  }

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// Tray image
      leading: GestureDetector(
        onTap: setTrayImage,
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage:
              stickerPack.trayImage == null
                  ? null
                  : FileImage(File(stickerPack.trayImage!)),
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),

      /// Title and publisher
      title: GestureDetector(
        onTap: renameStickerPack,
        child: Text(widget.stickerPack.name),
      ),
      subtitle: Text(stickerPack.publisher),

      /// Animated pack button
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (stickerPack.animatedStickerPack)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.play_circle_outline),
            ),
          if (stickerPack.stickers.isNotEmpty)
            Text(
              stickerPack.stickers.length.toString(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
        ],
      ),
    );
  }
}

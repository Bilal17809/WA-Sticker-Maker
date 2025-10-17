import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_info/sticker_pack_info.dart';
import 'package:whatsapp_stickers_handler_example/app/widgets/dialogs.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_service.dart';
import 'package:whatsapp_stickers_handler_example/util/util.dart';

class AddStickerPackButton extends StatelessWidget {
  ///

  /// Add new sticker pack
  void createStickerPack(BuildContext context, StickerPackProvider prov) {
    Dialogs.textField(
      context: context,
      title: 'Sticker Pack Name',
      onSubmit: (input) async {
        StickerPack stickerPack = await StickerService.createStickerPack(
          prov,
          input,
        );
        Util.pushTo(context, StickerPackInfo(stickerPack));
      },
    );
  }

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    StickerPackProvider prov = context.watch<StickerPackProvider>();

    return FloatingActionButton(
      onPressed: () => createStickerPack(context, prov),
      child: Icon(Icons.add),
    );
  }

  /// endregion build
}

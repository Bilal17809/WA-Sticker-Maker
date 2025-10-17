import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_info/sticker_pack_info.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_list/provide_sticker_pack_button.dart';
import 'package:whatsapp_stickers_handler_example/util/util.dart';

class StickerPackListItem extends StatelessWidget {
  ///

  StickerPackListItem(this.stickerPack);

  final StickerPack stickerPack;

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Util.pushTo(context, StickerPackInfo(stickerPack)),
      title: Text(stickerPack.name),
      subtitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            /// When no stickers are in pack
            if (stickerPack.stickers.isEmpty) Icon(Icons.landscape),

            /// Preview stickers
            for (final String sticker in stickerPack.stickers.take(5))
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.file(File(sticker), height: 45, width: 45),
              ),
          ],
        ),
      ),

      /// Button to add sticker pack to WhatsApp
      trailing: ProvideStickerPackButton(stickerPack),
    );
  }

  /// endregion build
}

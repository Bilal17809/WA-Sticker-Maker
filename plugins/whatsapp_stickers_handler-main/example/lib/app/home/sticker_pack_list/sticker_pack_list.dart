import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_list/sticker_pack_list_item.dart';
import 'package:whatsapp_stickers_handler_example/app/widgets/empty_icon.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';

class StickerPackList extends StatelessWidget {
  ///

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    context.watch<StickerPackProvider>();
    List<StickerPack> stickerPacks = StickerPackProvider.stickerPacks;

    /// If no sticker packs are existing
    if (stickerPacks.isEmpty) {
      return EmptyIcon();
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 100),
      physics: RangeMaintainingScrollPhysics(),
      itemCount: stickerPacks.length,
      itemBuilder: (context, index) {
        return StickerPackListItem(stickerPacks[index]);
      },
    );
  }

  /// endregion build
}

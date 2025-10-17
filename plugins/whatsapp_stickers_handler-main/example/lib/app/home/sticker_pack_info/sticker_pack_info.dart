import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_info/add_stickers_button.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_info/delete_button.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_info/sticker_list.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_info/sticker_pack_metadata.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';

class StickerPackInfo extends StatefulWidget {
  ///

  StickerPackInfo(this.stickerPack);

  final StickerPack stickerPack;

  @override
  State<StickerPackInfo> createState() => _StickerPackInfoState();
}

class _StickerPackInfoState extends State<StickerPackInfo> {
  ///

  late StickerPack stickerPack = widget.stickerPack;
  final controller = DragSelectGridViewController();

  @override
  void initState() {
    super.initState();
    controller.addListener(rebuild);
  }

  @override
  void dispose() {
    controller.removeListener(rebuild);
    super.dispose();
  }

  /// Rebuilds widget (for selecting stickers)
  void rebuild() => setState(() {});

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    StickerPackProvider prov = context.watch<StickerPackProvider>();

    return Scaffold(
      /// App bar
      appBar: AppBar(
        actions: [
          DeleteButton(
            stickerPack: stickerPack,
            prov: prov,
            controller: controller,
          ),
        ],

        /// Metadata
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: StickerPackMetadata(stickerPack, prov),
          ),
        ),
      ),

      /// Sticker list
      body: StickerList(stickerPack, controller),

      /// Add sticker button
      floatingActionButton: AddStickersButton(stickerPack),
    );
  }
}

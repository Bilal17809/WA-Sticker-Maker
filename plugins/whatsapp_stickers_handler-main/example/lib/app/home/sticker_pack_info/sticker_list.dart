import 'dart:io';

import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/widgets/dialogs.dart';
import 'package:whatsapp_stickers_handler_example/app/widgets/empty_icon.dart';

class StickerList extends StatefulWidget {
  ///

  StickerList(this.stickerPack, this.controller);

  final StickerPack stickerPack;
  final DragSelectGridViewController controller;

  @override
  State<StickerList> createState() => _StickerListState();
}

class _StickerListState extends State<StickerList> {
  ///

  /// Shows dialog with sticker
  void showSticker(String sticker) {
    Dialogs.showSticker(context: context, sticker: sticker);
  }

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    /// When sticker pack is empty
    if (widget.stickerPack.stickers.isEmpty) {
      return EmptyIcon();
    }

    return DragSelectGridView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 100),
      gridController: widget.controller,
      itemCount: widget.stickerPack.stickers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (context, index, selected) {
        final String sticker = widget.stickerPack.stickers[index];

        return GestureDetector(
          onTap: () => showSticker(sticker),
          child: GridTile(
            /// Checkbox
            header:
                widget.controller.value.isSelecting
                    ? Container(
                      alignment: Alignment.topRight,
                      child: Checkbox(
                        visualDensity: VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        shape: CircleBorder(),
                        value: selected,
                        onChanged: (_) {},
                      ),
                    )
                    : null,

            /// Sticker
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: selected ? 0.4 : 0),
                BlendMode.srcATop,
              ),
              child: Image.file(File(sticker)),
            ),
          ),
        );
      },
    );
  }

  /// endregion build
}

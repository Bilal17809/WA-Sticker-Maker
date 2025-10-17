import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/app/widgets/dialogs.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_service.dart';

class DeleteButton extends StatelessWidget {
  ///

  DeleteButton({
    required this.stickerPack,
    required this.prov,
    required this.controller,
  });

  final StickerPack stickerPack;
  final StickerPackProvider prov;
  final DragSelectGridViewController controller;

  void onClick(BuildContext context) {
    controller.value.isSelecting
        ? deleteSelectedStickersDialog(context)
        : deleteStickerPackDialog(context);
  }

  /// Deletes sticker pack
  void deleteStickerPackDialog(BuildContext context) async {
    Dialogs.confirm(
      context: context,
      title: 'Delete pack ${stickerPack.name}?',
      onSubmit: () async {
        await StickerService.deleteStickerPack(prov, stickerPack.identifier);
        Navigator.pop(context);
      },
    );
  }

  /// Deletes the selected stickers
  void deleteSelectedStickersDialog(BuildContext context) async {
    Dialogs.confirm(
      context: context,
      title: 'Delete ${controller.value.amount} selected stickers?',
      onSubmit: () {
        List<String> selectedFiles = getSelectedFiles();
        StickerService.deleteStickersFromStickerPack(
          prov,
          stickerPack,
          selectedFiles,
        );
        controller.clear();
      },
    );
  }

  /// Returns the selected files
  List<String> getSelectedFiles() {
    List<int> indexes = controller.value.selectedIndexes.toList();
    indexes.sort((a, b) => a.compareTo(b));
    return indexes.map((index) => stickerPack.stickers[index]).toList();
  }

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(right: 5),
      onPressed: () => onClick(context),
      icon: Icon(Icons.delete_outlined),
    );
  }

  /// endregion build
}

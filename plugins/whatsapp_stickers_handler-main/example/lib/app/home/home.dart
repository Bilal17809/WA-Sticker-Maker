import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler_example/app/home/add_sticker_pack_button.dart';
import 'package:whatsapp_stickers_handler_example/app/home/sticker_pack_list/sticker_pack_list.dart';

/// Home of the App
class Home extends StatelessWidget {
  ///

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Whatsapp Stickers Handler Example')),
      body: StickerPackList(),

      /// Add new sticker pack button
      floatingActionButton: AddStickerPackButton(),
    );
  }
}

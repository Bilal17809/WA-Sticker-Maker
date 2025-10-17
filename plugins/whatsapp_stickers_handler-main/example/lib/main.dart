import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/provider/sticker_pack_provider.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_service.dart';
import 'package:whatsapp_stickers_handler_example/services/sticker_storage_service.dart';
import 'package:whatsapp_stickers_handler_example/whatsapp_stickers_handler_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service and get stored sticker packs
  await StickerStorageService.initialize();
  List<StickerPack> stickerPacks = await StickerService.getAllStickerPacks();

  // Add sticker packs to sticker pack provider
  StickerPackProvider stickerPackProvider = StickerPackProvider();
  await stickerPackProvider.initialize(stickerPacks);

  return runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => stickerPackProvider)],
      child: WhatsappStickersHandlerExample(),
    ),
  );
}

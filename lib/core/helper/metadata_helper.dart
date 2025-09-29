import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> updateMetadata(
  String packId,
  String packName,
  String trayImage,
  String stickerFile,
) async {
  final dir = await getApplicationDocumentsDirectory();
  final packDir = Directory("${dir.path}/stickers/$packId");
  final metaFile = File("${packDir.path}/metadata.json");

  Map<String, dynamic> metadata;

  if (await metaFile.exists()) {
    metadata = jsonDecode(await metaFile.readAsString());
  } else {
    metadata = {
      "identifier": packId,
      "name": packName,
      "publisher": "WA Sticker Maker",
      "tray_image_file": trayImage,
      "stickers": [],
    };
  }

  metadata["stickers"].add({
    "image_file": stickerFile,
    "emojis": ["🙂"],
  });

  await metaFile.writeAsString(jsonEncode(metadata));
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';

class PackPreparerHelper {
  static Future<BuiltInPacksState> preparePackFromAssets(
    BuiltInPacksState packState,
  ) async {
    final packDir = await _createTemporaryPackDirectory(packState.displayName);
    final trayFilePath = await _copyTrayImage(packState, packDir);
    final stickerFiles = await _copyStickerFiles(packState, packDir);
    return packState.copyWith(
      directoryPath: packDir.path,
      stickerPaths: stickerFiles,
      trayImagePath: trayFilePath,
    );
  }

  static Future<Directory> _createTemporaryPackDirectory(
    String packName,
  ) async {
    final tempDir = await getTemporaryDirectory();
    final packDir = Directory('${tempDir.path}/sticker_pack_$packName');
    if (await packDir.exists()) {
      await packDir.delete(recursive: true);
    }
    await packDir.create(recursive: true);
    return packDir;
  }

  static Future<String?> _copyTrayImage(
    BuiltInPacksState packState,
    Directory packDir,
  ) async {
    if (packState.thumbnail.isEmpty) return null;
    final trayAsset = packState.thumbnail;
    final trayData = await rootBundle.load(trayAsset);
    final trayName = trayAsset.split('/').last;
    final file = File('${packDir.path}/$trayName');
    await file.writeAsBytes(trayData.buffer.asUint8List());
    return file.path;
  }

  static Future<List<String>> _copyStickerFiles(
    BuiltInPacksState packState,
    Directory packDir,
  ) async {
    final List<String> stickerFiles = [];
    for (final assetPath in packState.stickers) {
      final bytes = await rootBundle.load(assetPath);
      final name = assetPath.split('/').last;
      final file = File('${packDir.path}/$name');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      stickerFiles.add(file.path);
    }
    return stickerFiles;
  }
}

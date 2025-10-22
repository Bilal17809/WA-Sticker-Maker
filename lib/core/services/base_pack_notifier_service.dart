import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/common/app_exceptions.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';
import '/core/interface/pack_info_interface.dart';

abstract class BasePackNotifierService<T extends PackInfoInterface>
    extends Notifier<List<T>> {
  String get storageKey;
  String get packSubdirectory;
  T createPackFromJson(Map<String, dynamic> json);
  T createPack({
    required String name,
    required String directoryPath,
    required List<String> stickerPaths,
  });
  T copyPackWith(T pack, {List<String>? stickerPaths});

  @override
  List<T> build() {
    _loadPacks();
    return [];
  }

  Future<void> _loadPacks() async {
    try {
      final localStorage = ref.read(localStorageProvider);
      final packsJson = await localStorage.getStringList(storageKey);
      if (packsJson != null && packsJson.isNotEmpty) {
        final packs = packsJson
            .map((jsonStr) => createPackFromJson(json.decode(jsonStr)))
            .where((pack) {
              final dir = Directory(pack.directoryPath);
              return dir.existsSync();
            })
            .toList();
        state = packs;
      }
    } catch (e) {
      debugPrint('${AppExceptions().errorLoadingPacks} $e');
    }
  }

  Future<void> _savePacks() async {
    try {
      final localStorage = ref.read(localStorageProvider);
      final packsJson = state
          .map(
            (pack) => json.encode({
              'name': pack.name,
              'directoryPath': pack.directoryPath,
              'stickerPaths': pack.stickerPaths,
              'trayImagePath': pack.trayImagePath,
            }),
          )
          .toList();
      await localStorage.setStringList(storageKey, packsJson);
    } catch (e) {
      debugPrint('${AppExceptions().errorSavingPack}: $e');
    }
  }

  Future<String?> _createPackDirectory(String packName) async {
    try {
      final baseDir = await getApplicationDocumentsDirectory();
      final externalDir = Directory('${baseDir.path}/WA Sticker Maker/$packSubdirectory/$packName');

      final galleryPackDir = Directory('${baseDir.path}/WA Sticker Maker/Gallery Packs/$packName');
      final libraryPackDir = Directory('${baseDir.path}/WA Sticker Maker/Library Packs/$packName');
      final aiPackDir = Directory('${baseDir.path}/WA Sticker Maker/AI Packs/$packName');

      if (await galleryPackDir.exists() ||
          await libraryPackDir.exists() ||
          await aiPackDir.exists()) {
        return null;
      }

      final parentDir = externalDir.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      await externalDir.create(recursive: true);
      return externalDir.path;
    } catch (e) {
      debugPrint('${AppExceptions().errorCreatingDirectory}: $e');
      return null;
    }
  }

  // Future<String?> _createPackDirectory(String packName) async {
  //   try {
  //     final externalDir = Directory('/storage/emulated/0');
  //     final galleryPackDir = Directory(
  //       '${externalDir.path}/DCIM/WA Sticker Maker/Gallery Packs/$packName',
  //     );
  //     final libraryPackDir = Directory(
  //       '${externalDir.path}/DCIM/WA Sticker Maker/Library Packs/$packName',
  //     );
  //     final aiPackDir = Directory(
  //       '${externalDir.path}/DCIM/WA Sticker Maker/AI Packs/$packName',
  //     );
  //     if (await galleryPackDir.exists() ||
  //         await libraryPackDir.exists() ||
  //         await aiPackDir.exists()) {
  //       return null;
  //     }
  //     final packDir = Directory(
  //       '${externalDir.path}/DCIM/WA Sticker Maker/$packSubdirectory/$packName',
  //     );
  //     final parentDir = packDir.parent;
  //     if (!await parentDir.exists()) {
  //       await parentDir.create(recursive: true);
  //     }
  //     await packDir.create(recursive: true);
  //     return packDir.path;
  //   } catch (e) {
  //     debugPrint('${AppExceptions().errorCreatingDirectory}: $e');
  //     return null;
  //   }
  // }

  Future<void> addNewPack(BuildContext context) async {
    final packName = await AddPackDialog.show(context);
    if (packName == null || packName.isEmpty) return;
    final dirPath = await _createPackDirectory(packName);
    if (dirPath == null) {
      if (!context.mounted) return;
      SimpleToast.showToast(
        context: context,
        message: "A Pack of name '$packName' already exists",
      );
      return;
    }
    final pack = createPack(
      name: packName,
      directoryPath: dirPath,
      stickerPaths: [],
    );
    state = [...state, pack];
    await _savePacks();
  }

  Future<void> deletePack(BuildContext context, T pack) async {
    final shouldDelete = await DeletePackDialog.show(context);
    if (shouldDelete != true) return;
    try {
      final dir = Directory(pack.directoryPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
      state = state.where((p) => p != pack).toList();
      await _savePacks();
    } catch (e) {
      debugPrint('${AppExceptions().errorDeletingPack}: $e');
    }
  }

  Future<void> removeStickerFromPack(T pack, String stickerPath) async {
    try {
      final index = state.indexWhere(
        (p) => p.directoryPath == pack.directoryPath,
      );
      if (index == -1) return;
      final updatedStickerPaths = List<String>.from(state[index].stickerPaths)
        ..remove(stickerPath);
      final updatedPack = copyPackWith(
        state[index],
        stickerPaths: updatedStickerPaths,
      );
      updatePack(index, updatedPack);
      final file = File(stickerPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('${AppExceptions().errorDeletingPack}: $e');
    }
  }

  void updatePack(int index, T updatedPack) {
    final list = [...state];
    list[index] = updatedPack;
    state = list;
    _savePacks();
  }
}

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/core/common/app_exceptions.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';

class LibraryPacksNotifier extends Notifier<List<LibraryPacksState>> {
  static const String _packsKey = 'saved_lib_packs';

  @override
  List<LibraryPacksState> build() {
    _loadPacks();
    return [];
  }

  Future<void> _loadPacks() async {
    try {
      final localStorage = ref.read(localStorageProvider);
      final packsJson = await localStorage.getStringList(_packsKey);

      if (packsJson != null && packsJson.isNotEmpty) {
        final packs = packsJson
            .map((jsonStr) => LibraryPacksState.fromJson(json.decode(jsonStr)))
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
          .map((pack) => json.encode(pack.toJson()))
          .toList();
      await localStorage.setStringList(_packsKey, packsJson);
    } catch (e) {
      debugPrint('${AppExceptions().errorSavingPack}: $e');
    }
  }

  Future<String?> _createPackDirectory(String packName) async {
    try {
      final externalDir = Directory('/storage/emulated/0');
      final packDir = Directory(
        '${externalDir.path}/DCIM/WA Sticker Maker/Library Packs/$packName',
      );
      if (!await packDir.exists()) {
        await packDir.create(recursive: true);
      }
      return packDir.path;
    } catch (e) {
      debugPrint('${AppExceptions().errorCreatingDirectory}: $e');
      return null;
    }
  }

  Future<void> addNewPack(BuildContext context) async {
    final packName = await AddPackDialog.show(context);
    if (packName == null || packName.isEmpty) return;
    final dirPath = await _createPackDirectory(packName);
    if (dirPath != null) {
      final pack = LibraryPacksState(
        name: packName,
        directoryPath: dirPath,
        stickerPaths: [],
      );
      state = [...state, pack];
      await _savePacks();
    }
  }

  Future<void> deletePack(BuildContext context, LibraryPacksState pack) async {
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

  Future<void> removeStickerFromPack(
    LibraryPacksState pack,
    String stickerPath,
  ) async {
    try {
      final index = state.indexWhere(
        (p) => p.directoryPath == pack.directoryPath,
      );
      if (index == -1) return;
      final updatedStickerPaths = List<String>.from(state[index].stickerPaths)
        ..remove(stickerPath);
      final updatedPack = state[index].copyWith(
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

  void updatePack(int index, LibraryPacksState updatedPack) {
    final list = [...state];
    list[index] = updatedPack;
    state = list;
    _savePacks();
  }
}

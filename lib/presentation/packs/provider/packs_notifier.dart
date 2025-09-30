import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';
import '/presentation/packs/provider/packs_state.dart';

class PacksNotifier extends Notifier<List<PacksState>> {
  static const String _packsKey = 'saved_packs';

  @override
  List<PacksState> build() {
    _loadPacks();
    return [];
  }

  Future<void> _loadPacks() async {
    try {
      final localStorage = ref.read(localStorageProvider);
      final packsJson = await localStorage.getStringList(_packsKey);

      if (packsJson != null && packsJson.isNotEmpty) {
        final packs = packsJson
            .map((jsonStr) => PacksState.fromJson(json.decode(jsonStr)))
            .where((pack) {
              final dir = Directory(pack.directoryPath);
              return dir.existsSync();
            })
            .toList();
        state = packs;
      }
    } catch (e) {
      debugPrint('Error loading packs: $e');
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
      debugPrint('Error saving packs: $e');
    }
  }

  Future<String?> _createPackDirectory(String packName) async {
    try {
      final externalDir = Directory('/storage/emulated/0');
      final packDir = Directory(
        '${externalDir.path}/DCIM/WA Sticker Maker/$packName',
      );
      if (!await packDir.exists()) {
        await packDir.create(recursive: true);
      }
      return packDir.path;
    } catch (e) {
      debugPrint('Error creating pack directory: $e');
      return null;
    }
  }

  Future<void> addNewPack(BuildContext context) async {
    final packName = await AddPackDialog.show(context);
    if (packName == null || packName.isEmpty) return;
    final dirPath = await _createPackDirectory(packName);
    if (dirPath != null) {
      final pack = PacksState(
        name: packName,
        directoryPath: dirPath,
        stickerPaths: [],
      );
      state = [...state, pack];
      await _savePacks();
    }
  }

  Future<void> deletePack(BuildContext context, PacksState pack) async {
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
      debugPrint('Error deleting pack: $e');
    }
  }

  void updatePack(int index, PacksState updatedPack) {
    final list = [...state];
    list[index] = updatedPack;
    state = list;
    _savePacks();
  }
}

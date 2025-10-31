import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';

class BuiltInPackLoaderService {
  Future<List<BuiltInPacksState>> loadFromAssets() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final Map<String, List<String>> packsMap = {};
      for (final assetPath in manifestMap.keys) {
        if (!assetPath.startsWith('assets/sticker_packs/')) continue;
        final parts = assetPath.split('/');
        if (parts.length < 3) continue;
        final id = parts[2];
        packsMap.putIfAbsent(id, () => []).add(assetPath);
      }
      final List<BuiltInPacksState> packs = packsMap.entries.map((entry) {
        final id = entry.key;
        final files = List<String>.from(entry.value);
        final thumbnail = 'assets/sticker_packs/$id/1.png';
        final stickers = files.where((p) {
          final filename = p.split('/').last.toLowerCase();
          return filename != '1.png';
        }).toList();
        String displayName = id.replaceFirst(RegExp(r'^\d+_'), '');
        return BuiltInPacksState(
          name: displayName,
          thumbnail: thumbnail,
          stickers: stickers,
        );
      }).toList();
      return packs;
    } catch (_) {
      return [];
    }
  }
}

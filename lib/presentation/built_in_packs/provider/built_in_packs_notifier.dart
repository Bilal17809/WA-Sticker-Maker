import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';

class BuiltInPacksNotifier extends Notifier<List<BuiltInPacksState>> {
  String _searchQuery = '';

  @override
  List<BuiltInPacksState> build() {
    state = [];
    loadFromAsset();
    return state;
  }

  Future<void> loadFromAsset({
    String assetPath = 'assets/sticker_packs.json',
  }) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final parsed = json.decode(raw) as List<dynamic>;
      state = parsed
          .map((e) => BuiltInPacksState.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      state = [];
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    state = state
        .where((p) => p.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void resetSearch() async {
    await loadFromAsset();
  }
}

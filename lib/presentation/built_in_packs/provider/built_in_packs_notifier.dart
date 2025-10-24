import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/providers/providers.dart';
import '/core/utils/utils.dart';
import '/core/services/services.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';

class BuiltInPacksNotifier extends Notifier<List<BuiltInPacksState>> {
  late final JsonLoaderService _jsonLoaderService;
  String _searchQuery = '';
  List<BuiltInPacksState> _originalPacks = [];

  @override
  List<BuiltInPacksState> build() {
    _jsonLoaderService = ref.read(jsonLoaderProvider);
    loadFromAsset();
    return [];
  }

  Future<void> loadFromAsset() async {
    try {
      final parsed =
          await _jsonLoaderService.loadJson(Assets.stickerPackJson)
              as List<dynamic>;
      _originalPacks = parsed
          .map((e) => BuiltInPacksState.fromJson(e as Map<String, dynamic>))
          .toList();
      state = _originalPacks;
    } catch (_) {
      _originalPacks = [];
      state = [];
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      state = _originalPacks;
    } else {
      state = _originalPacks
          .where((p) => p.name.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }
}

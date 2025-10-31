import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';
import '/core/services/services.dart';
import '/core/helper/helper.dart';

class BuiltInPacksNotifier extends Notifier<List<BuiltInPacksState>> {
  String _searchQuery = '';
  List<BuiltInPacksState> _originalPacks = [];
  final BuiltInPackLoaderService _loaderService = BuiltInPackLoaderService();

  @override
  List<BuiltInPacksState> build() {
    loadFromAssets();
    return [];
  }

  Future<void> loadFromAssets() async {
    try {
      final packs = await _loaderService.loadFromAssets();
      _originalPacks = packs;
      state = _originalPacks;
    } catch (_) {
      _originalPacks = [];
      state = [];
    }
  }

  Future<String?> exportPack(BuiltInPacksState packState) async {
    try {
      final packInfo = await PackPreparerHelper.preparePackFromAssets(
        packState,
      );
      final result = await PackExportService().exportPack(packInfo);
      return result;
    } catch (_) {
      return 'Failed to export pack.';
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      state = _originalPacks;
    } else {
      state = _originalPacks
          .where((p) => p.displayName.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  void toggleBanner(String packName, bool value) {
    state = [
      for (final pack in state)
        if (pack.name == packName) pack.copyWith(showBanner: value) else pack,
    ];
  }
}

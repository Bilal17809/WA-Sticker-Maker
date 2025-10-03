import '/core/services/services.dart';
import '/presentation/packs/provider/packs_state.dart';

class PacksNotifier extends BasePackNotifierService<PacksState> {
  static const String _packsKey = 'saved_packs';

  @override
  String get storageKey => _packsKey;

  @override
  String get packSubdirectory => 'Gallery Packs';

  @override
  PacksState createPackFromJson(Map<String, dynamic> json) {
    return PacksState.fromJson(json);
  }

  @override
  PacksState createPack({
    required String name,
    required String directoryPath,
    required List<String> stickerPaths,
  }) {
    return PacksState(
      name: name,
      directoryPath: directoryPath,
      stickerPaths: stickerPaths,
    );
  }

  @override
  PacksState copyPackWith(PacksState pack, {List<String>? stickerPaths}) {
    return pack.copyWith(stickerPaths: stickerPaths);
  }
}

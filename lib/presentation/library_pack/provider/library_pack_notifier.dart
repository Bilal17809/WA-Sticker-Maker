import '/core/services/services.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';

class LibraryPacksNotifier extends BasePackNotifierService<LibraryPacksState> {
  static const String _packsKey = 'saved_lib_packs';

  @override
  String get storageKey => _packsKey;

  @override
  String get packSubdirectory => 'Library Packs';

  @override
  LibraryPacksState createPackFromJson(Map<String, dynamic> json) {
    return LibraryPacksState.fromJson(json);
  }

  @override
  LibraryPacksState createPack({
    required String name,
    required String directoryPath,
    required List<String> stickerPaths,
  }) {
    return LibraryPacksState(
      name: name,
      directoryPath: directoryPath,
      stickerPaths: stickerPaths,
    );
  }

  @override
  LibraryPacksState copyPackWith(
    LibraryPacksState pack, {
    List<String>? stickerPaths,
  }) {
    return pack.copyWith(stickerPaths: stickerPaths);
  }
}

import '../provider/ai_packs_state.dart';
import '/core/services/services.dart';

class AiPacksNotifier extends BasePackNotifierService<AiPacksState> {
  static const String _packsKey = 'ai_saved_packs';

  @override
  String get storageKey => _packsKey;

  @override
  String get packSubdirectory => 'AI Packs';

  @override
  AiPacksState createPackFromJson(Map<String, dynamic> json) {
    return AiPacksState.fromJson(json);
  }

  @override
  AiPacksState createPack({
    required String name,
    required String directoryPath,
    required List<String> stickerPaths,
  }) {
    return AiPacksState(
      name: name,
      directoryPath: directoryPath,
      stickerPaths: stickerPaths,
    );
  }

  @override
  AiPacksState copyPackWith(AiPacksState pack, {List<String>? stickerPaths}) {
    return pack.copyWith(stickerPaths: stickerPaths);
  }
}

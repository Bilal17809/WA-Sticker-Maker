import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/presentation/ai_pack_gallery/provider/ai_pack_gallery_state.dart';
import '/core/providers/providers.dart';

class AiPackGalleryNotifier extends Notifier<AiPackGalleryState> {
  @override
  AiPackGalleryState build() => const AiPackGalleryState();

  Future<void> exportPackToWhatsApp(AiPacksState pack) async {
    state = state.copyWith(isExporting: true, lastMessage: () => null);
    final packs = ref.read(aiPacksProvider);
    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == pack.directoryPath,
      orElse: () => pack,
    );
    final message = await ref
        .read(packExportServiceProvider)
        .exportPack(currentPack);
    if (message != null) {
      state = state.copyWith(lastMessage: () => message);
    }
    state = state.copyWith(isExporting: false);
  }

  void clearMessage() {
    if (state.lastMessage != null) {
      state = state.copyWith(lastMessage: () => null);
    }
  }
}

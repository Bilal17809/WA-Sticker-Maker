import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/packs/provider/packs_state.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/presentation/library_pack_gallery/provider/library_pack_gallery_state.dart';
import '/core/providers/providers.dart';

class LibraryPackGalleryNotifier extends Notifier<LibraryPackGalleryState> {
  @override
  LibraryPackGalleryState build() => const LibraryPackGalleryState();

  Future<void> exportPackToWhatsApp(LibraryPacksState pack) async {
    state = state.copyWith(isExporting: true, lastMessage: () => null);
    final packs = ref.read(libraryPacksProvider);
    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == pack.directoryPath,
      orElse: () => pack,
    );
    final message = await ref
        .read(packExportServiceProvider)
        .exportPack(currentPack as PacksState);
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

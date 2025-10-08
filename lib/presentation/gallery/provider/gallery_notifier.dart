import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/services/services.dart';
import '/core/providers/providers.dart';
import '/presentation/packs/provider/packs_state.dart';
import 'gallery_state.dart';

class GalleryNotifier extends Notifier<GalleryState> {
  final _conversionService = StickerConversionService();

  @override
  GalleryState build() => const GalleryState();

  void setNewImage(File file) {
    state = state.copyWith(originalFile: file, editedFile: file);
  }

  void updateEditedFile(File file) {
    state = state.originalFile == null
        ? state.copyWith(originalFile: file, editedFile: file)
        : state.copyWith(editedFile: file);
  }

  void resetToOriginal() =>
      state = state.copyWith(editedFile: state.originalFile);

  Future<void> saveAsWebPToPack(PacksState pack, String fileName) async {
    if (state.editedFile == null) return;
    state = state.copyWith(isSaving: true);
    try {
      final outPath = '${pack.directoryPath}/$fileName.webp';
      final converted = await _conversionService.convertFileToWebP512(
        state.editedFile!,
        outPath,
      );
      if (converted == null) return;
      final packs = ref.read(packsProvider.notifier);
      final i = packs.state.indexWhere(
        (p) => p.directoryPath == pack.directoryPath,
      );
      if (i == -1) return;
      final current = packs.state[i];
      final updated = current.copyWith(
        stickerPaths: [...current.stickerPaths, converted],
        trayImagePath: current.stickerPaths.isEmpty
            ? converted
            : current.trayImagePath,
      );
      packs.updatePack(i, updated);
    } finally {
      state = state.copyWith(isSaving: false, editedFile: null);
    }
  }
}

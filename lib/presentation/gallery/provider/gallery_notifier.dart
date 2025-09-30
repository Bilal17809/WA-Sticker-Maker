import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import '/core/providers/providers.dart';
import '/presentation/packs/provider/packs_state.dart';
import 'gallery_state.dart';

class GalleryNotifier extends Notifier<GalleryState> {
  @override
  GalleryState build() => const GalleryState();

  final _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      state = state.copyWith(originalFile: file, editedFile: file);
    }
  }

  void updateEditedFile(File file) {
    if (state.originalFile == null) {
      state = state.copyWith(originalFile: file, editedFile: file);
    } else {
      state = state.copyWith(editedFile: file);
    }
  }

  void resetToOriginal() {
    state = state.copyWith(editedFile: state.originalFile);
  }

  Future<void> saveAsWebPToPack(PacksState pack, String fileName) async {
    if (state.editedFile == null) return;
    state = state.copyWith(isSaving: true);
    try {
      final filePath = '${pack.directoryPath}/$fileName.webp';
      await FFmpegKit.execute(
        '-i "${state.editedFile!.path}" '
        '-vf "scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2:color=0x00000000" '
        '-vcodec libwebp -quality 75 -compression_level 6 -y "$filePath"',
      );
      final file = File(filePath);
      if (await file.exists()) {
        final fileSize = await file.length();
        if (fileSize > 100 * 1024) {
          await FFmpegKit.execute(
            '-i "${state.editedFile!.path}" '
            '-vf "scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2:color=0x00000000" '
            '-vcodec libwebp -quality 50 -compression_level 6 -y "$filePath"',
          );
        }
      }
      final packsNotifier = ref.read(packsProvider.notifier);
      final index = packsNotifier.state.indexWhere(
        (p) => p.directoryPath == pack.directoryPath,
      );
      if (index != -1) {
        final currentPack = packsNotifier.state[index];
        final updatedStickerPaths = [...currentPack.stickerPaths, filePath];
        final updatedPack = currentPack.copyWith(
          stickerPaths: updatedStickerPaths,
          trayImagePath: currentPack.stickerPaths.isEmpty
              ? filePath
              : currentPack.trayImagePath,
        );
        packsNotifier.updatePack(index, updatedPack);
      }
    } finally {
      state = state.copyWith(isSaving: false, editedFile: null);
    }
  }
}

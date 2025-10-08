import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '/presentation/packs/provider/packs_state.dart';
import '/presentation/pack_gallery/provider/pack_gallery_state.dart';
import '/core/providers/providers.dart';

class PackGalleryNotifier extends Notifier<PackGalleryState> {
  final _picker = ImagePicker();

  @override
  PackGalleryState build() => const PackGalleryState();

  Future<File?> pickImageForPack() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    final file = File(pickedFile.path);
    ref.read(galleryProvider.notifier).setNewImage(file);
    return file;
  }

  Future<void> exportPackToWhatsApp(PacksState pack) async {
    state = state.copyWith(isExporting: true, lastMessage: () => null);
    final packs = ref.read(packsProvider);
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

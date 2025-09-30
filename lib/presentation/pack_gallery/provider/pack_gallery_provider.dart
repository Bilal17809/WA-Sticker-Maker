import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack_exception.dart';
import 'package:whatsapp_stickers_handler/service/sticker_pack_util.dart';
import '/core/providers/providers.dart';
import '/core/services/whatsapp_service.dart';
import '/presentation/packs/provider/packs_state.dart';
import 'pack_gallery_state.dart';

class PackGalleryNotifier extends Notifier<PackGalleryState> {
  final _picker = ImagePicker();

  @override
  PackGalleryState build() => const PackGalleryState();

  Future<File?> pickImageForPack() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    ref.read(galleryProvider.notifier).updateEditedFile(file);
    return file;
  }

  Future<void> exportPackToWhatsApp(PacksState pack) async {
    final packs = ref.read(packsProvider);
    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == pack.directoryPath,
      orElse: () => pack,
    );
    if (currentPack.stickerPaths.length < 3) {
      state = state.copyWith(
        lastMessage: () => 'Need at least 3 stickers to export to WhatsApp.',
      );
      return;
    }
    if (currentPack.stickerPaths.length > 30) {
      state = state.copyWith(
        lastMessage: () =>
            'WhatsApp sticker packs can contain maximum 30 stickers.',
      );
      return;
    }
    state = state.copyWith(isExporting: true, lastMessage: () => null);
    try {
      final isInstalled = await WhatsAppService.isWhatsAppInstalled;
      if (!isInstalled) {
        state = state.copyWith(
          isExporting: false,
          lastMessage: () => 'WhatsApp is not installed on this device.',
        );
        return;
      }
      final identifier = currentPack.name.toLowerCase().replaceAll(
        RegExp(r'[^a-z0-9]'),
        '_',
      );
      String? trayImagePath;
      if (currentPack.trayImagePath != null &&
          File(currentPack.trayImagePath!).existsSync()) {
        trayImagePath = await StickerPackUtil().saveWebpAsTrayImage(
          currentPack.trayImagePath!,
        );
      } else if (currentPack.stickerPaths.isNotEmpty) {
        trayImagePath = await StickerPackUtil().saveWebpAsTrayImage(
          currentPack.stickerPaths.first,
        );
      }
      if (trayImagePath == null) {
        state = state.copyWith(
          isExporting: false,
          lastMessage: () => 'Failed to create tray image.',
        );
        return;
      }
      final stickerPack = StickerPack(
        identifier: identifier,
        name: currentPack.name,
        publisher: 'WA Sticker Maker',
        trayImage: trayImagePath,
        publisherWebsite: '',
        privacyPolicyWebsite: '',
        licenseAgreementWebsite: '',
      );
      stickerPack.stickers = currentPack.stickerPaths;
      final isPackInstalled = await WhatsAppService.isStickerPackInstalled(
        identifier,
      );

      if (isPackInstalled) {
        await WhatsAppService.updateStickerPack(stickerPack);
        state = state.copyWith(
          isExporting: false,
          lastMessage: () => 'Pack "${currentPack.name}" updated in WhatsApp!',
        );
      } else {
        await WhatsAppService.addStickerPack(stickerPack);
        state = state.copyWith(
          isExporting: false,
          lastMessage: () => 'Pack "${currentPack.name}" added to WhatsApp!',
        );
      }
    } on StickerPackException catch (e) {
      state = state.copyWith(
        isExporting: false,
        lastMessage: () => 'Validation error: ${e.message}',
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        lastMessage: () => 'Export failed: $e',
      );
    }
  }

  void clearMessage() {
    if (state.lastMessage != null) {
      state = state.copyWith(lastMessage: () => null);
    }
  }
}

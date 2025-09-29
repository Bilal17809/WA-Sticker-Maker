import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/providers/providers.dart';
import '../../packs/provider/packs_state.dart';
import 'gallery_state.dart';

class GalleryProvider extends Notifier<GalleryState> {
  @override
  GalleryState build() => const GalleryState();

  final _picker = ImagePicker();
  static const platform = MethodChannel('wa_sticker_maker/saveSticker');

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      state = state.copyWith(originalFile: file, editedFile: file);
    }
  }

  void updateEditedFile(File file) {
    state = state.copyWith(editedFile: file);
  }

  void resetToOriginal() {
    state = state.copyWith(editedFile: state.originalFile);
  }

  Future<int> _androidSdk() async {
    try {
      return await platform.invokeMethod<int>('getAndroidVersion') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final sdk = await _androidSdk();

    if (sdk >= 30) {
      if (!await Permission.manageExternalStorage.isGranted) {
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      }
      return true;
    } else {
      var status = await Permission.storage.status;
      return status.isGranted;
    }
  }

  Future<void> saveAsWebPToPack(PacksState pack, String fileName) async {
    if (state.editedFile == null) return;
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    state = state.copyWith(isSaving: true);
    try {
      final filePath = '${pack.directoryPath}/$fileName.webp';

      // Convert image to WebP
      await FFmpegKit.execute(
        '-i "${state.editedFile!.path}" '
        '-vf "scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2:color=0x00000000" '
        '-vcodec libwebp -lossless 1 -y "$filePath"',
      );

      // Update pack's stickerPaths in Riverpod
      final packsNotifier = ref.read(packsProvider.notifier);
      final index = packsNotifier.state.indexOf(pack);
      if (index != -1) {
        final updatedPack = pack.copyWith(
          stickerPaths: [...pack.stickerPaths, filePath],
        );
        packsNotifier.updatePack(index, updatedPack);
      }
    } finally {
      state = state.copyWith(isSaving: false, editedFile: null);
    }
  }

  // Future<void> saveAsWebP(String fileName) async {
  //   if (state.editedFile == null) return;
  //   final hasPermission = await _requestStoragePermission();
  //   if (!hasPermission) {
  //     debugPrint('Storage permission denied');
  //     return;
  //   }
  //
  //   state = state.copyWith(isSaving: true);
  //   try {
  //     final tempDir = await getTemporaryDirectory();
  //     final tempPath = '${tempDir.path}/$fileName.webp';
  //
  //     await FFmpegKit.execute(
  //       '-i "${state.editedFile!.path}" '
  //       '-vf "scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:(ow-iw)/2:(oh-ih)/2:color=0x00000000" '
  //       '-vcodec libwebp -lossless 1 -y "$tempPath"',
  //     );
  //
  //     final result = await platform.invokeMethod('saveWebPToWhatsApp', {
  //       'filePath': tempPath,
  //       'fileName': '$fileName.webp',
  //     });
  //
  //     debugPrint('Saved WebP to WhatsApp: $result');
  //   } on PlatformException catch (e) {
  //     debugPrint('Error saving WebP: ${e.message}');
  //   } catch (e) {
  //     debugPrint('Unexpected error: $e');
  //   } finally {
  //     state = state.copyWith(isSaving: false, editedFile: null);
  //   }
  // }
}

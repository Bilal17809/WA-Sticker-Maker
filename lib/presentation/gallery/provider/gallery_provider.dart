import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'gallery_state.dart';

class GalleryProvider extends Notifier<GalleryState> {
  @override
  GalleryState build() => const GalleryState();
  final _picker = ImagePicker();
  static const platform = MethodChannel('wa_sticker_maker/saveSticker');

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = state.copyWith(imageFile: File(pickedFile.path));
    }
  }

  Future<void> saveAsWebP(String fileName) async {
    if (state.imageFile == null) return;
    state = state.copyWith(isSaving: true);

    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName.webp';
      await FFmpegKit.execute(
        '-i "${state.imageFile!.path}" -vcodec libwebp -lossless 1 "$tempPath"',
      );
      final result = await platform.invokeMethod('saveWebPToDCIM', {
        'filePath': tempPath,
        'fileName': '$fileName.webp',
      });
      debugPrint('!!!!!!!!!!!!!!! Sticker saved: $result');
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      debugPrint('!!!!!!!!!!!!!!!!!!! Error saving WebP: $e');
    }
  }

  void clearImage() {
    state = const GalleryState();
  }
}

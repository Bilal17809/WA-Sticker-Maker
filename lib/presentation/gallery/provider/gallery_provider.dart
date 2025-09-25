import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
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
      final file = File(pickedFile.path);
      state = state.copyWith(originalFile: file, editedFile: file);
    }
  }

  Future<void> rotate() async {
    final input = state.editedFile ?? state.originalFile;
    if (input == null) return;
    final tempDir = await getTemporaryDirectory();
    final tempPath =
        '${tempDir.path}/rotate_${DateTime.now().millisecondsSinceEpoch}.png';
    await FFmpegKit.execute(
      '-i "${input.path}" -vf "transpose=1,format=rgba" -y "$tempPath"',
    );
    state = state.copyWith(editedFile: File(tempPath));
  }

  Future<void> applyMask(File maskFile) async {
    final input = state.editedFile ?? state.originalFile;
    if (input == null) return;
    final tempDir = await getTemporaryDirectory();
    final outputPath =
        '${tempDir.path}/masked_${DateTime.now().millisecondsSinceEpoch}.png';
    final command =
        '-i "${input.path}" -i "${maskFile.path}" -filter_complex "[0][1]alphamerge" -y "$outputPath"';
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      state = state.copyWith(editedFile: File(outputPath));
      debugPrint('!!!!!!!!Mask applied successfully: $outputPath');
    } else {
      final logs = await session.getAllLogsAsString();
      debugPrint('!!!!!!!!!!!Failed to apply mask. Logs: $logs');
    }
  }

  Future<void> saveAsWebP(String fileName) async {
    if (state.editedFile == null) return;
    state = state.copyWith(isSaving: true);
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName.webp';
      await FFmpegKit.execute(
        '-i "${state.editedFile!.path}" -vcodec libwebp -lossless 1 -y "$tempPath"',
      );
      final result = await platform.invokeMethod('saveWebPToDCIM', {
        'filePath': tempPath,
        'fileName': '$fileName.webp',
      });
      debugPrint('!!!!!!!!!!! Final saved: $result');
    } catch (e) {
      debugPrint('!!!!!!!!!! Error saving final: $e');
    }
    state = state.copyWith(isSaving: false, editedFile: null);
  }
}

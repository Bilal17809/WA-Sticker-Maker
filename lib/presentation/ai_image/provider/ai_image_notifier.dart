import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/config/client.dart';
import '/core/services/services.dart';
import '/core/utils/utils.dart';
import '/data/data_source/freepik_data_source.dart';
import '/data/repo_impl/freepik_repo_impl.dart';
import '/domain/use_cases/get_freepik_image.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/providers/providers.dart';
import 'ai_image_state.dart';

class AIImageNotifier extends Notifier<AiImageState> {
  late final GetFreepikImage _getFreepikImage;
  late final StickerConversionService _converter;

  @override
  AiImageState build() {
    final dataSource = FreepikDataSource(freepikApiKey);
    final repo = FreepikRepoImpl(dataSource);
    _getFreepikImage = GetFreepikImage(repo);
    _converter = StickerConversionService();

    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((isConnected) {
        state = state.copyWith(isConnected: isConnected);
      });
    });

    return const AiImageState();
  }

  Future<void> generate(
    String prompt, {
    String? aspectRatio,
    String modelPath = '/ai/text-to-image',
  }) async {
    state = state.copyWith(isLoading: true, error: null, prompt: prompt);
    try {
      final response = await _getFreepikImage.generate(
        prompt: prompt,
        aspectRatio: aspectRatio,
        modelPath: modelPath,
      );
      if (response.generated.isEmpty) {
        _setError('No images returned from Server');
        return;
      }
      _updateWithGeneratedImages(response.generated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _updateWithGeneratedImages(List<String> newImages) {
    state = state.copyWith(
      isLoading: false,
      images: [...state.images, ...newImages],
    );
  }

  void _setError(String message) {
    state = state.copyWith(isLoading: false, error: message);
  }

  void selectImage(int index) {
    final selection = Set<int>.from(state.selectedImageIndices);
    selection.contains(index) ? selection.remove(index) : selection.add(index);
    state = state.copyWith(selectedImageIndices: selection);
  }

  Future<bool> downloadAndAddToPack(AiPacksState pack) async {
    if (state.selectedImageIndices.isEmpty) return false;

    final selectedImages = state.selectedImageIndices
        .map((index) => state.images[index])
        .toList();

    if (selectedImages.isEmpty) return false;

    state = state.copyWith(isDownloading: true);

    try {
      final paths = await _downloadAndConvertImages(
        selectedImages,
        pack.directoryPath,
      );

      if (paths.isNotEmpty) {
        _updatePack(pack, paths);
      }

      state = state.copyWith(selectedImageIndices: {});
      return paths.isNotEmpty;
    } catch (e) {
      state = state.copyWith(error: 'Error downloading images: $e');
      return false;
    } finally {
      state = state.copyWith(isDownloading: false);
    }
  }

  Future<List<String>> _downloadAndConvertImages(
    List<String> base64Images,
    String targetDirectory,
  ) async {
    final dir = Directory(targetDirectory);
    if (!await dir.exists()) await dir.create(recursive: true);

    final paths = <String>[];

    for (int i = 0; i < base64Images.length; i++) {
      try {
        final bytes = Base64Utils.maybeDecode(base64Images[i]);
        if (bytes == null) continue;

        final ts = DateTime.now().millisecondsSinceEpoch;
        final tempPath = '$targetDirectory/temp_$ts$i.png';
        final tempFile = File(tempPath)..createSync(recursive: true);
        await tempFile.writeAsBytes(bytes);

        final outPath = '$targetDirectory/ai_sticker_$ts$i.webp';
        final converted = await _converter.convertFileToWebP512(
          tempFile,
          outPath,
        );

        if (converted != null) {
          try {
            await tempFile.delete();
          } catch (_) {}
          paths.add(converted);
        } else {
          paths.add(tempPath);
        }
      } catch (_) {}
    }

    return paths;
  }

  void _updatePack(AiPacksState pack, List<String> paths) {
    final packNotifier = ref.read(aiPacksProvider.notifier);
    final index = packNotifier.state.indexWhere(
      (p) => p.directoryPath == pack.directoryPath,
    );

    if (index == -1) return;

    final current = packNotifier.state[index];
    final updated = current.copyWith(
      stickerPaths: [...current.stickerPaths, ...paths],
      trayImagePath: current.stickerPaths.isEmpty
          ? paths.first
          : current.trayImagePath,
    );

    packNotifier.updatePack(index, updated);
  }

  void clear() {
    state = const AiImageState();
  }
}

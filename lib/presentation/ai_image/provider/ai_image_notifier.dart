import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/helper/helper.dart';
import '/core/config/client.dart';
import '/core/services/services.dart';
import '/data/data_source/freepik_data_source.dart';
import '/data/repo_impl/freepik_repo_impl.dart';
import '/domain/use_cases/get_freepik_image.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/providers/providers.dart';
import 'ai_image_state.dart';

class AIImageNotifier extends Notifier<AiImageState> {
  late final AiImageService _aiImageService;
  late final StickerConversionService _converter;

  @override
  AiImageState build() {
    final ds = FreepikDataSource(freepikApiKey);
    final repo = FreepikRepoImpl(ds);
    _aiImageService = AiImageService(GetFreepikImage(repo));
    _converter = StickerConversionService();
    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (p, n) {
      n.whenData((v) => state = state.copyWith(isConnected: v));
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
      final gen = await _aiImageService.generate(
        prompt,
        aspectRatio: aspectRatio,
        modelPath: modelPath,
      );
      state = state.copyWith(
        isLoading: false,
        images: [...state.images, ...gen],
      );
    } on AiImageException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectImage(int index) {
    final s = Set<int>.from(state.selectedImageIndices);
    s.contains(index) ? s.remove(index) : s.add(index);
    state = state.copyWith(selectedImageIndices: s);
  }

  Future<bool> downloadAndAddToPack(AiPacksState pack) async {
    if (state.selectedImageIndices.isEmpty) return false;
    final selectedImages = state.selectedImageIndices
        .map((index) => state.images[index])
        .toList();
    if (selectedImages.isEmpty) return false;
    state = state.copyWith(isDownloading: true);
    try {
      final paths = await _converter.convertBase64ToWebp(
        selectedImages,
        pack.directoryPath,
      );
      if (paths.isNotEmpty) _updatePack(pack, paths);
      state = state.copyWith(selectedImageIndices: {});
      return paths.isNotEmpty;
    } catch (e) {
      state = state.copyWith(error: 'Error downloading images: $e');
      return false;
    } finally {
      state = state.copyWith(isDownloading: false);
    }
  }

  void _updatePack(AiPacksState pack, List<String> paths) {
    final packNotifier = ref.read(aiPacksProvider.notifier);
    ApiPackHelper.updatePackGeneric<AiPacksState>(
      ref: ref,
      state: packNotifier.state,
      onUpdate: packNotifier.updatePack,
      pack: pack,
      paths: paths,
    );
  }

  void clear() => state = const AiImageState();
}

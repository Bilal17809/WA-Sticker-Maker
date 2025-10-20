import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/local_storage/local_storage.dart';
import '/core/helper/helper.dart';
import '/core/config/client.dart';
import '/core/services/services.dart';
import '/data/data_source/freepik_data_source.dart';
import '/data/repo_impl/freepik_repo_impl.dart';
import '/domain/use_cases/get_freepik_image.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/providers/providers.dart';
import '/core/utils/utils.dart';
import 'ai_image_state.dart';

class AIImageNotifier extends Notifier<AiImageState> {
  late final AiImageService _aiImageService;
  late final StickerConversionService _converter;
  late final LocalStorage _localStorage;
  static const _genCountKey = 'generation_count';

  @override
  AiImageState build() {
    ref.read(splashInterstitialManagerProvider.notifier).loadAd();
    final ds = FreepikDataSource(freepikApiKey);
    final repo = FreepikRepoImpl(ds);
    _aiImageService = AiImageService(GetFreepikImage(repo));
    _converter = StickerConversionService();
    _localStorage = ref.read(localStorageProvider);
    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (p, n) {
      n.whenData((v) => state = state.copyWith(isConnected: v));
    });
    return const AiImageState();
  }

  Future<void> generate(
    String prompt, {
    String? aspectRatio,
    String modelPath = '/ai/text-to-image',
    BuildContext? context,
  }) async {
    final count = await _localStorage.getInt(_genCountKey) ?? 0;
    if (context != null && !context.mounted) {
      return;
    }
    final proceed = await _showGenerationDialog(context, count);
    if (!proceed) return;
    state = state.copyWith(isLoading: true, error: null, prompt: prompt);
    try {
      final updatedCount = await _localStorage.getInt(_genCountKey) ?? 0;
      if (updatedCount < 3) {
        await _incrementGenerationCount(updatedCount);
        await _performGeneration(prompt, aspectRatio, modelPath);
      } else {
        await _handleAdFlow(prompt, aspectRatio, modelPath);
      }
    } on AiImageException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> _showGenerationDialog(BuildContext? context, int count) async {
    if (context == null) return true;
    final localContext = context;
    if (!localContext.mounted) return false;
    return await GenerationLimitDialog.show(
          localContext,
          availableGenerations: count,
          limit: 3,
        ) ??
        false;
  }

  Future<void> _incrementGenerationCount(int count) async {
    await _localStorage.setInt(_genCountKey, count + 1);
  }

  Future<void> _performGeneration(
    String prompt,
    String? aspectRatio,
    String modelPath,
  ) async {
    final gen = await _aiImageService.generate(
      prompt,
      aspectRatio: aspectRatio,
      modelPath: modelPath,
    );
    state = state.copyWith(isLoading: false, images: [...state.images, ...gen]);
  }

  Future<void> _handleAdFlow(
    String prompt,
    String? aspectRatio,
    String modelPath,
  ) async {
    final splashAdManager = ref.read(
      splashInterstitialManagerProvider.notifier,
    );
    splashAdManager.loadAd();
    final splashAdState = ref.read(splashInterstitialManagerProvider);
    if (splashAdState.isAdReady) {
      final adShown = await splashAdManager.showSplashAd();
      if (adShown) {
        await _performGeneration(prompt, aspectRatio, modelPath);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Ad failed to show. Please try again.',
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Ad is not ready yet. Please try again in a moment.',
      );
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

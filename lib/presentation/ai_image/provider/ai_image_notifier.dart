import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/config/client.dart';
import '/data/data_source/freepik_data_source.dart';
import '/data/repo_impl/freepik_repo_impl.dart';
import '/domain/use_cases/get_freepik_image.dart';
import 'ai_image_state.dart';

class AIImageNotifier extends Notifier<AiImageState> {
  late final GetFreepikImage _getFreepikImage;

  @override
  AiImageState build() {
    final dataSource = FreepikDataSource(freepikApiKey);
    final repo = FreepikRepoImpl(dataSource);
    _getFreepikImage = GetFreepikImage(repo);
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

  void clear() {
    state = const AiImageState();
  }
}

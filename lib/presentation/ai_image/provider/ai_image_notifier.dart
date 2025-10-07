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
    int maxPollAttempts = 20,
    Duration pollInterval = const Duration(seconds: 2),
  }) async {
    state = state.copyWith(isLoading: true, error: null, prompt: prompt);
    try {
      final resp = await _getFreepikImage.generate(
        prompt: prompt,
        aspectRatio: aspectRatio,
        modelPath: modelPath,
      );
      if (resp.generated.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          images: [...state.images, ...resp.generated],
        );
        return;
      }
      final taskId = resp.taskId;
      if (taskId == null) {
        state = state.copyWith(isLoading: false, error: 'No images returned');
        return;
      }
      state = state.copyWith(taskId: taskId);
      for (var attempt = 0; attempt < maxPollAttempts; attempt++) {
        await Future.delayed(pollInterval);
        final taskResp = await _getFreepikImage.taskStatus(
          taskId: taskId,
          taskPath: modelPath,
        );
        if (taskResp.generated.isNotEmpty) {
          state = state.copyWith(
            isLoading: false,
            images: [...state.images, ...taskResp.generated],
            taskId: null,
          );
          return;
        }
        final status = (taskResp.status ?? '').toLowerCase();
        if (status == 'error' || status == 'failed') {
          state = state.copyWith(
            isLoading: false,
            error: 'Generation failed',
            taskId: null,
          );
          return;
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: 'Generation timed out',
        taskId: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = const AiImageState();
  }
}

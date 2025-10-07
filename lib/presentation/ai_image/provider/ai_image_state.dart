import 'package:flutter/foundation.dart';

@immutable
class AiImageState {
  final bool isLoading;
  final List<String> images;
  final String? taskId;
  final String? error;
  final String prompt;

  const AiImageState({
    this.isLoading = false,
    this.images = const [],
    this.taskId,
    this.error,
    this.prompt = '',
  });

  AiImageState copyWith({
    bool? isLoading,
    List<String>? images,
    String? taskId,
    String? error,
    String? prompt,
  }) {
    return AiImageState(
      isLoading: isLoading ?? this.isLoading,
      images: images ?? this.images,
      taskId: taskId ?? this.taskId,
      error: error ?? this.error,
      prompt: prompt ?? this.prompt,
    );
  }
}

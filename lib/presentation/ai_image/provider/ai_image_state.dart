import 'package:flutter/foundation.dart';

@immutable
class AiImageState {
  final bool isLoading;
  final List<String> images;
  final String? error;
  final String prompt;

  const AiImageState({
    this.isLoading = false,
    this.images = const [],
    this.error,
    this.prompt = '',
  });

  AiImageState copyWith({
    bool? isLoading,
    List<String>? images,
    String? error,
    String? prompt,
  }) {
    return AiImageState(
      isLoading: isLoading ?? this.isLoading,
      images: images ?? this.images,
      error: error ?? this.error,
      prompt: prompt ?? this.prompt,
    );
  }
}

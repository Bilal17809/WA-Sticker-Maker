import 'package:flutter/foundation.dart';

@immutable
class AiImageState {
  final bool isConnected;
  final bool isLoading;
  final bool isDownloading;
  final List<String> images;
  final String? error;
  final String prompt;
  final Set<int> selectedImageIndices;

  const AiImageState({
    this.isConnected = true,
    this.isLoading = false,
    this.isDownloading = false,
    this.images = const [],
    this.error,
    this.prompt = '',
    this.selectedImageIndices = const {},
  });

  AiImageState copyWith({
    bool? isConnected,
    bool? isLoading,
    bool? isDownloading,
    List<String>? images,
    String? error,
    String? prompt,
    Set<int>? selectedImageIndices,
  }) {
    return AiImageState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      isDownloading: isDownloading ?? this.isDownloading,
      images: images ?? this.images,
      error: error ?? this.error,
      prompt: prompt ?? this.prompt,
      selectedImageIndices: selectedImageIndices ?? this.selectedImageIndices,
    );
  }
}

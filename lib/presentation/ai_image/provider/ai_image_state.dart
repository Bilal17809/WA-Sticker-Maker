import 'package:flutter/foundation.dart';
import '/core/common_widgets/base_state.dart';

@immutable
class AiImageState extends BaseState {
  final bool isConnected;
  final bool isDownloading;
  final List<String> images;
  final String? error;
  final String prompt;
  final Set<int> selectedImageIndices;

  const AiImageState({
    this.isConnected = true,
    this.isDownloading = false,
    this.images = const [],
    this.error,
    this.prompt = '',
    this.selectedImageIndices = const {},
    bool isLoading = false,
    bool isSuccess = false,
    bool isFailure = false,
  }) : super();

  AiImageState copyWith({
    bool? isConnected,
    bool? isLoading,
    bool? isSuccess,
    bool? isFailure,
    bool? isDownloading,
    List<String>? images,
    String? error,
    String? prompt,
    Set<int>? selectedImageIndices,
  }) {
    return AiImageState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isDownloading: isDownloading ?? this.isDownloading,
      images: images ?? this.images,
      error: error ?? this.error,
      prompt: prompt ?? this.prompt,
      selectedImageIndices: selectedImageIndices ?? this.selectedImageIndices,
    );
  }
}

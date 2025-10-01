import 'package:flutter/foundation.dart';
import '/data/models/sticker_response_model.dart';

@immutable
class LibraryState {
  final bool isLoading;
  final bool isLoadingMore;
  final StickerResponseModel? stickerResponse;
  final String? errorMessage;

  const LibraryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.stickerResponse,
    this.errorMessage,
  });

  bool get hasMore => stickerResponse?.hasNext ?? false;

  LibraryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    StickerResponseModel? stickerResponse,
    String? errorMessage,
  }) {
    return LibraryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      stickerResponse: stickerResponse ?? this.stickerResponse,
      errorMessage: errorMessage,
    );
  }
}

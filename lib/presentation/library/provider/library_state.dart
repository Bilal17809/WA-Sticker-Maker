import 'package:flutter/foundation.dart';
import '/core/common_widgets/common_widgets.dart';
import '/data/models/sticker_response_model.dart';

@immutable
class LibraryState {
  final bool isConnected;
  final bool initialLoadDone;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isDownloading;
  final StickerResponseModel? stickerResponse;
  final String? errorMessage;
  final Set<String> selectedStickerIds;

  const LibraryState({
    this.isConnected = true,
    this.initialLoadDone = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isDownloading = false,
    this.stickerResponse,
    this.errorMessage,
    this.selectedStickerIds = const {},
  });

  bool get hasMore => stickerResponse?.hasNext ?? false;

  LibraryState copyWith({
    bool? isConnected,
    bool? initialLoadDone,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isDownloading,
    StickerResponseModel? stickerResponse,
    String? errorMessage,
    Set<String>? selectedStickerIds,
  }) {
    return LibraryState(
      isConnected: isConnected ?? this.isConnected,
      initialLoadDone: initialLoadDone ?? this.initialLoadDone,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isDownloading: isDownloading ?? this.isDownloading,
      stickerResponse: stickerResponse ?? this.stickerResponse,
      errorMessage: errorMessage,
      selectedStickerIds: selectedStickerIds ?? this.selectedStickerIds,
    );
  }
}

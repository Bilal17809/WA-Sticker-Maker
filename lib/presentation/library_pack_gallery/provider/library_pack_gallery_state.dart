import 'package:flutter/foundation.dart';

@immutable
class LibraryPackGalleryState {
  final bool isExporting;
  final String? lastMessage;
  const LibraryPackGalleryState({this.isExporting = false, this.lastMessage});

  LibraryPackGalleryState copyWith({
    bool? isExporting,
    String? Function()? lastMessage,
  }) {
    return LibraryPackGalleryState(
      isExporting: isExporting ?? this.isExporting,
      lastMessage: lastMessage != null ? lastMessage() : this.lastMessage,
    );
  }
}

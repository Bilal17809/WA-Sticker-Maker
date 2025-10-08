import 'package:flutter/foundation.dart';

@immutable
class AiPackGalleryState {
  final bool isExporting;
  final String? lastMessage;

  const AiPackGalleryState({this.isExporting = false, this.lastMessage});

  AiPackGalleryState copyWith({
    bool? isExporting,
    String? Function()? lastMessage,
  }) {
    return AiPackGalleryState(
      isExporting: isExporting ?? this.isExporting,
      lastMessage: lastMessage != null ? lastMessage() : this.lastMessage,
    );
  }
}

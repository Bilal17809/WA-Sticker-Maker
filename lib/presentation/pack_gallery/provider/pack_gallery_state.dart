class PackGalleryState {
  final bool isExporting;
  final String? lastMessage;

  const PackGalleryState({this.isExporting = false, this.lastMessage});

  PackGalleryState copyWith({
    bool? isExporting,
    String? Function()? lastMessage,
  }) {
    return PackGalleryState(
      isExporting: isExporting ?? this.isExporting,
      lastMessage: lastMessage != null ? lastMessage() : this.lastMessage,
    );
  }
}

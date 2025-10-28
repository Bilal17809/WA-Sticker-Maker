class BuiltInPacksGalleryState {
  final int currentIndex;
  const BuiltInPacksGalleryState({this.currentIndex = 0});

  BuiltInPacksGalleryState copyWith({int? currentIndex}) =>
      BuiltInPacksGalleryState(currentIndex: currentIndex ?? this.currentIndex);
}

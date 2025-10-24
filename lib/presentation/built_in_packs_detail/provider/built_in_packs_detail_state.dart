class BuiltInPacksDetailState {
  final int currentIndex;
  const BuiltInPacksDetailState({this.currentIndex = 0});

  BuiltInPacksDetailState copyWith({int? currentIndex}) =>
      BuiltInPacksDetailState(currentIndex: currentIndex ?? this.currentIndex);
}

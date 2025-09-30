import 'package:flutter/foundation.dart';

@immutable
class HomeState {
  final bool isDrawerOpen;
  final int selectedIndex;
  const HomeState({this.isDrawerOpen = false, this.selectedIndex = 0});

  HomeState copyWith({bool? isDrawerOpen, int? selectedIndex}) {
    return HomeState(
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

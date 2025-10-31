import 'package:flutter/foundation.dart';

@immutable
class HomeState {
  final bool isDrawerOpen;
  const HomeState({this.isDrawerOpen = false});

  HomeState copyWith({bool? isDrawerOpen}) {
    return HomeState(
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
    );
  }

}

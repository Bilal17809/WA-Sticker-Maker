import 'package:flutter/foundation.dart';

@immutable
class SplashState {
  final bool isLoading;
  final bool showButton;

  const SplashState({this.isLoading = true, this.showButton = false});

  SplashState copyWith({bool? isLoading, bool? showButton}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      showButton: showButton ?? this.showButton,
    );
  }
}

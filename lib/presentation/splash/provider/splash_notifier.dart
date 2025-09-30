import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'splash_state.dart';

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() {
    _init();
    return const SplashState(isLoading: true, showButton: false);
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false, showButton: true);
  }
}

final splashProvider = NotifierProvider<SplashNotifier, SplashState>(
  () => SplashNotifier(),
);

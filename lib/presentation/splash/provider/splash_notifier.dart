import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/providers/providers.dart';
import 'splash_state.dart';

class SplashNotifier extends Notifier<SplashState> {
  Timer? _typewriterTimer;

  @override
  SplashState build() {
    ref.read(splashInterstitialManagerProvider.notifier).loadAd();
    _init();
    _startTypewriter();

    ref.onDispose(() {
      _typewriterTimer?.cancel();
    });
    return const SplashState(isLoading: true, showButton: false);
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 4));
    state = state.copyWith(isLoading: false, showButton: true);
  }

  void _startTypewriter() {
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (state.visibleLetters < state.titleText.length) {
        state = state.copyWith(visibleLetters: state.visibleLetters + 1);
      } else {
        timer.cancel();
      }
    });
  }
}

import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/providers/providers.dart';
import '/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/global_keys/global_key.dart';

class InterstitialAdState {
  final bool isAdReady;
  final bool isShow;
  final int visitCounter;
  final int displayThreshold;

  InterstitialAdState({
    this.isAdReady = false,
    this.isShow = false,
    this.visitCounter = 0,
    this.displayThreshold = 3,
  });

  InterstitialAdState copyWith({
    bool? isAdReady,
    bool? isShow,
    int? visitCounter,
    int? displayThreshold,
  }) {
    return InterstitialAdState(
      isAdReady: isAdReady ?? this.isAdReady,
      isShow: isShow ?? this.isShow,
      visitCounter: visitCounter ?? this.visitCounter,
      displayThreshold: displayThreshold ?? this.displayThreshold,
    );
  }
}

class InterstitialAdManager extends Notifier<InterstitialAdState> {
  InterstitialAd? _currentAd;

  @override
  InterstitialAdState build() {
    ref.keepAlive();
    ref.onDispose(() {
      _currentAd?.dispose();
    });
    final previous = stateOrNull ?? InterstitialAdState();
    _initRemoteConfig();
    _loadAd();
    return previous;
  }

  Future<void> _initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );
      final interstitialKey = RemoteConfigKeyUtil(
        androidKey: androidRCKeyInterstitialAd,
        iosKey: iosRCKeyInterstitialAd,
      ).remoteConfigKey;
      await remoteConfig.fetchAndActivate();
      final newThreshold = remoteConfig.getInt(interstitialKey);
      if (newThreshold > 0) {
        state = state.copyWith(displayThreshold: newThreshold);
      }
    } catch (_) {}
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: AdIdUtil(
        androidIdVal: testInterstitialAdUnitIdVal,
        iosIdVal: iosInterstitialAdUnitIdVal,
      ).adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _currentAd = ad;
          state = state.copyWith(isAdReady: true);
        },
        onAdFailedToLoad: (error) {
          state = state.copyWith(isAdReady: false);
        },
      ),
    );
  }

  Future<bool> _showAdInternal() {
    final removeAds = ref.read(removeAdsProvider);
    if (removeAds.isSubscribed) {
      return Future.value(true);
    }
    if (_currentAd == null) {
      return Future.value(false);
    }
    final completer = Completer<bool>();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    state = state.copyWith(isShow: true);
    final appOpenAdManager = ref.read(appOpenAdManagerProvider.notifier);
    _currentAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        appOpenAdManager.setInterstitialAdDismissed();
        ad.dispose();
        state = state.copyWith(isShow: false);
        _resetAfterAd();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        appOpenAdManager.setInterstitialAdDismissed();
        ad.dispose();
        state = state.copyWith(isShow: false);
        _resetAfterAd();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    _currentAd!.show();
    _currentAd = null;
    state = state.copyWith(isAdReady: false);
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => false,
    );
  }

  void checkAndDisplayAd() {
    final newCounter = state.visitCounter + 1;
    state = state.copyWith(visitCounter: newCounter);
    if (newCounter >= state.displayThreshold) {
      if (state.isAdReady) {
        _showAdInternal();
      } else {
        state = state.copyWith(visitCounter: 0);
      }
    }
  }

  void _resetAfterAd() {
    state = state.copyWith(visitCounter: 0, isAdReady: false);
    _loadAd();
  }
}

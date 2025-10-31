import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/global_keys/global_key.dart';
import '/core/constants/constants.dart';
import '/core/exceptions/app_exceptions.dart';
import '/core/providers/providers.dart';
import '/core/utils/utils.dart';

class SplashInterstitialState {
  final bool isAdReady;
  final bool displaySplashAd;

  SplashInterstitialState({
    this.isAdReady = false,
    this.displaySplashAd = true,
  });

  SplashInterstitialState copyWith({bool? isAdReady, bool? displaySplashAd}) {
    return SplashInterstitialState(
      isAdReady: isAdReady ?? this.isAdReady,
      displaySplashAd: displaySplashAd ?? this.displaySplashAd,
    );
  }
}

class SplashInterstitialManager extends Notifier<SplashInterstitialState> {
  InterstitialAd? _splashAd;

  @override
  SplashInterstitialState build() {
    ref.onDispose(() {
      _splashAd?.dispose();
    });
    _initRemoteConfig();
    loadAd();
    return SplashInterstitialState();
  }

  Future<void> _initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      final splashAdKey = RemoteConfigKeyUtil(
        androidKey: androidRCKeySplashAd,
        iosKey: iosRCKeySplashAd,
      ).remoteConfigKey;

      await remoteConfig.fetchAndActivate();
      final displaySplashAd = remoteConfig.getBool(splashAdKey);
      state = state.copyWith(displaySplashAd: displaySplashAd);
      loadAd();
    } catch (e) {
      debugPrint('${AppExceptions().remoteConfigError}: $e');
      state = state.copyWith(displaySplashAd: false);
    }
  }

  void loadAd() {
    InterstitialAd.load(
      adUnitId: AdIdUtil(
        androidIdVal: testInterstitialAdUnitIdVal,
        iosIdVal: iosSplashAdUnitIdVal,
      ).adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _splashAd = ad;
          state = state.copyWith(isAdReady: true);
        },
        onAdFailedToLoad: (error) {
          state = state.copyWith(isAdReady: false);
          debugPrint(
            '!!!!!!!!!!!!Splash InterstitialAd failed to load: $error',
          );
        },
      ),
    );
  }

  Future<bool> showSplashAd() async {
    final removeAds = ref.read(removeAdsProvider);
    if (!state.isAdReady || removeAds.isSubscribed) {
      debugPrint('!!!!!!!!!!Splash InterstitialAd not ready');
      return false;
    }

    final completer = Completer<bool>();

    if (_splashAd != null) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      final appOpenAdManager = ref.read(appOpenAdManagerProvider.notifier);

      _splashAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint('!!!!!!!!! Splash InterstitialAd displayed successfully');
        },
        onAdDismissedFullScreenContent: (ad) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          appOpenAdManager.setInterstitialAdDismissed();
          ad.dispose();
          state = state.copyWith(isAdReady: false);
          loadAd();
          completer.complete(true);
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          debugPrint("!!!!!!!!!!! Splash Interstitial failed: $error");
          appOpenAdManager.setInterstitialAdDismissed();
          ad.dispose();
          state = state.copyWith(isAdReady: false);
          loadAd();
          completer.complete(false);
        },
      );

      _splashAd!.show();
      _splashAd = null;
      state = state.copyWith(isAdReady: false);
    } else {
      debugPrint('!!!!!!!!!!Splash InterstitialAd is null');
      completer.complete(false);
    }

    return completer.future;
  }
}

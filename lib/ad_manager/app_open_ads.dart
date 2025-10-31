import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/providers/providers.dart';
import '/core/exceptions/app_exceptions.dart';
import '/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/global_keys/global_key.dart';

class AppOpenAdState {
  final bool isAdVisible;
  final bool isCooldownActive;
  final bool shouldShowAppOpenAd;
  final bool isAppResumed;

  AppOpenAdState({
    this.isAdVisible = false,
    this.isCooldownActive = false,
    this.shouldShowAppOpenAd = true,
    this.isAppResumed = false,
  });

  AppOpenAdState copyWith({
    bool? isAdVisible,
    bool? isCooldownActive,
    bool? shouldShowAppOpenAd,
    bool? isAppResumed,
  }) {
    return AppOpenAdState(
      isAdVisible: isAdVisible ?? this.isAdVisible,
      isCooldownActive: isCooldownActive ?? this.isCooldownActive,
      shouldShowAppOpenAd: shouldShowAppOpenAd ?? this.shouldShowAppOpenAd,
      isAppResumed: isAppResumed ?? this.isAppResumed,
    );
  }
}

class AppOpenAdManager extends Notifier<AppOpenAdState>
    with WidgetsBindingObserver {
  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool _interstitialAdDismissed = false;
  bool _openAppAdEligible = false;
  bool _isSplashInterstitialShown = false;

  @override
  AppOpenAdState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _appOpenAd?.dispose();
    });
    _initRemoteConfig();
    return AppOpenAdState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _openAppAdEligible = true;
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_openAppAdEligible && !_interstitialAdDismissed) {
          showAdIfAvailable();
        } else {
          debugPrint("!!!!!!!!!!!!Skipping Open App Ad");
        }
        _openAppAdEligible = false;
        _interstitialAdDismissed = false;
      });
    }
  }

  Future<void> _initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      );
      final appOpenKey = RemoteConfigKeyUtil(
        androidKey: androidRCKeyAppOpenAd,
        iosKey: iosRCKeyAppOpenAd,
      ).remoteConfigKey;
      await remoteConfig.fetchAndActivate();
      final showAd = remoteConfig.getBool(appOpenKey);
      if (showAd) {
        loadAd();
      }
    } catch (e) {
      debugPrint('${AppExceptions().remoteConfigError}: $e');
    }
  }

  void showAdIfAvailable() {
    final removeAds = ref.read(removeAdsProvider);
    if (removeAds.isSubscribed) {
      return;
    }
    if (_isAdAvailable && _appOpenAd != null && !state.isCooldownActive) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          state = state.copyWith(isAdVisible: true);
        },
        onAdDismissedFullScreenContent: (ad) {
          _appOpenAd = null;
          _isAdAvailable = false;
          state = state.copyWith(isAdVisible: false);
          loadAd();
          activateCooldown();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _appOpenAd = null;
          _isAdAvailable = false;
          state = state.copyWith(isAdVisible: false);
          loadAd();
        },
      );
      _appOpenAd!.show();
      _appOpenAd = null;
      _isAdAvailable = false;
    } else {
      loadAd();
    }
  }

  void activateCooldown() {
    state = state.copyWith(isCooldownActive: true);
    Future.delayed(const Duration(seconds: 5), () {
      state = state.copyWith(isCooldownActive: false);
    });
  }

  void loadAd() {
    final removeAds = ref.read(removeAdsProvider);
    if (removeAds.isSubscribed) {
      return;
    }
    if (!state.shouldShowAppOpenAd) return;
    AppOpenAd.load(
      adUnitId: AdIdUtil(
        androidIdVal: testAppOpenAdUnitIdVal,
        iosIdVal: iosAppOpenAdUnitIdVal,
      ).adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
        },
        onAdFailedToLoad: (error) {
          _isAdAvailable = false;
        },
      ),
    );
  }

  void setInterstitialAdDismissed() {
    _interstitialAdDismissed = true;
  }

  void setSplashInterstitialFlag(bool shown) {
    _isSplashInterstitialShown = shown;
  }

  void maybeShowAppOpenAd() {
    if (_isSplashInterstitialShown) {
      return;
    }
  }
}

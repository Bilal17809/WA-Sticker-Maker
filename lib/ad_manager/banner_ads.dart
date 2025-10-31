import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '/core/providers/providers.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/global_keys/global_key.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdEnabled = true;

  @override
  void initState() {
    super.initState();
    _initRemoteConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isAdEnabled && _bannerAd == null) {
      loadBannerAd();
    }
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
      final bannerAdKey = RemoteConfigKeyUtil(
        androidKey: androidRCKeyBannerAd,
        iosKey: iosRCKeyBannerAd,
      ).remoteConfigKey;
      await remoteConfig.fetchAndActivate();
      final showBanner = remoteConfig.getBool(bannerAdKey);
      if (!mounted) return;
      setState(() => _isAdEnabled = true);
      if (showBanner) {
        loadBannerAd();
      }
    } catch (e) {
      debugPrint('Error initializing remote config: $e');
    }
  }

  void loadBannerAd() async {
    AdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.sizeOf(context).width.truncate(),
        );
    _bannerAd = BannerAd(
      adUnitId: AdIdUtil(
        androidIdVal: testBannerAdUnitIdVal,
        iosIdVal: iosBannerAdUnitIdVal,
      ).adUnitId,
      size: adSize!,
      request: const AdRequest(extras: {'collapsible': 'bottom'}),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("!!!!!!!!!!! BannerAd loaded: ${ad.adUnitId}");
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('!!!!!!!!!!!!!!!!!! Banner Ad failed: ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appOpenAdState = ref.watch(appOpenAdManagerProvider);
    final removeAds = ref.watch(removeAdsProvider);
    final isDialogVisible = ref.watch(dialogVisibilityProvider);
    final interstitialState = ref.watch(interstitialAdManagerProvider);

    if (!_isAdEnabled ||
        removeAds.isSubscribed ||
        appOpenAdState.isAdVisible ||
        isDialogVisible ||
        interstitialState.isShow) {
      return const SizedBox();
    }

    return _isAdLoaded && _bannerAd != null
        ? SafeArea(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textGreyColor.withValues(alpha: 0.6),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
        : SafeArea(
            top: false,
            bottom: true,
            left: false,
            right: false,
            child: Shimmer.fromColors(
              baseColor: AppColors.secondary(context),
              highlightColor: AppColors.container(context),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.kBlack.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          );
  }
}

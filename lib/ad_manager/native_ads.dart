import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/constants.dart';
import '/core/utils/utils.dart';
import '/core/theme/theme.dart';
import 'package:shimmer/shimmer.dart';
import '/core/providers/providers.dart';
import '/core/global_keys/global_key.dart';

class NativeAdState {
  final bool isAdReady;
  final bool showAd;

  NativeAdState({this.isAdReady = false, this.showAd = false});

  NativeAdState copyWith({bool? isAdReady, bool? showAd}) {
    return NativeAdState(
      isAdReady: isAdReady ?? this.isAdReady,
      showAd: showAd ?? this.showAd,
    );
  }
}

class NativeAdManager extends Notifier<NativeAdState> {
  NativeAd? _nativeAd;
  final TemplateType templateType;

  NativeAdManager(this.templateType);

  @override
  NativeAdState build() {
    ref.onDispose(() {
      _nativeAd?.dispose();
    });
    _initRemoteConfig();
    return NativeAdState();
  }

  Future<void> _initRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      final key = RemoteConfigKeyUtil(
        androidKey: androidRCKeyNativeAd,
        iosKey: iosRCKeyNativeAd,
      ).remoteConfigKey;
      // final showAd = remoteConfig.getBool(key);
      final showAd = true;
      state = state.copyWith(showAd: showAd);
      if (showAd) {
        loadNativeAd();
      }
    } catch (_) {}
  }

  void loadNativeAd() {
    state = state.copyWith(isAdReady: false);
    _nativeAd = NativeAd(
      adUnitId: AdIdUtil(
        androidIdVal: testNativeAdUnitIdVal,
        iosIdVal: iosNativeAdUnitIdVal,
      ).adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _nativeAd = ad as NativeAd;
          state = state.copyWith(isAdReady: true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          state = state.copyWith(isAdReady: false);
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        mainBackgroundColor: Colors.white,
        templateType: templateType,
      ),
    );
    _nativeAd!.load();
  }

  NativeAd? get nativeAd => _nativeAd;
}

class NativeAdWidget extends ConsumerStatefulWidget {
  final TemplateType templateType;
  const NativeAdWidget({super.key, this.templateType = TemplateType.small});

  @override
  ConsumerState<NativeAdWidget> createState() => NativeAdWidgetState();
}

class NativeAdWidgetState extends ConsumerState<NativeAdWidget> {
  Widget shimmerSmallWidget(double width) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondary(context),
      highlightColor: AppColors.container(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary(context).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary(context).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.primary(
                          context,
                        ).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: AppColors.primary(
                          context,
                        ).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: AppColors.primary(
                          context,
                        ).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.primary(
                          context,
                        ).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmerMediumWidget(double width) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondary(context),
      highlightColor: AppColors.container(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary(context).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary(context).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: width,
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: width * 0.6,
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: width * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 36,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary(context).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appOpenAdState = ref.watch(appOpenAdManagerProvider);
    final removeAds = ref.watch(removeAdsProvider);
    final adState = ref.watch(nativeAdManagerProvider(widget.templateType));
    final adManager = ref.read(
      nativeAdManagerProvider(widget.templateType).notifier,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final adHeight = widget.templateType == TemplateType.medium
        ? screenHeight * 0.48
        : screenHeight * 0.14;
    final isDialogVisible = ref.watch(dialogVisibilityProvider);

    if (removeAds.isSubscribed ||
        appOpenAdState.isAdVisible ||
        isDialogVisible) {
      return const SizedBox();
    }

    if (adState.isAdReady && adManager.nativeAd != null) {
      return Container(
        height: adHeight,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: AdWidget(ad: adManager.nativeAd!),
      );
    } else {
      return SizedBox(
        height: adHeight,
        child: widget.templateType == TemplateType.medium
            ? shimmerMediumWidget(screenWidth)
            : shimmerSmallWidget(screenWidth),
      );
    }
  }
}

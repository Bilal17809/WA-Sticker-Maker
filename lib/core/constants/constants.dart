import 'package:flutter/material.dart';

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kGap = 8.0;

/// ========== Border ==========
const double kCircularBorderRadius = 50.0;
const double kBorderRadius = 35.0;

/// ========== Icon Sizes ==========
double primaryIcon(BuildContext context) => context.screenWidth * 0.25;
double secondaryIcon(BuildContext context) => context.screenWidth * 0.08;
double smallIcon(BuildContext context) => context.screenWidth * 0.06;

/// ========== MediaQuery Helpers ==========
extension MediaQueryValues on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

/// ========== Android Ad Unit Ids ==========
const String androidBannerAdUnitIdVal =
    'ca-app-pub-8172082069591999/1000945888';
const String androidSplashAdUnitIdVal =
    'ca-app-pub-8172082069591999/5320686037';
const String androidInterstitialAdUnitIdVal =
    'ca-app-pub-8172082069591999/6410212904';
const String androidAppOpenAdUnitIdVal =
    'ca-app-pub-8172082069591999/8687864213';
const String androidNativeAdUnitIdVal =
    'ca-app-pub-8172082069591999/1376543924';

/// ========== IOS Ad Unit Ids ==========
const String iosBannerAdUnitIdVal = 'ca-app-pub-5405847310750111/4954371440';
const String iosSplashAdUnitIdVal = 'ca-app-pub-5405847310750111/3641289775';
const String iosInterstitialAdUnitIdVal =
    'ca-app-pub-5405847310750111/9843736042';
const String iosAppOpenAdUnitIdVal = 'ca-app-pub-5405847310750111/1519551130';
const String iosNativeAdUnitIdVal = 'ca-app-pub-5405847310750111/3208037322';

/// ========== Test Ad Unit Ids ==========
const String testBannerAdUnitIdVal = 'ca-app-pub-3940256099942544/9214589741';
const String testInterstitialAdUnitIdVal =
    'ca-app-pub-3940256099942544/1033173712';
const String testAppOpenAdUnitIdVal = 'ca-app-pub-3940256099942544/9257395921';
const String testNativeAdUnitIdVal = 'ca-app-pub-3940256099942544/2247696110';

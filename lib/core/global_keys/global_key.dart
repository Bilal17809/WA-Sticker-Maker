import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> globalDrawerKey = GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormState>();

/// ============= Android Ad Remote Config Keys =============
const String androidRCKeyBannerAd = 'BannerAd';
const String androidRCKeySplashAd = 'SplashInterstitialAd';
const String androidRCKeyInterstitialAd = 'InterstitialAd';
const String androidRCKeyAppOpenAd = 'AppOpenAd';
const String androidRCKeyNativeAd = 'NativeAdvAd';

/// ============= IOS Ad Remote Config Keys =============
const String iosRCKeyBannerAd = 'BannerAd';
const String iosRCKeySplashAd = 'SplashInterstitialAd';
const String iosRCKeyInterstitialAd = 'InterstitialAd';
const String iosRCKeyAppOpenAd = 'AppOpenAd';
const String iosRCKeyNativeAd = 'NativeAdvAd';

import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '/core/exceptions/app_exceptions.dart';

class DrawerActions {
  static Future<void> privacy() async {
    const androidUrl = 'https://unisoftaps.blogspot.com/';
    const iosUrl = '';
    final url = Platform.isIOS ? iosUrl : androidUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw '${AppExceptions().failUrl}: $url';
    }
  }

  static Future<void> rateUs() async {
    const androidUrl =
        'https://play.google.com/store/apps/details?id=com.wastickers.stickermaker';
    const iosUrl = '';
    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw '${AppExceptions().failUrl}: $url';
    }
  }

  static Future<void> moreApp() async {
    const androidUrl =
        'https://play.google.com/store/apps/developer?id=Unisoft+Apps';
    const iosUrl = '';

    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw '${AppExceptions().failUrl}: $url';
    }
  }
}

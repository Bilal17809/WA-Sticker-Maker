import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '/core/common/app_exceptions.dart';

class DrawerActions {
  static Future<void> privacy() async {
    const androidUrl =
        'https://modernmobileschool.blogspot.com/2017/07/modern-school-privacy-policy.html';
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
        'https://play.google.com/store/apps/details?id=com.learnjapanese.japanesespeakingcourse';
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
        'https://play.google.com/store/apps/developer?id=Modern+School';
    const iosUrl = '';

    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw '${AppExceptions().failUrl}: $url';
    }
  }
}

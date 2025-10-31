import 'dart:io';
import '/core/exceptions/app_exceptions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalService {
  static Future<void> init() async {
    if (Platform.isAndroid) {
      OneSignal.initialize('d78cbd3b-48b2-41a1-8133-c938145e3275');
      await OneSignal.Notifications.requestPermission(true);
    } else if (Platform.isIOS) {
      OneSignal.initialize('');
      await OneSignal.Notifications.requestPermission(true);
    } else {
      throw Exception(AppExceptions.unsupportedPlatform);
    }
  }
}

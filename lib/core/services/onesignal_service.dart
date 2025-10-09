import 'dart:io';
import 'package:flutter/foundation.dart';
import '/core/common/app_exceptions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalService {
  static Future<void> init() async {
    if (Platform.isAndroid) {
      OneSignal.initialize('3264bcda-f704-44a1-b323-23cc4811dd4a');
      await OneSignal.Notifications.requestPermission(true);
    } else if (Platform.isIOS) {
      OneSignal.initialize('b6e253f3-3981-4d78-b9b5-a233f400859f');
      await OneSignal.Notifications.requestPermission(true);
    } else {
      debugPrint(AppExceptions().unsupportedPlatform);
    }
  }
}

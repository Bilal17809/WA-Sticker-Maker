import 'dart:io';
import '/core/exceptions/app_exceptions.dart';

class RemoteConfigKeyUtil {
  final String androidKey;
  final String iosKey;

  const RemoteConfigKeyUtil({required this.androidKey, required this.iosKey});

  String get remoteConfigKey {
    if (Platform.isAndroid) {
      return androidKey;
    } else if (Platform.isIOS) {
      return iosKey;
    } else {
      throw UnsupportedError(AppExceptions().unsupportedPlatform);
    }
  }
}

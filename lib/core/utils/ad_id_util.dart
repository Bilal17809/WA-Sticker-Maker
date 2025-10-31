import 'dart:io';
import '/core/exceptions/app_exceptions.dart';

class AdIdUtil {
  final String androidIdVal;
  final String iosIdVal;

  const AdIdUtil({required this.androidIdVal, required this.iosIdVal});

  String get adUnitId {
    if (Platform.isAndroid) {
      return androidIdVal;
    } else if (Platform.isIOS) {
      return iosIdVal;
    } else {
      throw UnsupportedError(AppExceptions().unsupportedPlatform);
    }
  }
}

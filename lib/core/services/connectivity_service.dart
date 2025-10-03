import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetStatusStreamProvider = StreamProvider.autoDispose<bool>((ref) {
  final connectivity = Connectivity();
  Stream<bool> connectivityStream() async* {
    Future<bool> verifyInternet() async {
      try {
        final result = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 5));
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }

    final initial = await connectivity.checkConnectivity();
    if (initial.contains(ConnectivityResult.none)) {
      yield false;
    } else {
      yield await verifyInternet();
    }
    await for (final event in connectivity.onConnectivityChanged) {
      if (event.contains(ConnectivityResult.none)) {
        yield false;
      } else {
        yield await verifyInternet();
      }
    }
  }

  return connectivityStream();
});

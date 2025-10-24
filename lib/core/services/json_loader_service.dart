import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class JsonLoaderService {
  Future<dynamic> loadJson(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final dynamic data = json.decode(jsonString);
      return data;
    } catch (e) {
      debugPrint('Error loading or parsing JSON asset at $assetPath: $e');
      rethrow;
    }
  }
}

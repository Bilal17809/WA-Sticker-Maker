import 'dart:convert';
import 'package:http/http.dart' as http;
import '/core/config/environment.dart';
import '/core/common/app_exceptions.dart';
import '/data/models/models.dart';

class KlipyDataSource {
  final String apiKey;
  KlipyDataSource(this.apiKey);

  Uri _uri(String path, [Map<String, String>? query]) => Uri.parse(
    '${EnvironmentConfig.klipyBaseUrl}/$apiKey$path',
  ).replace(queryParameters: query);

  Future<StickerResponseModel> trending({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final uri = _uri('/stickers/trending', {
        'page': page.toString(),
        'per_page': perPage.toString(),
      });
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return StickerResponseModel.fromJson(jsonData);
      } else {
        throw Exception(
          '${AppExceptions().failedApiCall}: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching trending stickers: $e');
    }
  }

  Future<StickerResponseModel> search(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final uri = _uri('/stickers/search', {
        'query': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      });
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return StickerResponseModel.fromJson(jsonData);
      } else {
        throw Exception(
          '${AppExceptions().failedApiCall}: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error searching stickers: $e');
    }
  }
}

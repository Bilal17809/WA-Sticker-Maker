import 'dart:convert';
import 'package:http/http.dart' as http;
import '/core/config/environment.dart';
import '/core/exceptions/app_exceptions.dart';
import '/data/models/models.dart';

class FreepikDataSource {
  final String apiKey;
  FreepikDataSource(this.apiKey);

  Uri _uri(String path, [Map<String, String>? query]) => Uri.parse(
    '${EnvironmentConfig.freepikBaseUrl}$path',
  ).replace(queryParameters: query);

  Future<FreepikModel> generateImage({
    required String prompt,
    String? aspectRatio,
    String modelPath = '/ai/text-to-image',
    Map<String, dynamic>? extraBody,
  }) async {
    try {
      final uri = _uri(modelPath);
      final body = <String, dynamic>{
        'prompt': prompt,
        if (aspectRatio != null) 'aspect_ratio': aspectRatio,
        if (extraBody != null) ...extraBody,
      };
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-freepik-api-key': apiKey,
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return FreepikModel.fromJson(jsonData);
      } else {
        throw Exception(
          '${AppExceptions.failedApiCall}: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error generating image');
    }
  }
}

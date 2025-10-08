import '/domain/use_cases/get_freepik_image.dart';

class AiImageException implements Exception {
  final String message;
  AiImageException(this.message);
  @override
  String toString() => message;
}

class AiImageService {
  final GetFreepikImage _getFreepikImage;
  AiImageService(this._getFreepikImage);

  Future<List<String>> generate(
    String prompt, {
    String? aspectRatio,
    String modelPath = '/ai/text-to-image',
  }) async {
    final r = await _getFreepikImage.generate(
      prompt: prompt,
      aspectRatio: aspectRatio,
      modelPath: modelPath,
    );
    if (r.generated.isEmpty) {
      throw AiImageException('No images returned from Server');
    }
    return r.generated;
  }
}

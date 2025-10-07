import '/data/models/models.dart';

abstract class FreepikRepo {
  Future<FreepikModel> generateImage({
    required String prompt,
    String? aspectRatio,
    String modelPath,
    Map<String, dynamic>? extraBody,
  });

  Future<FreepikModel> getTaskStatus({required String taskId, String taskPath});
}

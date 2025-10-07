import '/domain/repo/freepik_repo.dart';
import '/data/models/models.dart';

class GetFreepikImage {
  final FreepikRepo repo;

  GetFreepikImage(this.repo);

  Future<FreepikModel> generate({
    required String prompt,
    String? aspectRatio,
    String modelPath = '/ai/text-to-image',
    Map<String, dynamic>? extraBody,
  }) {
    return repo.generateImage(
      prompt: prompt,
      aspectRatio: aspectRatio,
      modelPath: modelPath,
      extraBody: extraBody,
    );
  }

  Future<FreepikModel> taskStatus({
    required String taskId,
    String taskPath = '/ai/text-to-image',
  }) {
    return repo.getTaskStatus(taskId: taskId, taskPath: taskPath);
  }
}

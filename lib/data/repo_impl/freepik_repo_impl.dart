import '/domain/repo/freepik_repo.dart';
import '/data/data_source/freepik_data_source.dart';
import '/data/models/models.dart';

class FreepikRepoImpl implements FreepikRepo {
  final FreepikDataSource dataSource;
  FreepikRepoImpl(this.dataSource);

  @override
  Future<FreepikModel> generateImage({
    required String prompt,
    String? aspectRatio,
    String modelPath = '/ai/text-to-image',
    Map<String, dynamic>? extraBody,
  }) {
    return dataSource.generateImage(
      prompt: prompt,
      aspectRatio: aspectRatio,
      modelPath: modelPath,
      extraBody: extraBody,
    );
  }
}

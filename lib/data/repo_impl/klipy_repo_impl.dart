import '/domain/repo/klipy_repo.dart';
import '/data/data_source/klipy_data_source.dart';
import '/data/models/models.dart';

class KlipyRepoImpl implements KlipyRepo {
  final KlipyDataSource dataSource;
  KlipyRepoImpl(this.dataSource);

  @override
  Future<StickerResponseModel> trending({int page = 1, int perPage = 20}) {
    return dataSource.trending(page: page, perPage: perPage);
  }

  @override
  Future<StickerResponseModel> search(
    String query, {
    int page = 1,
    int perPage = 20,
  }) {
    return dataSource.search(query, page: page, perPage: perPage);
  }
}

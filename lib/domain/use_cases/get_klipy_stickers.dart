import '/domain/repo/klipy_repo.dart';
import '/data/models/models.dart';

class GetKlipyStickers {
  final KlipyRepo repo;
  GetKlipyStickers(this.repo);

  Future<StickerResponseModel> trending({int page = 1, int perPage = 20}) {
    return repo.trending(page: page, perPage: perPage);
  }

  Future<StickerResponseModel> search(
    String query, {
    int page = 1,
    int perPage = 20,
  }) {
    return repo.search(query, page: page, perPage: perPage);
  }
}

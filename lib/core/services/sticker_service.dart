import '/data/models/models.dart';
import '/domain/use_cases/get_klipy_stickers.dart';

class StickerService {
  final GetKlipyStickers _useCase;
  StickerService(this._useCase);

  Future<StickerResponseModel> getTrending({int page = 1, int perPage = 20}) {
    return _useCase.trending(page: page, perPage: perPage);
  }

  Future<StickerResponseModel> search(
    String query, {
    int page = 1,
    int perPage = 20,
  }) {
    return _useCase.search(query, page: page, perPage: perPage);
  }
}

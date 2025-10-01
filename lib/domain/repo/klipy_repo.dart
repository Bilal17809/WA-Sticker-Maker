import '/data/models/models.dart';

abstract class KlipyRepo {
  Future<StickerResponseModel> trending({int page, int perPage});
  Future<StickerResponseModel> search(String query, {int page, int perPage});
}

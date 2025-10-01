import 'models.dart';

class StickerResponseModel {
  final List<StickerModel> stickers;
  final int currentPage;
  final int perPage;
  final bool hasNext;

  StickerResponseModel({
    required this.stickers,
    required this.currentPage,
    required this.perPage,
    required this.hasNext,
  });

  factory StickerResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final stickerList = data['data'] as List<dynamic>? ?? [];

    return StickerResponseModel(
      stickers: stickerList
          .map((s) => StickerModel.fromJson(s as Map<String, dynamic>))
          .where((s) => s.imageUrl.isNotEmpty)
          .toList(),
      currentPage: data['current_page'] as int? ?? 1,
      perPage: data['per_page'] as int? ?? stickerList.length,
      hasNext: data['has_next'] as bool? ?? false,
    );
  }
}

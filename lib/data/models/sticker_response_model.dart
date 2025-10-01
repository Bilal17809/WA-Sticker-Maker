import 'models.dart';

class StickerResponseModel {
  final List<StickerModel> stickers;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final int total;

  StickerResponseModel({
    required this.stickers,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.total,
  });

  factory StickerResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final stickerList = (data['data'] ?? json['data'] ?? []) as List<dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

    return StickerResponseModel(
      stickers: stickerList
          .map((s) => StickerModel.fromJson(s as Map<String, dynamic>))
          .where((s) => s.imageUrl.isNotEmpty)
          .toList(),
      currentPage: pagination['current_page'] as int? ?? 1,
      totalPages: pagination['total_pages'] as int? ?? 1,
      perPage: pagination['per_page'] as int? ?? stickerList.length,
      total: pagination['total'] as int? ?? stickerList.length,
    );
  }
}

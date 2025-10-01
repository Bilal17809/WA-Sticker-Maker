import '/core/helper/helper.dart';

class StickerModel {
  final String id;
  final String title;
  final String imageUrl;
  final bool isAnimated;

  StickerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isAnimated,
  });

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    final fileObj = json['file'] as Map<String, dynamic>?;
    final url = StickerHelper.pickWebp(fileObj);

    return StickerModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: url,
      isAnimated: false,
    );
  }
}

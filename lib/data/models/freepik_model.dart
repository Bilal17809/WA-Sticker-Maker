class FreepikModel {
  final List<String> generated;
  final Map<String, dynamic>? meta;

  FreepikModel({required this.generated, this.meta});

  factory FreepikModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final generated = <String>[];
    for (var item in data) {
      if (item is Map && item['base64'] is String) {
        generated.add(item['base64']);
      }
    }

    return FreepikModel(
      generated: generated,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

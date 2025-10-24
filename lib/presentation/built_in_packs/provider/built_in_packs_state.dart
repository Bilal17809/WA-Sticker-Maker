class BuiltInPacksState {
  final String id;
  final String name;
  final String url;
  final String thumbnail;
  final List<String> stickers;

  BuiltInPacksState({
    required this.id,
    required this.name,
    required this.url,
    required this.thumbnail,
    required this.stickers,
  });

  factory BuiltInPacksState.fromJson(Map<String, dynamic> json) {
    return BuiltInPacksState(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String? ?? '',
      stickers:
          (json['stickers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

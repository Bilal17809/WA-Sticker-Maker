class StickerHelper {
  static String pickWebp(Map<String, dynamic>? fileObj) {
    if (fileObj == null) return '';
    final preferredKeys = ['hd', 'md', 'sm', 'xs', '240'];

    for (final key in preferredKeys) {
      final bucket = fileObj[key] as Map<String, dynamic>?;
      final webp = bucket?['webp']?['url'] as String?;
      if (webp?.isNotEmpty ?? false) return webp!;
    }
    for (final entry in fileObj.entries) {
      final bucket = entry.value as Map<String, dynamic>?;
      final webp = bucket?['webp']?['url'] as String?;
      if (webp?.isNotEmpty ?? false) return webp!;
    }
    return '';
  }
}

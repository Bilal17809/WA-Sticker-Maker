class StickerHelper {
  static String pickWebp(Map<String, dynamic>? fileObj) {
    if (fileObj == null) return '';
    const sizes = ['xs', 'sm', 'md', 'hd'];
    for (final size in sizes.reversed) {
      final bucket = fileObj[size] as Map<String, dynamic>?;
      final webp = bucket?['webp']?['url'] as String?;
      if (webp?.isNotEmpty ?? false) return webp!;
    }
    return '';
  }
}

class StickerHelper {
  static String pickPng(Map<String, dynamic>? fileObj) {
    if (fileObj == null) return '';
    final preferredKeys = ['hd', 'md', 'sm', 'xs', '240'];

    for (final key in preferredKeys) {
      final bucket = fileObj[key] as Map<String, dynamic>?;
      final png = bucket?['png']?['url'] as String?;
      if (png?.isNotEmpty ?? false) return png!;
    }

    for (final entry in fileObj.entries) {
      final bucket = entry.value as Map<String, dynamic>?;
      final png = bucket?['png']?['url'] as String?;
      if (png?.isNotEmpty ?? false) return png!;
    }

    return '';
  }
}

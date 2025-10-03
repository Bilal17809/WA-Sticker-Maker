class ExtensionUtil {
  static String extensionFromUrl(String url) {
    try {
      final p = Uri.parse(url).path;
      final i = p.lastIndexOf('.');
      if (i != -1 && i < p.length - 1) return p.substring(i);
    } catch (_) {}
    return '.png';
  }
}

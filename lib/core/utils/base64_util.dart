import 'dart:convert';
import 'dart:typed_data';

class Base64Utils {
  static Uint8List? maybeDecode(String s) {
    try {
      if (s.startsWith('data:')) {
        final parts = s.split(',');
        if (parts.length > 1) {
          return base64.decode(parts.last);
        }
      } else if (RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(s) ||
          RegExp(r'^[A-Za-z0-9+/=\s]+$').hasMatch(s)) {
        return base64.decode(s.replaceAll('\n', ''));
      }
    } catch (_) {}
    return null;
  }
}

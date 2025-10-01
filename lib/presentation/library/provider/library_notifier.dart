import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '/core/common/app_exceptions.dart';
import 'library_state.dart';

class LibraryNotifier extends Notifier<LibraryState> {
  @override
  LibraryState build() {
    return const LibraryState();
  }

  Future<void> loadEmojis() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      final parser = EmojiParser(init: false);
      await parser.initServerData();
      final allEmojis = <String>[];
      final emojiRanges = [
        {'start': 0x1F600, 'end': 0x1F64F},
        {'start': 0x1F300, 'end': 0x1F5FF},
        {'start': 0x1F680, 'end': 0x1F6FF},
        {'start': 0x1F910, 'end': 0x1F96B},
        {'start': 0x1F6F4, 'end': 0x1F6F8},
      ];

      for (final range in emojiRanges) {
        for (
          int codePoint = range['start']!;
          codePoint <= range['end']!;
          codePoint++
        ) {
          try {
            final emojiChar = String.fromCharCode(codePoint);
            if (parser.hasEmoji(emojiChar) && !allEmojis.contains(emojiChar)) {
              allEmojis.add(emojiChar);
            }
          } catch (_) {
            continue;
          }
        }
      }
      final uniqueEmojis = allEmojis.toSet().toList();
      uniqueEmojis.sort();
      state = state.copyWith(emojis: uniqueEmojis, isLoading: false);
    } catch (e) {
      debugPrint('${AppExceptions().errorFetchingEmojis}: $e');
      state = state.copyWith(emojis: [], isLoading: false);
    }
  }
}

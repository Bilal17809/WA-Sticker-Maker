import 'package:flutter/foundation.dart';

@immutable
class LibraryState {
  final List<String> emojis;
  final bool isLoading;

  const LibraryState({this.emojis = const [], this.isLoading = false});

  LibraryState copyWith({List<String>? emojis, bool? isLoading}) {
    return LibraryState(
      emojis: emojis ?? this.emojis,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

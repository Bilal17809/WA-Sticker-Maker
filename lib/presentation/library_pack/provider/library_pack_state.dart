import 'package:flutter/foundation.dart';

@immutable
class LibraryPacksState {
  final String name;
  final String directoryPath;
  final List<String> stickerPaths;
  final String? trayImagePath;

  const LibraryPacksState({
    required this.name,
    required this.directoryPath,
    required this.stickerPaths,
    this.trayImagePath,
  });

  LibraryPacksState copyWith({
    String? name,
    String? directoryPath,
    List<String>? stickerPaths,
    String? trayImagePath,
  }) {
    return LibraryPacksState(
      name: name ?? this.name,
      directoryPath: directoryPath ?? this.directoryPath,
      stickerPaths: stickerPaths ?? this.stickerPaths,
      trayImagePath: trayImagePath ?? this.trayImagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'directoryPath': directoryPath,
      'stickerPaths': stickerPaths,
      'trayImagePath': trayImagePath,
    };
  }

  factory LibraryPacksState.fromJson(Map<String, dynamic> json) {
    return LibraryPacksState(
      name: json['name'] as String,
      directoryPath: json['directoryPath'] as String,
      stickerPaths: List<String>.from(json['stickerPaths'] as List),
      trayImagePath: json['trayImagePath'] as String?,
    );
  }
}

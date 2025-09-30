import 'package:flutter/foundation.dart';

@immutable
class PacksState {
  final String name;
  final String directoryPath;
  final List<String> stickerPaths;
  final String? trayImagePath;

  const PacksState({
    required this.name,
    required this.directoryPath,
    required this.stickerPaths,
    this.trayImagePath,
  });

  PacksState copyWith({
    String? name,
    String? directoryPath,
    List<String>? stickerPaths,
    String? trayImagePath,
  }) {
    return PacksState(
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

  factory PacksState.fromJson(Map<String, dynamic> json) {
    return PacksState(
      name: json['name'] as String,
      directoryPath: json['directoryPath'] as String,
      stickerPaths: List<String>.from(json['stickerPaths'] as List),
      trayImagePath: json['trayImagePath'] as String?,
    );
  }
}

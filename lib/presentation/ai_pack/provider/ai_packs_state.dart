import 'package:flutter/foundation.dart';
import '/core/interface/pack_info_interface.dart';

@immutable
class AiPacksState implements PackInfoInterface {
  @override
  final String name;
  @override
  final String directoryPath;
  @override
  final List<String> stickerPaths;
  @override
  final String? trayImagePath;

  const AiPacksState({
    required this.name,
    required this.directoryPath,
    required this.stickerPaths,
    this.trayImagePath,
  });

  AiPacksState copyWith({
    String? name,
    String? directoryPath,
    List<String>? stickerPaths,
    String? trayImagePath,
  }) {
    return AiPacksState(
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

  factory AiPacksState.fromJson(Map<String, dynamic> json) {
    return AiPacksState(
      name: json['name'] as String,
      directoryPath: json['directoryPath'] as String,
      stickerPaths: List<String>.from(json['stickerPaths'] as List),
      trayImagePath: json['trayImagePath'] as String?,
    );
  }
}

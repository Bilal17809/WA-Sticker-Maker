import 'package:flutter/cupertino.dart';

import '/core/interface/pack_info_interface.dart';

@immutable
class BuiltInPacksState implements PackInfoInterface {
  @override
  final String name;
  @override
  final String directoryPath;
  @override
  final List<String> stickerPaths;
  @override
  final String? trayImagePath;
  final String thumbnail;
  final List<String> stickers;
  final bool showBanner;

  const BuiltInPacksState({
    required this.name,
    required this.thumbnail,
    required this.stickers,
    this.directoryPath = '',
    this.stickerPaths = const [],
    this.trayImagePath,
    this.showBanner = true,
  });

  String get displayName {
    final regex = RegExp(r'^\d+_');
    return name.replaceFirst(regex, '');
  }

  BuiltInPacksState copyWith({
    String? directoryPath,
    List<String>? stickerPaths,
    String? trayImagePath,
    bool? showBanner,
  }) {
    return BuiltInPacksState(
      name: name,
      thumbnail: thumbnail,
      stickers: stickers,
      directoryPath: directoryPath ?? this.directoryPath,
      stickerPaths: stickerPaths ?? this.stickerPaths,
      trayImagePath: trayImagePath ?? this.trayImagePath,
      showBanner: showBanner ?? this.showBanner,
    );
  }
}

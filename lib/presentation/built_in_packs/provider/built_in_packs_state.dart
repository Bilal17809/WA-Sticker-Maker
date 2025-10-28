import '/core/interface/pack_info_interface.dart';

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

  BuiltInPacksState({
    required this.name,
    required this.thumbnail,
    required this.stickers,
    this.directoryPath = '',
    this.stickerPaths = const [],
    this.trayImagePath,
  });

  String get displayName {
    final regex = RegExp(r'^\d+_');
    return name.replaceFirst(regex, '');
  }

  BuiltInPacksState copyWith({
    String? directoryPath,
    List<String>? stickerPaths,
    String? trayImagePath,
  }) {
    return BuiltInPacksState(
      name: name,
      thumbnail: thumbnail,
      stickers: stickers,
      directoryPath: directoryPath ?? this.directoryPath,
      stickerPaths: stickerPaths ?? this.stickerPaths,
      trayImagePath: trayImagePath ?? this.trayImagePath,
    );
  }
}

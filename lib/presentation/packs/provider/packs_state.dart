class PacksState {
  final String name;
  final String directoryPath;
  final List<String> stickerPaths;

  PacksState({
    required this.name,
    required this.directoryPath,
    required this.stickerPaths,
  });

  PacksState copyWith({
    String? name,
    String? directoryPath,
    List<String>? stickerPaths,
  }) {
    return PacksState(
      name: name ?? this.name,
      directoryPath: directoryPath ?? this.directoryPath,
      stickerPaths: stickerPaths ?? this.stickerPaths,
    );
  }
}

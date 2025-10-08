import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/interface/pack_info_interface.dart';

typedef PackUpdateCallback<T extends PackInfoInterface> =
    void Function(int index, T updated);

class ApiPackHelper {
  static void updatePackGeneric<T extends PackInfoInterface>({
    required Ref ref,
    required List<T> state,
    required PackUpdateCallback<T> onUpdate,
    required T pack,
    required List<String> paths,
  }) {
    final index = state.indexWhere(
      (p) => p.directoryPath == pack.directoryPath,
    );
    if (index == -1) return;
    final current = state[index];
    final trayImagePath = current.stickerPaths.isEmpty
        ? paths.first
        : current.trayImagePath;
    final updated =
        (current as dynamic).copyWith(
              stickerPaths: [...current.stickerPaths, ...paths],
              trayImagePath: trayImagePath,
            )
            as T;
    onUpdate(index, updated);
  }
}

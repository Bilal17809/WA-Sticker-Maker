import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/packs/provider/packs_state.dart';

class PacksNotifier extends Notifier<List<PacksState>> {
  @override
  List<PacksState> build() => [];

  void addPack(PacksState pack) {
    state = [...state, pack];
  }

  void removePack(int index) {
    final list = [...state];
    list.removeAt(index);
    state = list;
  }

  void updatePack(int index, PacksState updatedPack) {
    final list = [...state];
    list[index] = updatedPack;
    state = list;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'built_in_packs_detail_state.dart';

class BuiltInPacksDetailNotifier extends Notifier<BuiltInPacksDetailState> {
  @override
  BuiltInPacksDetailState build() => const BuiltInPacksDetailState();

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

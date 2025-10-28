import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'built_in_packs_gallery_state.dart';

class BuiltInPacksGalleryNotifier extends Notifier<BuiltInPacksGalleryState> {
  @override
  BuiltInPacksGalleryState build() => const BuiltInPacksGalleryState();

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

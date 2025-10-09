import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();

  void setDrawerOpen(bool isOpen) {
    state = state.copyWith(isDrawerOpen: isOpen);
  }
}

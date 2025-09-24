import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_state.dart';

class HomeProvider extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();

  void setDrawerOpen(bool isOpen) {
    state = state.copyWith(isDrawerOpen: isOpen);
  }

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

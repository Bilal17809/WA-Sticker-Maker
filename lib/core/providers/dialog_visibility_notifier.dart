import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void show() => state = true;
  void hide() => state = false;
}

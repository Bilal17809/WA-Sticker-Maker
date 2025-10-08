import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/local_storage/local_storage.dart';

class RemoveAdsState {
  final bool isSubscribed;

  RemoveAdsState({this.isSubscribed = false});

  RemoveAdsState copyWith({bool? isSubscribed}) {
    return RemoveAdsState(isSubscribed: isSubscribed ?? this.isSubscribed);
  }
}

class RemoveAdsNotifier extends Notifier<RemoveAdsState> {
  @override
  RemoveAdsState build() {
    checkSubscriptionStatus();
    return RemoveAdsState();
  }

  Future<void> checkSubscriptionStatus() async {
    final prefs = LocalStorage();
    final isSubscribed =
        await prefs.getBool('SubscribeWaStickerMaker') ?? false;
    state = state.copyWith(isSubscribed: isSubscribed);
  }
}

final removeAdsProvider = NotifierProvider<RemoveAdsNotifier, RemoveAdsState>(
  RemoveAdsNotifier.new,
);

extension RemoveAdsStateExtension on RemoveAdsState {
  bool get isSubscribed => this.isSubscribed;
}

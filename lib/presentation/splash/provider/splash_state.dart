import 'package:flutter/foundation.dart';
import '/core/common_widgets/common_widgets.dart';

@immutable
class SplashState extends BaseState {
  @override
  final bool isLoading;
  final bool showButton;
  final int visibleLetters;
  final bool fadeInOut;
  final String titleText;

  const SplashState({
    this.isLoading = true,
    this.showButton = false,
    this.visibleLetters = 0,
    this.fadeInOut = true,
    this.titleText = "Create Your Own Stickers for\nWhatsApp in Seconds!",
  });

  SplashState copyWith({
    bool? isLoading,
    bool? showButton,
    int? visibleLetters,
    bool? fadeInOut,
    String? titleText,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      showButton: showButton ?? this.showButton,
      visibleLetters: visibleLetters ?? this.visibleLetters,
      fadeInOut: fadeInOut ?? this.fadeInOut,
      titleText: titleText ?? this.titleText,
    );
  }
}

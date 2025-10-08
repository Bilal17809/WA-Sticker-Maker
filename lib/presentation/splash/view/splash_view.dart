import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '/core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/presentation/home/view/home_view.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashProvider);
    final splashAdState = ref.watch(splashInterstitialManagerProvider);
    final splashAdManager = ref.read(
      splashInterstitialManagerProvider.notifier,
    );
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: splashState.showButton
                  ? AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: SizedBox(
                        width: context.screenWidth * 0.7,
                        child: SlideAction(
                          borderRadius: kCircularBorderRadius,
                          elevation: 0,
                          height: 56,
                          sliderButtonIconSize: kCircularBorderRadius,
                          sliderButtonYOffset: -kGap,
                          sliderRotate: false,
                          sliderButtonIcon: const Icon(
                            Icons.double_arrow_rounded,
                            color: AppColors.primaryColorLight,
                          ),
                          innerColor: AppColors.kWhite,
                          outerColor: AppColors.primaryColorLight,
                          text: 'Slide to Start',
                          textStyle: titleLargeStyle.copyWith(
                            color: AppColors.kWhite,
                            shadows: kShadow,
                          ),
                          onSubmit: () async {
                            if (splashAdState.isAdReady) {
                              splashAdManager.showSplashAd();
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeView(),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : LoadingAnimationWidget.halfTriangleDot(
                      color: AppColors.primaryColorLight,
                      size: context.screenWidth * 0.14,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

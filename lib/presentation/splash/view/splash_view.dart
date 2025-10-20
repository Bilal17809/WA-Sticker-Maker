import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wa_sticker_maker/core/utils/assets_util.dart';
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
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightBgColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: AppDecorations.bgContainer(context),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(kBodyHp),
                child: Column(
                  children: [
                    const SizedBox(height: kBodyHp * 2),
                    Text(
                      'WA Sticker',
                      textAlign: TextAlign.center,
                      style: headlineMediumStyle.copyWith(
                        color: AppColors.kWhite,
                        shadows: kShadow,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.splashHeroImg),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kBodyHp * 2),
                      child: RichText(
                        key: ValueKey(splashState.visibleLetters),
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: titleSmallStyle.copyWith(
                            color: AppColors.kWhite,
                          ),
                          children: [
                            ...List.generate(splashState.titleText.length, (
                              index,
                            ) {
                              final isVisible =
                                  index < splashState.visibleLetters;
                              return TextSpan(
                                text: splashState.titleText[index],
                                style: titleSmallStyle.copyWith(
                                  color: isVisible
                                      ? AppColors.kWhite
                                      : AppColors.transparent,
                                  shadows: isVisible ? kShadow : [],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: context.screenWidth * 0.25,
                      ),
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
                                    elevation: 2,
                                    height: 56,
                                    sliderButtonIconSize: kCircularBorderRadius,
                                    sliderButtonYOffset: -kGap,
                                    sliderRotate: false,
                                    sliderButtonIcon: const Icon(
                                      Icons.double_arrow_rounded,
                                      color: AppColors.kGreen,
                                    ),
                                    innerColor: AppColors.kWhite,
                                    outerColor: AppColors.kGreen,
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
                            : LoadingAnimationWidget.beat(
                                color: AppColors.kGreen,
                                size: context.screenWidth * 0.14,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -context.screenWidth * 0.06,
            bottom: -kGap,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.splashEllipse),
                    fit: BoxFit.contain,
                  ),
                ),
                padding: const EdgeInsets.all(40),
                child: SizedBox(
                  child: Image.asset(
                    Assets.splashIcon,
                    width: context.screenWidth * 0.14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

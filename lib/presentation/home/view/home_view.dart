import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wa_sticker_maker/ad_manager/ad_manager.dart';
import '/presentation/ai_pack/view/ai_packs_view.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/presentation/app_drawer/view/app_drawer.dart';
import '/core/providers/providers.dart';
import '/core/global_keys/global_key.dart';
import '/core/utils/utils.dart';
import '/core/common_widgets/common_widgets.dart';
import 'widgets/home_carousel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) async {
        if (didPop) return;
        final shouldExit = await ExitDialog.show(context);
        if (shouldExit == true) SystemNavigator.pop();
      },
      child: Scaffold(
        key: globalDrawerKey,
        drawer: const AppDrawer(),
        onDrawerChanged: (isOpen) {
          ref.read(homeProvider.notifier).setDrawerOpen(isOpen);
        },
        extendBodyBehindAppBar: true,
        appBar: TitleBar(title: 'WA Sticker Maker', useBackButton: false),
        body: Container(
          decoration: AppDecorations.bgContainer(context),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(kBodyHp),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: kBodyHp),
                        child: Row(
                          children: [
                            Text(
                              'Hello',
                              style: headlineMediumStyle.copyWith(
                                color: AppColors.kWhite,
                              ),
                            ),
                            LottieWidget(assetPath: Assets.hiLottie),
                          ],
                        ),
                      ),
                      const SizedBox(height: kBodyHp),
                      !ref.watch(homeProvider).isDrawerOpen
                          ? NativeAdWidget()
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: AppDecorations.simpleRounded(context).copyWith(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kBorderRadius),
                        topRight: Radius.circular(kBorderRadius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: kBodyHp,
                        bottom: kBodyHp,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: kGap,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kBodyHp,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AiPacksView(),
                                ),
                              ),
                              child: Container(
                                decoration: AppDecorations.gradientDecor(
                                  context,
                                ),
                                padding: const EdgeInsets.all(kElementGap),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        spacing: kGap,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'AI Sticker Generator',
                                            style: titleMediumStyle.copyWith(
                                              color: AppColors.kWhite,
                                            ),
                                          ),
                                          Text(
                                            'Generate high quality stickers with AI',
                                            style: bodyLargeStyle.copyWith(
                                              color: AppColors.kWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Lottie.asset(Assets.aiLottie),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kBodyHp,
                            ),
                            child: Text(
                              'Sticker World',
                              style: headlineSmallStyle,
                            ),
                          ),
                          const HomeCarousel(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

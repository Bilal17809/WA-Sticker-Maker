import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final selectedIndex = ref.watch(homeProvider).selectedIndex;
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
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(kBodyHp),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Hello', style: headlineMediumStyle),
                          LottieWidget(assetPath: Assets.hi),
                        ],
                      ),
                    ],
                  ),
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
                      top: kBodyHp * 2,
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
                          child: Container(
                            decoration: AppDecorations.gradientDecor(context),
                            padding: const EdgeInsets.all(kBodyHp),
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
                                        'Lorem Ipsum',
                                        style: bodyLargeStyle,
                                      ),
                                      Text(
                                        'Lorem Ipsum Hello',
                                        style: titleMediumStyle,
                                      ),
                                      Text(
                                        'Lorem Ipsum Hello Lorem Ipsum Hello',
                                        style: bodyLargeStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: primaryIcon(context),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(Assets.appIcon),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kBodyHp,
                          ),
                          child: Text('Lorem', style: headlineSmallStyle),
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
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: AppColors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) =>
                ref.read(homeProvider.notifier).setSelectedIndex(index),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI'),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_sticker_maker/ad_manager/banner_ads.dart';
import '/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';
import '/core/providers/providers.dart';
import '/presentation/built_in_packs_gallery/view/built_in_packs_gallery_view.dart';

class BuiltInPacksDetailView extends ConsumerWidget {
  final BuiltInPacksState pack;
  const BuiltInPacksDetailView({required this.pack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPack = ref
        .watch(builtInPacksProvider)
        .firstWhere((p) => p.name == pack.name, orElse: () => pack);
    final stickers = currentPack.stickers;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: currentPack.displayName),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _StickerGrid(
                  packName: currentPack.name,
                  stickers: stickers,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: _AddToWhatsAppButton(pack: currentPack),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: currentPack.showBanner
          ? const BannerAdWidget()
          : null,
    );
  }
}

class _StickerGrid extends ConsumerWidget {
  final List<String> stickers;
  final String packName;
  const _StickerGrid({required this.stickers, required this.packName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(kBodyHp),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: kGap,
        mainAxisSpacing: kGap,
      ),
      itemCount: stickers.length,
      itemBuilder: (context, index) {
        final assetPath = stickers[index];

        return GestureDetector(
          onTap: () {
            ref
                .read(builtInPacksProvider.notifier)
                .toggleBanner(packName, false);
            ref.read(builtInPacksGalleryProvider.notifier).setIndex(index);
            Navigator.of(context)
                .push(
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: AppColors.kBlack.withValues(alpha: 0.75),
                    pageBuilder: (_, _, _) =>
                        BuiltInPacksGalleryView(images: stickers),
                    transitionsBuilder: (_, animation, _, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                )
                .then((_) {
                  ref
                      .read(builtInPacksProvider.notifier)
                      .toggleBanner(packName, true);
                });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kGap),
            child: Container(
              decoration: AppDecorations.simpleRounded(context),
              padding: const EdgeInsets.all(kBodyHp),
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}

class _AddToWhatsAppButton extends ConsumerWidget {
  final BuiltInPacksState pack;
  const _AddToWhatsAppButton({required this.pack});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () async {
          await ref
              .read(splashInterstitialManagerProvider.notifier)
              .showSplashAd();
          if (context.mounted) {
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              pageBuilder: (_, _, _) => Center(
                child: CircularProgressIndicator(color: AppColors.kWhite),
              ),
            );
          }
          final result = await ref
              .read(builtInPacksProvider.notifier)
              .exportPack(pack);
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          if (result != null && context.mounted && !result.contains('added')) {
            SimpleToast.showToast(
              context: context,
              message: result,
              imagePath: Assets.whatsAppLogo,
              verticalMargin: context.screenHeight * 0.125,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: AppColors.kGreen,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: kGap,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Add To WhatsApp",
                style: titleMediumStyle.copyWith(color: AppColors.kWhite),
              ),
            ),
            Image.asset(
              Assets.whatsAppCircularLogo,
              color: AppColors.kWhite,
              width: secondaryIcon(context),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final stickers = pack.stickers;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: pack.displayName),
      body: Stack(
        children: [
          Container(
            decoration: AppDecorations.bgContainer(context),
            child: SafeArea(child: _StickerGrid(stickers: stickers)),
          ),
          _AddToWhatsAppButton(pack: pack),
        ],
      ),
    );
  }
}

class _StickerGrid extends ConsumerWidget {
  final List<String> stickers;
  const _StickerGrid({required this.stickers});
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
            ref.read(builtInPacksGalleryProvider.notifier).setIndex(index);
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierColor: AppColors.kBlack.withValues(alpha: 0.75),
                pageBuilder: (_, _, _) =>
                    BuiltInPacksGalleryView(images: stickers),
                transitionsBuilder: (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
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
    return Positioned(
      left: context.screenWidth * 0.1,
      right: context.screenWidth * 0.1,
      bottom: context.screenHeight * 0.1,
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: () async {
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              pageBuilder: (_, _, _) => Center(
                child: CircularProgressIndicator(color: AppColors.kWhite),
              ),
            );
            final result = await ref
                .read(builtInPacksProvider.notifier)
                .exportPack(pack);
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            if (result != null &&
                context.mounted &&
                !result.contains('added')) {
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
      ),
    );
  }
}

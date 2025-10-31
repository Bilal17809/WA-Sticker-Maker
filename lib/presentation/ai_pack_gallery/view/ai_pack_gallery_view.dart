import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/ai_image/view/ai_image_view.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/presentation/ai_pack_gallery/provider/ai_pack_gallery_state.dart';
import '/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '/core/theme/theme.dart';
import '/ad_manager/ad_manager.dart';

class AiPackGalleryView extends ConsumerWidget {
  final AiPacksState pack;
  const AiPackGalleryView({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(aiPacksProvider);
    final galleryState = ref.watch(aiPackGalleryProvider);
    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == pack.directoryPath,
      orElse: () => pack,
    );
    ref.listen<AiPackGalleryState>(aiPackGalleryProvider, (previous, next) {
      if (context.mounted && next.lastMessage != null) {
        if (!(next.lastMessage?.contains('added') ?? false)) {
          SimpleToast.showToast(
            context: context,
            message: next.lastMessage!,
            imagePath: Assets.whatsAppLogo,
          );
        }
        ref.read(aiPackGalleryProvider.notifier).clearMessage();
      }
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: pack.name),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: currentPack.stickerPaths.isEmpty
            ? Center(
                child: Text(
                  'No stickers yet.\nTap + to add from AI.',
                  style: titleSmallStyle.copyWith(color: AppColors.kWhite),
                  textAlign: TextAlign.center,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(kBodyHp),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: kGap,
                              mainAxisSpacing: kGap,
                              childAspectRatio: 1,
                            ),
                        itemCount: currentPack.stickerPaths.length,
                        itemBuilder: (context, index) {
                          final path = currentPack.stickerPaths[index];
                          return GestureDetector(
                            onTap: () async {
                              final shouldDelete =
                                  await DeleteStickerDialog.show(context);
                              if (shouldDelete == true) {
                                await ref
                                    .read(aiPacksProvider.notifier)
                                    .removeStickerFromPack(currentPack, path);
                              }
                            },
                            child: Container(
                              decoration: AppDecorations.simpleRounded(context),
                              padding: const EdgeInsets.all(kBodyHp),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  kElementGap,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: kElementGap,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: kGap,
            children: [
              Text(
                'Add Sticker',
                style: titleSmallStyle.copyWith(color: AppColors.kWhite),
              ),
              FloatingActionButton(
                elevation: 1,
                onPressed: () {
                  ref
                      .read(interstitialAdManagerProvider.notifier)
                      .checkAndDisplayAd();
                  Navigator.push<Set<String>>(
                    context,
                    MaterialPageRoute(builder: (_) => AiImageView(pack: pack)),
                  );
                },
                heroTag: 'add_image',
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: kGap,
            children: [
              Text(
                'Add To WhatsApp',
                style: titleSmallStyle.copyWith(color: AppColors.kWhite),
              ),
              FloatingActionButton(
                elevation: 1,
                onPressed: currentPack.stickerPaths.length >= 3
                    ? () => ref
                          .read(aiPackGalleryProvider.notifier)
                          .exportPackToWhatsApp(pack)
                    : () => SimpleToast.showToast(
                        context: context,
                        message: 'Please add at least 3 stickers to the pack',
                      ),
                heroTag: 'export_whatsapp',
                backgroundColor: currentPack.stickerPaths.length >= 3
                    ? AppColors.secondaryIcon(context)
                    : AppColors.kGrey.withValues(alpha: 0.4),
                child: galleryState.isExporting
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.kWhite,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          Assets.whatsAppCircularLogo,
                          color: AppColors.kWhite,
                          width: secondaryIcon(context),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

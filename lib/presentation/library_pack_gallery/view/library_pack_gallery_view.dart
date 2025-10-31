import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/utils/utils.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/presentation/library_pack_gallery/provider/library_pack_gallery_state.dart';
import '/presentation/library/view/library_view.dart';
import '/core/constants/constants.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '/core/theme/theme.dart';
import '/ad_manager/ad_manager.dart';

class LibraryPackGalleryView extends ConsumerWidget {
  final LibraryPacksState pack;
  const LibraryPackGalleryView({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interstitialState = ref.watch(interstitialAdManagerProvider);
    final packs = ref.watch(libraryPacksProvider);
    final galleryState = ref.watch(libraryPackGalleryProvider);
    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == pack.directoryPath,
      orElse: () => pack,
    );
    ref.listen<LibraryPackGalleryState>(libraryPackGalleryProvider, (
      previous,
      next,
    ) {
      if (context.mounted && next.lastMessage != null) {
        if (!(next.lastMessage?.contains('added') ?? false)) {
          SimpleToast.showToast(
            context: context,
            message: next.lastMessage!,
            imagePath: Assets.whatsAppLogo,
          );
        }
        ref.read(libraryPackGalleryProvider.notifier).clearMessage();
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
                  'No stickers yet.\nTap + to add from library.',
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
                                    .read(libraryPacksProvider.notifier)
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
                    MaterialPageRoute(builder: (_) => LibraryView(pack: pack)),
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
                          .read(libraryPackGalleryProvider.notifier)
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
      bottomNavigationBar: interstitialState.isShow
          ? const SizedBox()
          : const BannerAdWidget(),
    );
  }
}

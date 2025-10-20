import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/utils/utils.dart';
import '../provider/pack_gallery_state.dart';
import '/core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/gallery/view/gallery_view.dart';
import '/presentation/packs/provider/packs_state.dart';
import '/ad_manager/ad_manager.dart';

class PackGalleryView extends ConsumerStatefulWidget {
  final PacksState pack;
  const PackGalleryView({super.key, required this.pack});
  @override
  ConsumerState<PackGalleryView> createState() => _PackGalleryViewState();
}

class _PackGalleryViewState extends ConsumerState<PackGalleryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(interstitialAdManagerProvider.notifier).checkAndDisplayAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final interstitialState = ref.watch(interstitialAdManagerProvider);
    final packs = ref.watch(packsProvider);
    final galleryState = ref.watch(packGalleryProvider);

    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == widget.pack.directoryPath,
      orElse: () => widget.pack,
    );

    ref.listen<PackGalleryState>(packGalleryProvider, (previous, next) {
      if (next.lastMessage != null && context.mounted) {
        if (!(next.lastMessage?.contains('added') ?? false)) {
          SimpleToast.showToast(context: context, message: next.lastMessage!);
          SimpleToast.showToast(context: context, message: next.lastMessage!);
        }
        ref.read(packGalleryProvider.notifier).clearMessage();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(
        title: widget.pack.name,
        actions: [
          if (currentPack.stickerPaths.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: kBodyHp),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: currentPack.trayImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(kGap),
                          child: Image.file(
                            File(currentPack.trayImagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.emoji_emotions),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: currentPack.stickerPaths.isEmpty
            ? Center(
                child: Text(
                  'No stickers yet.\nTap + to add one.',
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
                                    .read(packsProvider.notifier)
                                    .removeStickerFromPack(currentPack, path);
                              }
                            },
                            child: Container(
                              decoration: AppDecorations.simpleRounded(context),
                              padding: const EdgeInsets.all(kBodyHp),
                              child: Image.file(File(path), fit: BoxFit.cover),
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
                onPressed: () async {
                  await ref.read(packGalleryProvider.notifier).addNewImage();
                  if (!context.mounted) return;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GalleryView(pack: widget.pack),
                    ),
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
                          .read(packGalleryProvider.notifier)
                          .exportPackToWhatsApp(widget.pack)
                    : () => SimpleToast.showToast(
                        context: context,
                        message: 'Please add at least 3 images to the pack',
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

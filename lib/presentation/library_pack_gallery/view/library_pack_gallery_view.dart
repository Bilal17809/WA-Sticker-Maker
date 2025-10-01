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

class LibraryPackGalleryView extends ConsumerWidget {
  final LibraryPacksState pack;
  const LibraryPackGalleryView({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      if (next.lastMessage != null && context.mounted) {
        SimpleToast.showCustomToast(
          context: context,
          message: next.lastMessage!,
        );
        ref.read(libraryPackGalleryProvider.notifier).clearMessage();
      }
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(
        title: pack.name,
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
                  'No stickers yet.\nTap + to add from library.',
                  style: bodyLargeStyle,
                  textAlign: TextAlign.center,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(kBodyHp),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        final shouldDelete = await DeleteStickerDialog.show(
                          context,
                        );
                        if (shouldDelete == true) {
                          await ref
                              .read(libraryPacksProvider.notifier)
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
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: kElementGap,
        children: [
          FloatingActionButton(
            elevation: 1,
            onPressed: () => Navigator.push<Set<String>>(
              context,
              MaterialPageRoute(builder: (_) => LibraryView(pack: pack)),
            ),
            heroTag: 'add_from_library',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            elevation: 1,
            onPressed: currentPack.stickerPaths.length >= 3
                ? () => ref
                      .read(libraryPackGalleryProvider.notifier)
                      .exportPackToWhatsApp(pack)
                : () => SimpleToast.showCustomToast(
                    context: context,
                    message: 'Please add at least 3 stickers to pack',
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
                : const Icon(Icons.upload),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '/core/services/connectivity_service.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/core/constants/constants.dart';
import '/core/utils/utils.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '/core/theme/theme.dart';
import '/presentation/library/provider/library_state.dart';
import '/ad_manager/ad_manager.dart';

class LibraryView extends ConsumerStatefulWidget {
  final LibraryPacksState pack;
  const LibraryView({super.key, required this.pack});
  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> {
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
    final libraryState = ref.watch(libraryProvider);
    ref.listen<AsyncValue<bool>>(internetStatusStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((isConnected) {
        if (isConnected) {
          ConnectivityDialog.closeIfOpen(context);
        } else {
          ConnectivityDialog.showNoInternetDialog(
            context,
            onRetry: () async {
              await ref.read(libraryProvider.notifier).loadTrending();
            },
          );
        }
      });
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(
        title: 'Pack - ${widget.pack.name}',
        actions: [
          libraryState.selectedStickerIds.isNotEmpty
              ? IconActionButton(
                  onTap: () async {
                    final success = await ref
                        .read(libraryProvider.notifier)
                        .downloadAndAddToPack(widget.pack);
                    if (success && context.mounted) {
                      return Navigator.pop(context);
                    }
                  },
                  icon: libraryState.isDownloading
                      ? Icons.hourglass_bottom
                      : Icons.downloading,
                )
              : IconActionButton(
                  onTap: () => SimpleToast.showToast(
                    context: context,
                    message: 'Please select a sticker to add',
                  ),
                  icon: Icons.add,
                ),
        ],
      ),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                child: AppSearchField(
                  hintText: 'Search stickers...',
                  onChanged: (v) =>
                      ref.read(libraryProvider.notifier).search(v),
                ),
              ),
              Expanded(
                child: _LibraryBody(
                  libraryState: libraryState,
                  onRetry: () =>
                      ref.read(libraryProvider.notifier).loadTrending(),
                  onLoadMore: () =>
                      ref.read(libraryProvider.notifier).loadMore(),
                  onStickerTap: (stickerId) => ref
                      .read(libraryProvider.notifier)
                      .selectSticker(stickerId),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: interstitialState.isShow
          ? const SizedBox()
          : const BannerAdWidget(),
    );
  }
}

class _LibraryBody extends StatelessWidget {
  final LibraryState libraryState;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final Function(String) onStickerTap;
  const _LibraryBody({
    required this.libraryState,
    required this.onRetry,
    required this.onLoadMore,
    required this.onStickerTap,
  });

  @override
  Widget build(BuildContext context) {
    if (libraryState.isLoading &&
        (libraryState.stickerResponse?.stickers.isEmpty ?? true)) {
      return Center(child: CircularProgressIndicator(color: AppColors.kWhite));
    }
    final stickers = libraryState.stickerResponse?.stickers ?? [];
    final isLoadingMore = libraryState.isLoadingMore;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          if (!libraryState.isLoadingMore &&
              !libraryState.isLoading &&
              libraryState.hasMore) {
            onLoadMore();
          }
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(kBodyHp),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: kGap,
          crossAxisSpacing: kGap,
        ),
        itemCount: stickers.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == stickers.length) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.kWhite,
              ),
            );
          }
          final s = stickers[i];
          final isSelected = libraryState.selectedStickerIds.contains(s.id);
          return GestureDetector(
            onTap: () => onStickerTap(s.id),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kGap),
              child: Container(
                decoration: AppDecorations.simpleRounded(context),
                padding: const EdgeInsets.all(kBodyHp),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.network(
                        s.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) => progress == null
                            ? child
                            : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                        errorBuilder: (_, error, _) =>
                            Center(child: Lottie.asset(Assets.imageLottie)),
                      ),
                    ),
                    isSelected
                        ? Positioned(
                            top: -8,
                            right: -6,
                            child: Icon(Icons.check_circle),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

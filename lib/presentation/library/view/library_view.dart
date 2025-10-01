import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '/presentation/library_pack/provider/library_pack_state.dart';
import '/core/constants/constants.dart';
import '/core/utils/utils.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '/core/theme/theme.dart';
import '/presentation/library/provider/library_state.dart';

class LibraryView extends ConsumerWidget {
  final LibraryPacksState pack;
  const LibraryView({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(libraryProvider.notifier);
      final currentlyEmpty =
          !(libraryState.stickerResponse?.stickers.isNotEmpty ?? false);
      if (!libraryState.isLoading &&
          currentlyEmpty &&
          libraryState.errorMessage == null) {
        notifier.loadTrending();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'Pack - ${pack.name}'),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryBody extends StatelessWidget {
  final LibraryState libraryState;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  const _LibraryBody({
    required this.libraryState,
    required this.onRetry,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (libraryState.isLoading &&
        (libraryState.stickerResponse?.stickers.isEmpty ?? true)) {
      return const Center(child: CircularProgressIndicator());
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
          return ClipRRect(
            borderRadius: BorderRadius.circular(kGap),
            child: Container(
              decoration: AppDecorations.simpleRounded(context),
              padding: const EdgeInsets.all(kBodyHp),
              child: Image.network(
                s.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                errorBuilder: (_, error, __) =>
                    Center(child: Lottie.asset(Assets.imageLottie)),
              ),
            ),
          );
        },
      ),
    );
  }
}

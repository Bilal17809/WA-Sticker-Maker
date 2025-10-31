import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/ad_manager/ad_manager.dart';
import 'package:wa_sticker_maker/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '/presentation/built_in_packs/view/widgets/built_in_packs_detail_view.dart';

final _searchController = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class BuiltInPacksView extends ConsumerWidget {
  const BuiltInPacksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(builtInPacksProvider);
    final controller = ref.watch(_searchController);
    final interstitialState = ref.watch(interstitialAdManagerProvider);
    return GestureDetector(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 120));
        if (!context.mounted) return;
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: TitleBar(title: 'Sticker Store'),
        body: Container(
          decoration: AppDecorations.bgContainer(context),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kBodyHp),
              child: _PacksContent(packs: packs, controller: controller),
            ),
          ),
        ),
        bottomNavigationBar: interstitialState.isShow
            ? const SizedBox()
            : const BannerAdWidget(),
      ),
    );
  }
}

class _PacksContent extends ConsumerWidget {
  final List<dynamic> packs;
  final TextEditingController controller;
  const _PacksContent({required this.packs, required this.controller});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: kElementGap,
      children: [
        AppSearchField(
          hintText: 'Search for stickers',
          controller: controller,
          onChanged: (v) {
            ref.read(builtInPacksProvider.notifier).search(v);
          },
        ),
        Expanded(
          child: packs.isEmpty
              ? controller.text.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.kWhite,
                        ),
                      )
                    : const LottieWidget(
                        isMessage: true,
                        assetPath: Assets.searchLottie,
                      )
              : _PacksList(packs: packs),
        ),
      ],
    );
  }
}

class _PacksList extends ConsumerWidget {
  final List<dynamic> packs;
  const _PacksList({required this.packs});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: packs.length,
      separatorBuilder: (_, _) => const SizedBox(height: kGap),
      itemBuilder: (context, index) {
        final pack = packs[index];
        final stickers = pack.stickers.take(5).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: kGap,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pack.displayName,
                  style: titleMediumStyle.copyWith(color: AppColors.kWhite),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(interstitialAdManagerProvider.notifier)
                        .checkAndDisplayAd();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BuiltInPacksDetailView(pack: pack),
                      ),
                    );
                  },
                  child: Container(
                    decoration: AppDecorations.simpleRounded(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: kElementGap,
                      vertical: 6,
                    ),
                    child: Text('See All', style: bodySmallStyle),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: primaryIcon(context),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stickers.length,
                separatorBuilder: (_, _) => const SizedBox(width: 4),
                itemBuilder: (_, i) {
                  final assetPath = stickers[i];
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(interstitialAdManagerProvider.notifier)
                          .checkAndDisplayAd();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BuiltInPacksDetailView(pack: pack),
                        ),
                      );
                    },
                    child: Image.asset(assetPath),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

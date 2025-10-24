import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:wa_sticker_maker/core/constants/constants.dart';
import 'package:wa_sticker_maker/core/utils/utils.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '../../built_in_packs_detail/view/built_in_packs_detail_view.dart';

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

    if (packs.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'Sticker Packs'),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Column(
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
                  child: ListView.separated(
                    itemCount: packs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: kGap),
                    itemBuilder: (context, index) {
                      final pack = packs[index];
                      final stickers = pack.stickers.take(5).toList();
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: kGap,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pack.name,
                                  style: titleMediumStyle.copyWith(
                                    color: AppColors.kWhite,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BuiltInPacksDetailView(pack: pack),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: AppDecorations.simpleRounded(
                                      context,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kElementGap,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      'See All',
                                      style: bodySmallStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: primaryIcon(context),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: stickers.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 4),
                                itemBuilder: (_, i) {
                                  final url = stickers[i];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              BuiltInPacksDetailView(
                                                pack: pack,
                                              ),
                                        ),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: url,
                                      errorWidget: (c, u, e) =>
                                          Lottie.asset(Assets.imageLottie),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

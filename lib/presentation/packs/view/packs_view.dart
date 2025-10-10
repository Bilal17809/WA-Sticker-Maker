import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/ad_manager/ad_manager.dart';
import '/core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/pack_gallery/view/pack_gallery_view.dart';

class PacksView extends ConsumerStatefulWidget {
  const PacksView({super.key});
  @override
  ConsumerState<PacksView> createState() => _PacksViewState();
}

class _PacksViewState extends ConsumerState<PacksView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(interstitialAdManagerProvider.notifier).checkAndDisplayAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final packs = ref.watch(packsProvider);
    final interstitialState = ref.watch(interstitialAdManagerProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'Your Packs'),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: packs.isEmpty
            ? Center(
                child: Text(
                  'No packs yet.\nTap + to create a new pack.',
                  style: titleSmallStyle.copyWith(color: AppColors.kWhite),
                  textAlign: TextAlign.center,
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(kBodyHp),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: kGap,
                          mainAxisSpacing: kGap,
                          childAspectRatio: 1,
                        ),
                    itemCount: packs.length,
                    itemBuilder: (context, index) {
                      final pack = packs[index];
                      return GestureDetector(
                        onLongPress: () => ref
                            .read(packsProvider.notifier)
                            .deletePack(context, pack),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PackGalleryView(pack: pack),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(kBodyHp),
                          decoration: AppDecorations.simpleRounded(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: kGap / 2,
                            children: [
                              Expanded(
                                child: pack.stickerPaths.isEmpty
                                    ? Icon(
                                        Icons.folder,
                                        size: primaryIcon(context),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          kElementGap,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Image.file(
                                            File(pack.stickerPaths.first),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              Text(
                                pack.name,
                                style: titleSmallStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () => ref.read(packsProvider.notifier).addNewPack(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: interstitialState.isShow
          ? const SizedBox()
          : const BannerAdWidget(),
    );
  }
}

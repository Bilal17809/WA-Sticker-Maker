import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_sticker_maker/presentation/report/view/report_view.dart';
import '/presentation/ai_pack_gallery/view/ai_pack_gallery_view.dart';
import '/core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/ad_manager/ad_manager.dart';

class AiPacksView extends ConsumerWidget {
  const AiPacksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(aiPacksProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(
        title: 'Your Packs',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kGap),
            child: IconActionButton(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportView()),
              ),
              icon: Icons.report,
            ),
          ),
        ],
      ),
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
                            .read(aiPacksProvider.notifier)
                            .deletePack(context, pack),
                        onTap: () {
                          ref
                              .read(interstitialAdManagerProvider.notifier)
                              .checkAndDisplayAd();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AiPackGalleryView(pack: pack),
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
        onPressed: () => ref.read(aiPacksProvider.notifier).addNewPack(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

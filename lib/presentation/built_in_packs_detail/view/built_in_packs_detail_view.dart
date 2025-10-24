import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import '/core/utils/utils.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';
import '/core/providers/providers.dart';
import 'widgets/built_in_packs_gallery_view.dart';

class BuiltInPacksDetailView extends ConsumerWidget {
  final BuiltInPacksState pack;
  const BuiltInPacksDetailView({required this.pack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stickers = pack.stickers;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: pack.name),
      body: Stack(
        children: [
          Container(
            decoration: AppDecorations.bgContainer(context),
            child: SafeArea(
              child: GridView.builder(
                padding: const EdgeInsets.all(kBodyHp),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: kGap,
                  mainAxisSpacing: kGap,
                ),
                itemCount: stickers.length,
                itemBuilder: (context, index) {
                  final url = stickers[index];
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(builtInPacksDetailProvider.notifier)
                          .setIndex(index);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          barrierColor: AppColors.kBlack.withValues(
                            alpha: 0.75,
                          ),
                          pageBuilder: (_, _, _) =>
                              BuiltInPacksGalleryView(images: stickers),
                          transitionsBuilder: (_, animation, _, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kGap),
                      child: Container(
                        decoration: AppDecorations.simpleRounded(context),
                        padding: const EdgeInsets.all(kBodyHp),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (c, u, e) =>
                              Center(child: Lottie.asset(Assets.imageLottie)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: context.screenWidth * 0.1,
            right: context.screenWidth * 0.1,
            bottom: context.screenHeight * 0.1,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: AppColors.kGreen,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: kGap,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Add To WhatsApo",
                          style: titleMediumStyle.copyWith(
                            color: AppColors.kWhite,
                          ),
                        ),
                      ),
                      Image.asset(
                        Assets.whatsAppCircularLogo,
                        color: AppColors.kWhite,
                        width: secondaryIcon(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '/ad_manager/ad_manager.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/services/connectivity_service.dart';

final _promptProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class AiImageView extends ConsumerStatefulWidget {
  final AiPacksState pack;
  const AiImageView({super.key, required this.pack});

  @override
  ConsumerState<AiImageView> createState() => _AiImageViewState();
}

class _AiImageViewState extends ConsumerState<AiImageView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(interstitialAdManagerProvider.notifier).checkAndDisplayAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(freepikImageNotifierProvider);
    final notifier = ref.read(freepikImageNotifierProvider.notifier);
    final promptController = ref.watch(_promptProvider);
    final interstitialState = ref.watch(interstitialAdManagerProvider);
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
            onRetry: () async {},
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.secondary(context),
      extendBodyBehindAppBar: true,
      appBar: TitleBar(
        title: 'AI Sticker Generator',
        actions: [
          state.selectedImageIndices.isNotEmpty
              ? IconActionButton(
                  onTap: () async {
                    final success = await notifier.downloadAndAddToPack(
                      widget.pack,
                    );
                    if (success && context.mounted) {
                      SimpleToast.showToast(
                        context: context,
                        message: 'Images added to pack',
                      );
                      Navigator.pop(context);
                    }
                  },
                  icon: state.isDownloading
                      ? Icons.hourglass_bottom
                      : Icons.downloading,
                )
              : IconActionButton(
                  onTap: () => SimpleToast.showToast(
                    context: context,
                    message: 'Please select images to add',
                  ),
                  icon: Icons.add,
                ),
        ],
      ),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Column(
              spacing: kElementGap,
              children: [
                InputField(controller: promptController),
                Row(
                  spacing: kGap,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                final prompt = promptController.text.trim();
                                if (prompt.isEmpty) return;
                                notifier.generate(
                                  prompt,
                                  aspectRatio: 'square_1_1',
                                );
                              },
                        child: state.isLoading
                            ? SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.kWhite,
                                ),
                              )
                            : Text(
                                'Generate',
                                style: titleSmallStyle.copyWith(
                                  color: AppColors.kWhite,
                                ),
                              ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : notifier.clear,
                      child: Text(
                        'Clear',
                        style: titleSmallStyle.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.error != null)
                  Expanded(
                    child: Text(
                      state.error!,
                      style: titleSmallStyle.copyWith(color: AppColors.kWhite),
                    ),
                  ),
                if (!state.isLoading &&
                    state.images.isEmpty &&
                    state.error == null)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No images in the pack yet.\nGenerate an image',
                        textAlign: TextAlign.center,
                        style: titleSmallStyle.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                    ),
                  ),
                if (state.images.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: kGap,
                            crossAxisSpacing: kGap,
                          ),
                      itemCount: state.images.length,
                      itemBuilder: (context, index) {
                        final item = state.images[index];
                        final bytes = Base64Utils.maybeDecode(item);
                        final isSelected = state.selectedImageIndices.contains(
                          index,
                        );

                        return GestureDetector(
                          onTap: () => notifier.selectImage(index),
                          child: Container(
                            decoration: AppDecorations.simpleRounded(context),
                            padding: const EdgeInsets.all(kBodyHp),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    kElementGap,
                                  ),
                                  child: (bytes != null)
                                      ? Image.memory(
                                          bytes,
                                          fit: BoxFit.scaleDown,
                                        )
                                      : Center(
                                          child: Lottie.asset(
                                            Assets.imageLottie,
                                          ),
                                        ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: -8,
                                    right: -6,
                                    child: Icon(Icons.check_circle),
                                  ),
                              ],
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
      ),
      bottomNavigationBar: interstitialState.isShow
          ? const SizedBox()
          : const BannerAdWidget(),
    );
  }
}

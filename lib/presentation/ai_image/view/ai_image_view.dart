import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wa_sticker_maker/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';
import '/core/common_widgets/common_widgets.dart';

final _promptProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class AiImageView extends ConsumerWidget {
  final AiPacksState pack;
  const AiImageView({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(freepikImageNotifierProvider);
    final notifier = ref.read(freepikImageNotifierProvider.notifier);
    final promptController = ref.watch(_promptProvider);

    return Scaffold(
      backgroundColor: AppColors.secondary(context),
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'AI Sticker Generator'),
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
                        return Container(
                          decoration: AppDecorations.simpleRounded(context),
                          padding: const EdgeInsets.all(kBodyHp),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(kElementGap),
                            child: (bytes != null)
                                ? Image.memory(bytes, fit: BoxFit.scaleDown)
                                : Center(
                                    child: Lottie.asset(Assets.imageLottie),
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
    );
  }
}

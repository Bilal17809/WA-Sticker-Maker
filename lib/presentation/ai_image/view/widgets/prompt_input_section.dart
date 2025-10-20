import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/providers/providers.dart';
import '/core/common_widgets/common_widgets.dart';

final _promptProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class PromptInputSection extends ConsumerWidget {
  const PromptInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptController = ref.watch(_promptProvider);
    final state = ref.watch(freepikImageNotifierProvider);
    final notifier = ref.read(freepikImageNotifierProvider.notifier);

    return Column(
      spacing: kGap,
      children: [
        InputField(controller: promptController),
        Row(
          spacing: kGap,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        final prompt = promptController.text.trim();
                        if (prompt.isEmpty) {
                          SimpleToast.showToast(
                            context: context,
                            message: 'Please enter a prompt',
                          );
                          return;
                        }
                        await notifier.generate(
                          prompt,
                          aspectRatio: 'square_1_1',
                          context: context,
                        );
                      },
                child: state.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
                style: titleSmallStyle.copyWith(color: AppColors.kWhite),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

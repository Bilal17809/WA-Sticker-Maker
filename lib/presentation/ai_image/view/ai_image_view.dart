import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_sticker_maker/core/constants/constants.dart';
import 'package:wa_sticker_maker/core/theme/theme.dart';
import '/core/providers/providers.dart';
import '/core/common_widgets/common_widgets.dart';

final _promptProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

class AiImageView extends ConsumerWidget {
  const AiImageView({super.key});

  Uint8List? _maybeDecode(String s) {
    try {
      if (s.startsWith('data:')) {
        final parts = s.split(',');
        if (parts.length > 1) {
          return base64.decode(parts.last);
        }
      } else if (RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(s) ||
          RegExp(r'^[A-Za-z0-9+/=\s]+$').hasMatch(s)) {
        return base64.decode(s.replaceAll('\n', ''));
      }
    } catch (_) {}
    return null;
  }

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
                            : const Text('Generate'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : notifier.clear,
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                if (state.error != null)
                  Expanded(child: Text(state.error!, style: titleSmallStyle)),
                if (!state.isLoading &&
                    state.images.isEmpty &&
                    state.error == null)
                  const Expanded(child: Center(child: Text('No images'))),
                if (state.images.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemCount: state.images.length,
                      itemBuilder: (context, index) {
                        final item = state.images[index];
                        final bytes = _maybeDecode(item);
                        if (bytes != null) {
                          return Image.memory(bytes, fit: BoxFit.scaleDown);
                        }
                        if (item.startsWith('http')) {
                          return Image.network(item, fit: BoxFit.scaleDown);
                        }
                        return Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Text(item, textAlign: TextAlign.center),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

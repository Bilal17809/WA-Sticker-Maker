import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/constants.dart';
import '/core/utils/utils.dart';
import '/core/providers/providers.dart';
import 'widgets.dart';

class ImageGrid extends ConsumerWidget {
  const ImageGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(freepikImageNotifierProvider);
    final notifier = ref.read(freepikImageNotifierProvider.notifier);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: kGap,
        crossAxisSpacing: kGap,
      ),
      itemCount: state.images.length,
      itemBuilder: (context, index) {
        final item = state.images[index];
        final bytes = Base64Utils.maybeDecode(item);
        final isSelected = state.selectedImageIndices.contains(index);

        return ImageTile(
          imageBytes: bytes,
          isSelected: isSelected,
          onTap: () => notifier.selectImage(index),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/theme/theme.dart';
import '/core/providers/providers.dart';
import 'widgets.dart';

class ImagesSection extends ConsumerWidget {
  const ImagesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(freepikImageNotifierProvider);

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: titleSmallStyle.copyWith(color: AppColors.kWhite),
        ),
      );
    }

    if (!state.isLoading && state.images.isEmpty) {
      return Center(
        child: Text(
          'No images in the pack yet.\nGenerate an image',
          textAlign: TextAlign.center,
          style: titleSmallStyle.copyWith(color: AppColors.kWhite),
        ),
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return const ImageGrid();
  }
}

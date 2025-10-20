import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/ai_pack/provider/ai_packs_state.dart';
import '/core/providers/providers.dart';
import '/core/common_widgets/common_widgets.dart';

class DownloadOrAddButton extends ConsumerWidget {
  final AiPacksState pack;
  const DownloadOrAddButton({super.key, required this.pack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(freepikImageNotifierProvider);
    final notifier = ref.read(freepikImageNotifierProvider.notifier);

    if (state.selectedImageIndices.isNotEmpty) {
      return IconActionButton(
        onTap: () async {
          final success = await notifier.downloadAndAddToPack(pack);
          if (success && context.mounted) {
            SimpleToast.showToast(
              context: context,
              message: 'Images added to pack',
            );
            Navigator.pop(context);
          }
        },
        icon: state.isDownloading ? Icons.hourglass_bottom : Icons.downloading,
      );
    } else {
      return IconActionButton(
        onTap: () => SimpleToast.showToast(
          context: context,
          message: 'Please select images to add',
        ),
        icon: Icons.add,
      );
    }
  }
}

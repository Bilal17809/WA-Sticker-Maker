import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '/core/constants/constants.dart';
import '/core/theme/app_styles.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';

class GalleryView extends ConsumerWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(galleryProvider);
    final galleryNotifier = ref.read(galleryProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'Edit Image'),
      body: Center(
        child: galleryState.originalFile == null
            ? Text('No Image Selected', style: bodyLargeStyle)
            : CheckerBackground(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: kElementGap,
                    children: [
                      Flexible(
                        child: Image.file(
                          galleryState.editedFile ?? galleryState.originalFile!,
                        ),
                      ),
                      IconActionButton(
                        onTap: () => galleryNotifier.rotate(),
                        icon: Icons.rotate_right_rounded,
                        size: smallIcon(context),
                      ),
                      galleryState.isSaving
                          ? const CircularProgressIndicator()
                          : AppElevatedButton(
                              onPressed: () async {
                                await galleryNotifier.saveAsWebP(
                                  'sticker_${DateTime.now().millisecondsSinceEpoch}',
                                );
                                if (!context.mounted) return;
                                SimpleToast.showCustomToast(
                                  context: context,
                                  message: 'Saved as WebP!',
                                );
                              },
                              icon: Icons.save,
                              label: 'Save as WebP',
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

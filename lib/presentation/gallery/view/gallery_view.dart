import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import '/presentation/packs/provider/packs_state.dart';
import '/core/configs/editor_config.dart';
import '/core/theme/theme.dart';
import '/core/constants/constants.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';

class GalleryView extends ConsumerWidget {
  final PacksState pack;
  const GalleryView({super.key, required this.pack});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(galleryProvider);
    final galleryNotifier = ref.read(galleryProvider.notifier);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'Edit Image - ${pack.name}'),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: Center(
          child: galleryState.originalFile == null
              ? Text('No Image Selected', style: bodyLargeStyle)
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: kBodyHp),
                    child: Column(
                      spacing: kElementGap,
                      children: [
                        CheckerBackground(
                          child: SizedBox(
                            width: 512,
                            height: 512,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.file(
                                galleryState.editedFile ??
                                    galleryState.originalFile!,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: kElementGap,
                            children: [
                              IconActionButton(
                                onTap: () => _openImageEditor(context, ref),
                                icon: Icons.edit_rounded,
                                backgroundColor: AppColors.primary(context),
                                size: secondaryIcon(context),
                              ),
                              IconActionButton(
                                onTap: () => galleryNotifier.resetToOriginal(),
                                icon: Icons.restore_rounded,
                                backgroundColor: AppColors.primary(context),
                                size: secondaryIcon(context),
                              ),
                              galleryState.isSaving
                                  ? const CircularProgressIndicator()
                                  : IconActionButton(
                                      onTap: () async {
                                        await galleryNotifier.saveAsWebPToPack(
                                          pack,
                                          'sticker_${DateTime.now().millisecondsSinceEpoch}',
                                        );
                                        if (!context.mounted) return;
                                        SimpleToast.showCustomToast(
                                          context: context,
                                          message: 'Saved as WebP!',
                                        );
                                      },
                                      icon: Icons.save_alt,
                                      backgroundColor: AppColors.primary(
                                        context,
                                      ),
                                      size: secondaryIcon(context),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _openImageEditor(BuildContext context, WidgetRef ref) async {
    final galleryState = ref.read(galleryProvider);
    final file = galleryState.editedFile ?? galleryState.originalFile;
    if (file == null) return;
    final editedImage = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.file(
          file,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (bytes) async {
              Navigator.pop(context, bytes);
            },
          ),
          configs: EditorConfig.config,
        ),
      ),
    );
    if (editedImage != null) {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.png';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(editedImage);
      ref.read(galleryProvider.notifier).updateEditedFile(tempFile);
    }
  }
}

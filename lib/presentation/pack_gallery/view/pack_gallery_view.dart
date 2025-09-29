import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/packs/provider/packs_state.dart';
import '/presentation/gallery/provider/gallery_provider.dart';
import '/presentation/gallery/view/gallery_view.dart';

class PackGalleryView extends ConsumerWidget {
  final PacksState pack;
  const PackGalleryView({super.key, required this.pack});

  Future<void> _addNewImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final galleryNotifier = ref.read(galleryProvider.notifier);
    galleryNotifier.updateEditedFile(File(pickedFile.path));

    // Open editor
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GalleryView(pack: pack)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(packsProvider);
    final currentPack = packs.firstWhere(
      (p) => p.directoryPath == pack.directoryPath,
    );

    return Scaffold(
      appBar: AppBar(title: Text(pack.name)),
      body: currentPack.stickerPaths.isEmpty
          ? Center(
              child: Text(
                'No stickers yet.\nTap + to add one.',
                style: bodyLargeStyle,
                textAlign: TextAlign.center,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(kBodyHp),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: kGap,
                  mainAxisSpacing: kGap,
                  childAspectRatio: 1,
                ),
                itemCount: currentPack.stickerPaths.length,
                itemBuilder: (context, index) {
                  final path = currentPack.stickerPaths[index];
                  return Container(
                    decoration: AppDecorations.simpleDecor(context),
                    child: Image.file(File(path), fit: BoxFit.cover),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewImage(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

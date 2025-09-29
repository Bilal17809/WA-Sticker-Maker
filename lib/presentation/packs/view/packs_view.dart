import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wa_sticker_maker/presentation/pack_gallery/view/pack_gallery_view.dart';
import '/core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/gallery/view/gallery_view.dart';
import '/presentation/packs/provider/packs_provider.dart';
import '/presentation/packs/provider/packs_state.dart';

class PacksView extends ConsumerWidget {
  const PacksView({super.key});

  Future<String?> _createPackDirectory(String packName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final packDir = Directory('${dir.path}/$packName');
      if (!await packDir.exists()) await packDir.create(recursive: true);
      return packDir.path;
    } catch (e) {
      debugPrint('Error creating pack directory: $e');
      return null;
    }
  }

  Future<void> _addNewPack(BuildContext context, WidgetRef ref) async {
    final packNameController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Pack'),
        content: TextField(
          controller: packNameController,
          decoration: const InputDecoration(hintText: 'Enter pack name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, packNameController.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final dirPath = await _createPackDirectory(result);
      if (dirPath != null) {
        ref
            .read(packsProvider.notifier)
            .addPack(
              PacksState(
                name: result,
                directoryPath: dirPath,
                stickerPaths: [],
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = ref.watch(packsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Packs')),
      body: packs.isEmpty
          ? Center(
              child: Text(
                'No packs yet.\nTap + to create a new pack.',
                style: bodyLargeStyle,
                textAlign: TextAlign.center,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(kBodyHp),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: kGap,
                  mainAxisSpacing: kGap,
                  childAspectRatio: 1,
                ),
                itemCount: packs.length,
                itemBuilder: (context, index) {
                  final pack = packs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PackGalleryView(pack: pack),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(kGap),
                      decoration: AppDecorations.simpleDecor(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: pack.stickerPaths.isEmpty
                                ? const Icon(Icons.folder, size: 48)
                                : Image.file(
                                    File(pack.stickerPaths.first),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: kGap / 2),
                          Text(
                            pack.name,
                            style: titleSmallStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewPack(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

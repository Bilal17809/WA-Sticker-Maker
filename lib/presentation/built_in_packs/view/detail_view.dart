import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/presentation/built_in_packs/provider/built_in_packs_state.dart';

class DetailView extends ConsumerWidget {
  final BuiltInPacksState pack;
  const DetailView({required this.pack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stickers = pack.stickers;
    return Scaffold(
      appBar: AppBar(title: Text(pack.name)),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: stickers.length,
        itemBuilder: (context, index) {
          final url = stickers[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (c, u) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (c, u, e) => const Icon(Icons.broken_image),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/providers/providers.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(libraryProvider.notifier);
      if (!libraryState.isLoading && libraryState.emojis.isEmpty) {
        notifier.loadEmojis();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TitleBar(title: 'Emoji Library'),
      body: Container(
        decoration: AppDecorations.bgContainer(context),
        child: libraryState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : libraryState.emojis.isEmpty
            ? const Center(
                child: Text('No emojis loaded', textAlign: TextAlign.center),
              )
            : SafeArea(
                child: GridView.builder(
                  padding: const EdgeInsets.all(kBodyHp),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: kGap,
                    mainAxisSpacing: kGap,
                  ),
                  itemCount: libraryState.emojis.length,
                  itemBuilder: (context, index) {
                    final emoji = libraryState.emojis[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

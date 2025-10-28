import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/providers/providers.dart';

class BuiltInPacksGalleryView extends ConsumerWidget {
  final List<String> images;
  const BuiltInPacksGalleryView({required this.images, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(builtInPacksGalleryProvider);
    final notifier = ref.read(builtInPacksGalleryProvider.notifier);
    final controller = PageController(initialPage: state.currentIndex);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(images[index]),
                initialScale: PhotoViewComputedScale.contained * 0.9,
                minScale: PhotoViewComputedScale.contained * 0.7,
                maxScale: PhotoViewComputedScale.contained * 0.9,
              );
            },
            pageController: controller,
            onPageChanged: notifier.setIndex,
            scrollPhysics: const ClampingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: AppColors.transparent,
            ),
          ),
          Positioned(
            top: context.screenHeight * 0.3,
            left: 20,
            child: GlassButton(
              onTap: () => Navigator.pop(context),
              icon: Icons.close,
            ),
          ),
        ],
      ),
    );
  }
}

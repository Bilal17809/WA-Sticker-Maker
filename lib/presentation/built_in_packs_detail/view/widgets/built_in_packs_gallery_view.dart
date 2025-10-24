import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wa_sticker_maker/core/common_widgets/buttons.dart';
import 'package:wa_sticker_maker/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/providers/providers.dart';

class BuiltInPacksGalleryView extends ConsumerWidget {
  final List<String> images;
  const BuiltInPacksGalleryView({required this.images, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(builtInPacksDetailProvider);
    final notifier = ref.read(builtInPacksDetailProvider.notifier);
    final controller = PageController(initialPage: state.currentIndex);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(images[index]),
                minScale: PhotoViewComputedScale.contained * 0.7,
                maxScale: PhotoViewComputedScale.contained,
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
            left: 16,
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

import 'package:flutter/material.dart';
import '/core/providers/providers.dart';
import 'package:wa_sticker_maker/presentation/library/view/library_view.dart';
import '/presentation/gallery/view/gallery_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeCarousel extends ConsumerWidget {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yogaItems = [
      {'title': 'Gallery', 'icon': Icons.image, 'assetPath': Assets.appIcon},
      {
        'title': 'Library',
        'icon': Icons.emoji_emotions,
        'assetPath': Assets.appIcon,
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.3,
        viewportFraction: 0.6,
        enlargeCenterPage: true,
      ),
      items: yogaItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _CategoryCard(
          title: item['title'] as String,
          icon: Icon(item['icon'] as IconData),
          assetPath: item['assetPath'] as String,
          onTap: () async {
            if (index == 0) {
              await ref.read(galleryProvider.notifier).pickImage();
              if (ref.read(galleryProvider).originalFile != null) {
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryView()),
                );
              }
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LibraryView()),
              );
            }
          },
        );
      }).toList(),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final String assetPath;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kBodyHp),
        decoration: AppDecorations.simpleDecor(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(assetPath, width: primaryIcon(context)),
              ),
            ),
            const SizedBox(height: kGap),
            Text(title, style: titleSmallStyle),
            const SizedBox(height: kGap / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.kWhite.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}

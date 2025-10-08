import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '/presentation/library_pack/view/library_pack_view.dart';
import '/presentation/packs/view/packs_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';

class HomeCarousel extends ConsumerWidget {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.3,
        viewportFraction: 0.6,
        enlargeCenterPage: true,
      ),
      items: CarouselUtil.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _CategoryCard(
          title: item['title'] as String,
          lottiePath: item['lottiePath'] as String,
          onTap: () async {
            if (!context.mounted) return;
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PacksView()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LibraryPacksView(),
                ),
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
  final String lottiePath;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.lottiePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kBodyHp),
        decoration: AppDecorations.gradientDecor(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Lottie.asset(lottiePath)),
            const SizedBox(height: kGap),
            Text(
              title,
              style: titleSmallStyle.copyWith(color: AppColors.kWhite),
            ),
          ],
        ),
      ),
    );
  }
}

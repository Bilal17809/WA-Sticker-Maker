import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';

class ImageTile extends StatelessWidget {
  final Uint8List? imageBytes;
  final bool isSelected;
  final VoidCallback onTap;

  const ImageTile({
    super.key,
    required this.imageBytes,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppDecorations.simpleRounded(context),
        padding: const EdgeInsets.all(kBodyHp),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(kElementGap),
              child: imageBytes != null
                  ? Image.memory(imageBytes!, fit: BoxFit.scaleDown)
                  : Center(child: Lottie.asset(Assets.imageLottie)),
            ),
            if (isSelected)
              const Positioned(
                top: -8,
                right: -6,
                child: Icon(Icons.check_circle),
              ),
          ],
        ),
      ),
    );
  }
}

import '/core/theme/theme.dart';
import '/core/constants/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class LottieWidget extends StatelessWidget {
  final String assetPath;
  final bool? isMessage;
  final String? message;
  const LottieWidget({
    super.key,
    this.message,
    required this.assetPath,
    this.isMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kGap,
      children: [
        Lottie.asset(assetPath, width: context.screenWidth * 0.2),
        isMessage!
            ? Text(
                message ?? 'No results found.',
                style: titleSmallStyle.copyWith(color: AppColors.kWhite),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

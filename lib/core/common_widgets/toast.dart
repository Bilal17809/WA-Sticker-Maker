import 'package:flutter/material.dart';
import '/core/constants/constants.dart';
import '/core/theme/app_styles.dart';
import '/core/theme/app_colors.dart';

class SimpleToast {
  static void showToast({
    required BuildContext context,
    required String message,
    IconData? icon,
    String? imagePath,
    Color? iconColor,
    double? verticalMargin,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (imagePath != null)
              ? Flexible(child: Image.asset(imagePath, height: 20, width: 20))
              : const SizedBox.shrink(),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: bodyMediumStyle.copyWith(color: AppColors.kWhite),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.kDarkGrey.withValues(alpha: 0.75),
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.165,
        vertical: verticalMargin ?? 0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

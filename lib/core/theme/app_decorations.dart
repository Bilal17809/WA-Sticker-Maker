import 'package:flutter/material.dart';
import 'theme.dart';
import '/core/constants/constants.dart';

class AppDecorations {
  static BoxDecoration bgContainer(BuildContext context) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.primary(context), AppColors.secondary(context)],
    ),
  );

  static BoxDecoration simpleRounded(BuildContext context) => BoxDecoration(
    color: AppColors.container(context),
    borderRadius: BorderRadius.circular(kBorderRadius),
    border: Border.all(color: AppColors.container(context)),
  );

  static BoxDecoration gradientDecor(BuildContext context) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: context.isDark
          ? [
              AppColors.kWhite.withValues(alpha: 0.08),
              AppColors.kWhite.withValues(alpha: 0.06),
            ]
          : [AppColors.secondaryColorLight, AppColors.primaryColorLight],
      stops: const [0.3, 0.95],
    ),
    borderRadius: BorderRadius.circular(kBorderRadius),
  );
}

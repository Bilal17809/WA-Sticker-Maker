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

  static BoxDecoration topRounded(BuildContext context) => BoxDecoration(
    color: AppColors.container(context),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(kBorderRadius),
      topRight: Radius.circular(kBorderRadius),
    ),
    border: Border.all(color: AppColors.container(context)),
  );

  static BoxDecoration roundedIcon(BuildContext context) => BoxDecoration(
    color: AppColors.secondary(context),
    borderRadius: BorderRadius.circular(kCircularBorderRadius),
  );

  static BoxDecoration simpleDecor(BuildContext context) => BoxDecoration(
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

  static BoxDecoration highlight(
    BuildContext context, {
    required bool isExample,
  }) => BoxDecoration(
    color: isExample
        ? AppColors.container(context).withValues(alpha: 0.25)
        : AppColors.container(context),
    borderRadius: BorderRadius.circular(kBorderRadius),
    border: Border.all(color: AppColors.primary(context)),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary(context).withValues(alpha: 0.2),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration option({
    required bool isCorrect,
    required bool isWrong,
  }) {
    return BoxDecoration(
      color: isCorrect
          ? AppColors.kGreen.withValues(alpha: 0.25)
          : isWrong
          ? AppColors.kRed.withValues(alpha: 0.25)
          : AppColors.transparent,
      border: Border.all(
        color: isCorrect
            ? AppColors.kGreen
            : isWrong
            ? AppColors.kRed
            : AppColors.kGrey.withValues(alpha: 0.75),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

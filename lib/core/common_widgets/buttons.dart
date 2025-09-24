import 'package:flutter/material.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';

class GlassButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final double width;
  final VoidCallback? onTap;

  const GlassButton({
    super.key,
    this.icon,
    this.text,
    this.width = 30,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 34,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.6),
        ),
        child: Center(
          child:
              icon != null
                  ? Icon(icon, size: 18)
                  : Text(
                    text ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final double? height;
  final double? width;
  final Color? backgroundColor;

  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.height,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: titleSmallStyle),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 0, height ?? 50),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? shadowColor;

  const SimpleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.textColor,
    this.backgroundColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = width ?? double.infinity;
    final double buttonHeight = height ?? 48;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -8,
          right: -8,
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: shadowColor ?? AppColors.kBlack,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: titleSmallStyle.copyWith(
                color: textColor ?? AppColors.kWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IconActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool isCircular;
  final String? tooltip;

  const IconActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.color,
    this.size,
    this.padding = const EdgeInsets.all(kGap),
    this.backgroundColor,
    this.isCircular = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? secondaryIcon(context);

    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius:
                isCircular ? null : BorderRadius.circular(kBorderRadius),
          ),
          child: Icon(
            icon,
            color: color ?? AppColors.icon(context),
            size: resolvedSize,
          ),
        ),
      ),
    );
  }
}

class ImageActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String assetPath;
  final Color? color;
  final double? size;
  final double? width;
  final double? height;
  final bool isCircular;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const ImageActionButton({
    super.key,
    this.onTap,
    required this.assetPath,
    this.color,
    this.size,
    this.width,
    this.isCircular = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              AppColors.secondary(context).withValues(alpha: 0.1),
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircular ? null : borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.kBlack.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: image),
      ),
    );
  }
}

class AppDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final TextStyle? textStyle;

  const AppDialogButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primaryText(context),
      ),
      child: Text(text, style: textStyle ?? titleSmallStyle),
    );
  }
}

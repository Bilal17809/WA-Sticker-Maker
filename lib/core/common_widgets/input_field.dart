import 'package:flutter/material.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputBorder? border;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Color? cursorColor;
  final Color? backgroundColor;
  final TextAlign textAlign;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    this.hintText = 'Enter text...',
    this.minLines = 1,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(kBodyHp),
    this.hintStyle,
    this.textStyle,
    this.border,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onSubmitted,
    this.cursorColor,
    this.backgroundColor,
    this.textAlign = TextAlign.start,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: cursorColor,
      textAlign: textAlign,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? AppColors.kWhite.withValues(alpha: 0.2),
        hintText: hintText,
        hintStyle: hintStyle ?? bodySmallStyle,
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(color: AppColors.primaryColorLight),
            ),
        enabledBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(color: AppColors.primaryColorLight),
            ),
        focusedBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(
                color: AppColors.primaryColorLight,
                width: 2,
              ),
            ),
      ),
      style:
          textStyle ??
          bodyLargeStyle.copyWith(
            color: AppColors.primaryColorLight,
            fontWeight: FontWeight.bold,
          ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}

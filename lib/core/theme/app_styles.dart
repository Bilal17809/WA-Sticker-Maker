import 'package:flutter/material.dart';

/// Text
TextStyle headlineLargeStyle = const TextStyle(
  fontSize: 52,
  fontWeight: FontWeight.w500,
  shadows: kShadow,
);

TextStyle headlineMediumStyle = const TextStyle(
  fontSize: 46,
  fontWeight: FontWeight.w500,
  shadows: kShadow,
);

TextStyle headlineSmallStyle = const TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  shadows: kShadow,
);

TextStyle titleMediumStyle = const TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
  shadows: kShadow,
);

TextStyle titleLargeStyle = const TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
  shadows: kShadow,
);

TextStyle titleSmallStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  shadows: kShadow,
);

TextStyle bodyLargeStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  shadows: kShadow,
);

TextStyle bodyMediumStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  shadows: kShadow,
);

TextStyle bodySmallStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  shadows: kShadow,
);

/// Shadows
const List<Shadow> kShadow = [
  Shadow(offset: Offset(0.1, 0.7), blurRadius: 3, color: Colors.black26),
];

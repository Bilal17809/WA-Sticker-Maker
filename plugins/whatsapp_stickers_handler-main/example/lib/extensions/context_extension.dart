import 'package:flutter/material.dart';

/// Theme extension on context
extension ThemeExtension on BuildContext {
  ///

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}

/// MediaQuery extension on context
extension MediaQueryExtension on BuildContext {
  ///

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}

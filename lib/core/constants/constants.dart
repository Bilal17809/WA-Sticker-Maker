import 'package:flutter/material.dart';

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kGap = 8.0;

/// ========== Border ==========
const double kCircularBorderRadius = 50.0;
const double kBorderRadius = 35.0;

/// ========== Icon Sizes ==========
double primaryIcon(BuildContext context) => context.screenWidth * 0.25;
double secondaryIcon(BuildContext context) => context.screenWidth * 0.07;
double smallIcon(BuildContext context) => context.screenWidth * 0.06;

/// ========== MediaQuery Helpers ==========
extension MediaQueryValues on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

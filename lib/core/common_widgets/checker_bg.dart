import 'package:flutter/material.dart';

class CheckerPainter extends CustomPainter {
  final double squareSize;
  final Color light;
  final Color dark;

  CheckerPainter({
    this.squareSize = 16,
    this.light = const Color(0xFFEFEFEF),
    this.dark = const Color(0xFFBDBDBD),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rows = (size.height / squareSize).ceil();
    final cols = (size.width / squareSize).ceil();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        paint.color = ((r + c) % 2 == 0) ? light : dark;
        final rect = Rect.fromLTWH(
          c * squareSize,
          r * squareSize,
          squareSize,
          squareSize,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CheckerPainter old) {
    return old.squareSize != squareSize ||
        old.light != light ||
        old.dark != dark;
  }
}

class CheckerBackground extends StatelessWidget {
  final double squareSize;
  final Color light;
  final Color dark;
  final Widget? child;

  const CheckerBackground({
    super.key,
    this.squareSize = 16,
    this.light = const Color(0xFFEFEFEF),
    this.dark = const Color(0xFFBDBDBD),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CheckerPainter(squareSize: squareSize, light: light, dark: dark),
      child: child ?? SizedBox.expand(),
    );
  }
}

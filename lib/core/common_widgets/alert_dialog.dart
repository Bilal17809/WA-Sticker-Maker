import 'package:flutter/material.dart';
import '/core/constants/constants.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool barrierDismissible;
  final double elevation;
  final double borderRadius;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.barrierDismissible = true,
    this.elevation = 4,
    this.borderRadius = kBorderRadius,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (_) => AppAlertDialog(
            title: title,
            content: content,
            actions: actions,
            barrierDismissible: barrierDismissible,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
}

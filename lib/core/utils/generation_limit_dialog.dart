import 'package:flutter/material.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/theme/theme.dart';

class GenerationLimitDialog {
  static Future<bool?> show(
    BuildContext context, {
    required int availableGenerations,
    required int limit,
  }) async {
    final remaining = limit - availableGenerations;
    final isLimitReached = remaining <= 0;
    return AppAlertDialog.show<bool>(
      context: context,
      barrierDismissible: false,
      title: 'AI Generation',
      content: Text(
        isLimitReached
            ? 'You have reached your free generation limit.\nWatch an ad to continue generating.'
            : 'You have $remaining free generations remaining.',
      ),
      actions: [
        AppDialogButton(
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppDialogButton(
          text: isLimitReached ? 'Show Ad' : 'Generate',
          textColor: AppColors.primary(context),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

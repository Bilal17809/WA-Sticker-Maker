import 'package:flutter/material.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/theme/theme.dart';

class DeleteStickerDialog {
  static Future<bool?> show(BuildContext context) async {
    return AppAlertDialog.show<bool>(
      context: context,
      barrierDismissible: false,
      title: "Delete Sticker",
      content: const Text("Are you sure you want to delete this sticker?"),
      actions: [
        AppDialogButton(
          text: "Cancel",
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppDialogButton(
          text: "Delete",
          textColor: AppColors.kRed,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

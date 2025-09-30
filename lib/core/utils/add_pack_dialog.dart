import 'package:flutter/material.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';

class AddPackDialog {
  static Future<String?> show(BuildContext context) async {
    final packNameController = TextEditingController();
    return AppAlertDialog.show<String>(
      context: context,
      barrierDismissible: false,
      title: "New Pack",
      content: InputField(
        controller: packNameController,
        hintText: 'Enter pack name',
        textStyle: titleSmallStyle,
      ),
      actions: [
        AppDialogButton(
          text: "Cancel",
          onPressed: () => Navigator.of(context).pop(null),
        ),
        AppDialogButton(
          text: "Create",
          onPressed: () => Navigator.of(context).pop(packNameController.text),
        ),
      ],
    );
  }
}

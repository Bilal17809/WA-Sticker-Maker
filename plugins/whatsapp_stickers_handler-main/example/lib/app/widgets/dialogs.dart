import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler_example/util/validators.dart';

class Dialogs {
  ///

  /// Template
  static void dialog({
    required final BuildContext context, // Context
    required final String title, // Title that is displayed at the top
    required final Map<String, Function()?> buttons, // Buttons
    final Widget? content, // Content that is displayed in the middle
  }) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(title),
            content: content,
            actions: [
              /// Buttons
              for (final button in buttons.entries)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    button.value != null ? button.value!() : null;
                  },
                  child: Text(button.key),
                ),
            ],
          ),
    );
  }

  /// Confirm dialog
  static void confirm({
    required final BuildContext context, // Context
    required final String title, // Title
    required final Function() onSubmit, // Function on submit
  }) {
    Dialogs.dialog(
      context: context,
      title: title,
      buttons: {'No': null, 'Yes': onSubmit},
    );
  }

  /// TextField dialog
  static void textField({
    required final BuildContext context, // Context
    required final String title, // Title that is displayed at the top
    final String? value, // Initial text
    required final Function(String) onSubmit, // Function on submit
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController(text: value);

    // Calls onSubmit if value has changed
    void submit() {
      if (!formKey.currentState!.validate()) return;

      Navigator.pop(context);
      String newValue = controller.text.trim();
      if (value != newValue) onSubmit(newValue);
    }

    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                validator: Validators.required,
                onFieldSubmitted: (_) => submit(),
              ),
            ),
            actions: [
              /// Buttons
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(onPressed: submit, child: Text('Ok')),
            ],
          ),
    );
  }

  /// Shows sticker
  static void showSticker({
    required final BuildContext context, // Context
    required final String sticker, // Sticker
  }) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) =>
              AlertDialog(content: Image.file(File(sticker))),
    );
  }

  /// Select image dialog
  static void selectSticker({
    required final BuildContext context, // Context
    required final String title, // Title that is displayed at the top
    required final List<String> stickers, // Stickers
    required final Function(String) onTap, // On tap
  }) {
    void submit(String sticker) {
      onTap(sticker);
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              for (final String sticker in stickers)
                GestureDetector(
                  onTap: () => submit(sticker),
                  child: GridTile(child: Image.file(File(sticker))),
                ),
            ],
          ),
        );
      },
    );
  }
}

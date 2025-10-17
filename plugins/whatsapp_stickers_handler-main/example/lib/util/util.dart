import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler_example/whatsapp_stickers_handler_example.dart';

/// Util methods
class Util {
  ///

  /// Prevents instances of Methods
  Util._();

  /// Pushes to the given page
  static void pushTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  /// Sends message as SnackBar
  static void showSnackBar(String message) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
    WhatsappStickersHandlerExample.scaffoldKey.currentState?.showSnackBar(
      snackBar,
    );
  }
}

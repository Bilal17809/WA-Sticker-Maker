import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler_example/extensions/context_extension.dart';

class EmptyIcon extends StatelessWidget {
  ///

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: context.height * 0.1),
      child: Icon(
        Icons.landscape,
        size: context.width * 0.8,
        color: context.colorScheme.primary,
      ),
    );
  }

  /// endregion build
}

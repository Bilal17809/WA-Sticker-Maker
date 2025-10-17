import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler_example/app/home/home.dart';

class WhatsappStickersHandlerExample extends StatelessWidget {
  ///

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp Stickers Handler Example',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff65e0d8),
          brightness: Brightness.dark,
        ),
      ),
      home: Home(),
    );
  }

  /// endregion build
}

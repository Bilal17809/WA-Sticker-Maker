import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/services/whatsapp_service.dart';

class ProvideStickerPackButton extends StatefulWidget {
  ///

  ProvideStickerPackButton(this.stickerPack);

  final StickerPack stickerPack;

  @override
  State<ProvideStickerPackButton> createState() => _AddStickerPackButtonState();
}

class _AddStickerPackButtonState extends State<ProvideStickerPackButton>
    with WidgetsBindingObserver {
  ///

  bool isInstalled = false;

  @override
  void initState() {
    super.initState();
    if (!isInstalled) {
      WidgetsBinding.instance.addObserver(this);
    }
    fetchIsInstalled();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Fetch again when resumed from WhatsApp popup
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!isInstalled && state == AppLifecycleState.resumed) {
      fetchIsInstalled();
    }
  }

  /// Fetches and assigns whether sticker pack is installed
  void fetchIsInstalled() async {
    bool newIsInstalled = await WhatsAppService.isStickerPackInstalled(
      widget.stickerPack.identifier,
    );
    setState(() => isInstalled = newIsInstalled);
  }

  /// Adds sticker pack to WhatsApp
  void addStickerPack() async {
    await WhatsAppService.addStickerPack(widget.stickerPack);
  }

  /// --------------------------------------------------------------------------
  /// region build
  /// --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isInstalled ? null : addStickerPack,
      icon: Icon(isInstalled ? Icons.check : Icons.add, color: Colors.green),
    );
  }

  ///
}

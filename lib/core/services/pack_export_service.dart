import 'dart:io';
import '/core/interface/pack_info_interface.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack_exception.dart';
import 'package:whatsapp_stickers_handler/service/sticker_pack_util.dart';
import '/core/exceptions/app_exceptions.dart';
import '/core/services/whatsapp_service.dart';

class PackExportService {
  String? _validate(PackInfoInterface pack) {
    if (pack.stickerPaths.length < 3) {
      return 'Need at least 3 stickers to export to WhatsApp.';
    }
    if (pack.stickerPaths.length > 30) {
      return 'WhatsApp sticker packs can contain maximum 30 stickers.';
    }
    return null;
  }

  Future<String?> _createTrayIcon(PackInfoInterface pack) async {
    try {
      if (pack.trayImagePath != null &&
          File(pack.trayImagePath!).existsSync()) {
        return await StickerPackUtil().saveWebpAsTrayImage(pack.trayImagePath!);
      }
      if (pack.stickerPaths.isNotEmpty) {
        return await StickerPackUtil().saveWebpAsTrayImage(
          pack.stickerPaths.first,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String> _addOrUpdatePack(StickerPack pack, String packName) async {
    final isPackInstalled = await WhatsAppService.isStickerPackInstalled(
      pack.identifier,
    );
    if (isPackInstalled) {
      WhatsAppService.updateStickerPack(pack);
      return 'Pack "$packName" updated in WhatsApp!';
    } else {
      WhatsAppService.addStickerPack(pack);
      return 'Pack "$packName" added to WhatsApp!';
    }
  }

  Future<String?> exportPack(PackInfoInterface pack) async {
    try {
      final validationError = _validate(pack);
      if (validationError != null) return validationError;
      final isInstalled = await WhatsAppService.isWhatsAppInstalled;
      if (!isInstalled) {
        return 'WhatsApp is not installed on this device.';
      }
      final identifier = pack.name.toLowerCase().replaceAll(
        RegExp(r'[^a-z0-9]'),
        '_',
      );
      final trayImagePath = await _createTrayIcon(pack);
      if (trayImagePath == null) {
        return 'Failed to create tray image.';
      }
      final stickerPack = StickerPack(
        identifier: identifier,
        name: pack.name,
        publisher: 'WA Sticker Maker',
        trayImage: trayImagePath,
        publisherWebsite: '',
        privacyPolicyWebsite: '',
        licenseAgreementWebsite: '',
      )..stickers = pack.stickerPaths;
      return await _addOrUpdatePack(stickerPack, pack.name);
    } on StickerPackException catch (_) {
      return AppExceptions.validationError;
    } catch (_) {
      return AppExceptions.exportError;
    }
  }
}

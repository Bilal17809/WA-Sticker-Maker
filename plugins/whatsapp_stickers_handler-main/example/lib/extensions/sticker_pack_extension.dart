import 'dart:convert';

import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';

extension StickerPackExtension on StickerPack {
  ///

  Map<String, dynamic> get toDb => {
    'identifier': identifier,
    'name': name,
    'publisher': publisher,

    'trayImage': trayImage,
    'stickers': jsonEncode(stickers),
    'animatedStickerPack': animatedStickerPack ? 1 : 0,

    'publisherEmail': publisherEmail,
    'publisherWebsite': publisherWebsite,
    'privacyPolicyWebsite': privacyPolicyWebsite,
    'licenseAgreementWebsite': licenseAgreementWebsite,
    'iosAppStoreLink': iosAppStoreLink,
    'androidPlayStoreLink': androidPlayStoreLink,
  }..removeWhere((key, value) => value == null);
}

extension StickerPackFactory on StickerPack {
  ///

  static StickerPack fromDb(Map<String, dynamic> json) {
    return StickerPack(
      identifier: json['identifier'] as String,
      name: json['name'] as String,
      publisher: json['publisher'] as String,

      trayImage: json['trayImage'] as String?,
      stickers: (jsonDecode(json['stickers'] as String) as List).cast<String>(),
      animatedStickerPack: json['animatedStickerPack'] == 1,

      publisherEmail: json['publisherEmail'] as String?,
      publisherWebsite: json['publisherWebsite'] as String?,
      privacyPolicyWebsite: json['privacyPolicyWebsite'] as String?,
      licenseAgreementWebsite: json['licenseAgreementWebsite'] as String?,
      iosAppStoreLink: json['iosAppStoreLink'] as String?,
      androidPlayStoreLink: json['androidPlayStoreLink'] as String?,
    );
  }
}

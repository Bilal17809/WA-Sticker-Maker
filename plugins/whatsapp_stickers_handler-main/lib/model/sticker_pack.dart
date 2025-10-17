/// A StickerPack that can be added to Whatsapp
///
/// For more information see the [WhatsApp docs](https://github.com/WhatsApp/stickers/tree/main/Android#modifying-the-contentsjson-file)
class StickerPack {
  ///

  StickerPack({
    required this.identifier,
    required this.name,
    required this.publisher,

    this.trayImage,
    List<String>? stickers,
    this.animatedStickerPack = false,

    this.publisherEmail,
    this.publisherWebsite,
    this.privacyPolicyWebsite,
    this.licenseAgreementWebsite,
    this.iosAppStoreLink,
    this.androidPlayStoreLink,
  }) : stickers = stickers ?? List.empty(growable: true);

  /// Unique id
  ///
  /// Alphanumeric and "_" and "-"
  /// 128 characters max
  String identifier;

  /// Name
  ///
  /// 128 characters max
  String name;

  /// Author name
  ///
  /// 128 characters max
  String publisher;

  /// Path to tray image png file
  ///
  /// Must be exactly 96x96 pixels (not enforced by Whatsapp)
  /// Can be up to 50KB
  String? trayImage;

  /// The paths to the sticker webp files
  ///
  /// A [StickerPack] has either static or animated stickers, but not mixed
  /// A sticker must be exactly 512x512 pixels
  /// A static sticker can be up to 100KB and an animated sticker up to 500KB
  /// The frame duration must be at least 8ms
  /// The animation duration can be up to 10 seconds
  List<String> stickers;

  /// If the [StickerPack] contains animated or static stickers
  bool animatedStickerPack;

  String? publisherEmail;
  String? publisherWebsite;
  String? privacyPolicyWebsite;
  String? licenseAgreementWebsite;
  String? iosAppStoreLink;
  String? androidPlayStoreLink;

  Map<String, dynamic> get json => {
    'identifier': identifier,
    'name': name,
    'publisher': publisher,

    'trayImage': trayImage,
    'stickers': stickers,
    'animatedStickerPack': animatedStickerPack,

    'publisherEmail': publisherEmail,
    'publisherWebsite': publisherWebsite,
    'privacyPolicyWebsite': privacyPolicyWebsite,
    'licenseAgreementWebsite': licenseAgreementWebsite,
    'iosAppStoreLink': iosAppStoreLink,
    'androidPlayStoreLink': androidPlayStoreLink,
  }..removeWhere((key, value) => value == null);
}

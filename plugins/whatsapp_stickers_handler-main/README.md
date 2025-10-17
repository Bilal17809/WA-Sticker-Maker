# Whatsapp Stickers Handler

This plugin provides functionality for dynamically adding and updating sticker packs to WhatsApp. It also includes helper functions that support creating valid stickers from user images.

## Features

### WhatsApp API

The plugin provides the following WhatsApp API functionality:

- Add a sticker pack to WhatsApp
- Update an existing sticker pack
- Check if sticker pack is available in WhatsApp
- Launch WhatsApp
- Check if WhatsApp is installed on device

### Sticker Creation and Validation

The plugin provides the following sticker functionality:

- Create and save stickers from images on the users device
  - Convert images to required file types
  - Scaling and compressing to comply with the WhatsApp API
- Sticker pack validation

## Usage

A functioning example app can be found [here](https://github.com/DennisJacob128/whatsapp_stickers_handler/tree/main/example).

### WhatsappStickersHandler

```dart
class WhatsAppService {
  static WhatsappStickersHandler whatsappStickersHandler =
      WhatsappStickersHandler();

  /// Returns if WhatsApp is installed
  static Future<bool> get isWhatsAppInstalled async {
    return await whatsappStickersHandler.isWhatsAppInstalled;
  }

  /// Launches WhatsApp
  static void launchWhatsApp() {
    whatsappStickersHandler.launchWhatsApp();
  }

  /// Checks if a sticker pack with the given [identifier] is available in
  /// WhatsApp
  static Future<bool> isStickerPackInstalled(String identifier) async {
    return await whatsappStickersHandler.isStickerPackInstalled(identifier);
  }
  
  /// Adds [stickerPack] to the sticker pack list that is exposed to WhatsApp
  /// and sends request to add the pack to Whatsapp
  static Future<void> addStickerPack(StickerPack stickerPack) async {
    await whatsappStickersHandler.addStickerPack(stickerPack);
  }

  /// Updates [stickerPack] in the sticker pack list that is exposed to WhatsApp
  static Future<void> updateStickerPack(StickerPack stickerPack) async {
    await whatsappStickersHandler.updateStickerPack(stickerPack);
  }

  /// Deletes sticker pack from the sticker pack list that is exposed to WhatsApp
  /// The sticker pack still needs to be deleted manually in the WhatsApp UI
  static Future<void> deleteStickerPack(String identifier) async {
    await whatsappStickersHandler.deleteStickerPack(identifier);
  }
}
```

The sticker pack validation is called automatically and might throw an exception so you should implement exception handling:

```dart
try {
  await whatsappStickersHandler.addStickerPack(stickerPack);
} on StickerPackException catch (e) {
  print(e.message);
} on PlatformException catch (e) {
  print(e.message ?? 'An unexpected error occurred');
}
```

### Create stickers and sticker packs

#### Create a sticker pack

```dart
StickerPack stickerPack = StickerPack(
  identifier: 'packIdentifier',
  name: 'packName',
  publisher: 'publisherName',
);
```

#### Create stickers

Create .webp stickers from the given image paths and save them to the given directory. You can also create a single sticker with the `createStickerFromImage()` function.

You can use [file_picker](https://pub.dev/packages/file_picker) or [image_picker](https://pub.dev/packages/image_picker) to get the images from the users phone. You can also use [path_provider](https://pub.dev/packages/path_provider) to get your apps application directory.

```dart
List<String> stickerWebpPaths = await StickerPackUtil().createStickersFromImages(
  ['externalDir/sticker1.jpg', 'externalDir/sticker2.png'],
  'myAppDir/myStickerPack',
);

stickerPack.stickers = stickerWebpPaths;
```


#### Create a tray image from a sticker

Create a .png from a .webp sticker and save it in the same directory.

```dart
String trayPngPath = await StickerPackUtil().saveWebpAsTrayImage(
  'myAppDir/myStickerPack/myStickerName.webp'
);

stickerPack.trayImage = trayPngPath;
```

#### Check if a sticker is animated

```dart
bool isAnimated = await StickerPackUtil().isStickerAnimated(
  'myAppDir/myStickerPack/myStickerName.webp'
);
```

### Sticker Pack Validation

Validate a sticker pack. This throws an exception if something is invalid.

```dart
try {
  StickerPackValidator.validateStickerPack(myStickerPack);
} on StickerPackException catch (e) {
  print(e.message);
}
```

## WhatsApp Stickers API

See the [WhatsApp documentation](https://github.com/WhatsApp/stickers/tree/main/Android) for more information.

## Android Platform Code

The docs for the Android platform code can be found [here](https://github.com/DennisJacob128/whatsapp_stickers_handler/blob/main/doc/android_platform_code.md).

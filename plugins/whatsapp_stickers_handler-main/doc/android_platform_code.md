# Android Platform Code

The Android platform code for this plugin is structured as follows:

```
Android Platform Code
│   WhatsappStickersHandler
│   WhatsappStickersHandlerService
│
└───model
│   │   StickerPack
│
└───servies
│   │   FileService
│   │   StickerPackStorageService
│   │   StickerPackValidator
|
└───whatsapp_api
    │   StickerContentProvider
    │   WhatsAppService
```

## root

### WhatsappStickersHandler

Handles MethodCalls (from Dart code) and calls the according `WhatsappStickersHandlerService` functions. Also handles method channel, activity results and the authority of the ContentProvider.

### WhatsappStickersHandlerService

Contains the functionality for the MethodCalls from`WhatsappStickersHandler`.

## /model

### StickerPack

The StickerPack model that is required by the WhatsApp API. Contains row and column setup for the ContentProvider.

## /services

### FileService

Contains functions to handle file names and get files from the file system.

### StickerPackStorageService

Stores all StickerPacks in a `sticker_packs.json`. This is the source of truth for the ContentProvider. Contains functions for adding, updating and deleting StickerPacks.

### StickerPackValidator

Functions for validating a StickerPack.

## /whatsapp_api

### WhatsAppService

Contains functionality to interact with WhatsApp. Creates intents to add StickerPacks and queries WhatsApp to check if a StickerPack is installed.

### StickerContentProvider

Provides endpoints for the StickerPacks from the `StickerPackStorageService` (which are saved in the `sticker_packs.json`) to WhatsApp. Resolves sticker file paths and returns the required data to WhatsApp.

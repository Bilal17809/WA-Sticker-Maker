import 'package:sqflite/sqflite.dart';
import 'package:whatsapp_stickers_handler/model/sticker_pack.dart';
import 'package:whatsapp_stickers_handler_example/extensions/sticker_pack_extension.dart';

class StickerStorageService {
  ///

  static const String databaseName = 'StickerPacks';

  static late final Database database;

  /// Opens database
  static Future<void> initialize() async {
    database = await openDatabase(
      '$databaseName.db',
      onCreate:
          (db, version) => db.execute('''
          CREATE TABLE StickerPacks(
            identifier TEXT PRIMARY KEY,
            name TEXT,
            publisher TEXT,
            
            trayImage TEXT,
            stickers TEXT,
            animatedStickerPack INTEGER,
            
            publisherEmail Text,
            publisherWebsite Text,
            privacyPolicyWebsite Text,
            licenseAgreementWebsite Text,
            iosAppStoreLink Text,
            androidPlayStoreLink Text
          )'''),
      version: 1,
    );
  }

  /// Returns all sticker packs
  static Future<List<StickerPack>> getAllStickerPacks() async {
    List<Map<String, dynamic>> stickerPacks = await database.query(
      databaseName,
    );
    return stickerPacks
        .map((stickerPack) => StickerPackFactory.fromDb(stickerPack))
        .toList();
  }

  /// Adds a sticker pack to the db
  static Future<void> addStickerPack(StickerPack stickerPack) async {
    await database.insert(databaseName, stickerPack.toDb);
  }

  /// Updates the sticker pack
  static Future<void> updateStickerPack(StickerPack stickerPack) async {
    await database.update(
      databaseName,
      stickerPack.toDb,
      where: 'identifier = "${stickerPack.identifier}"',
    );
  }

  /// Deletes the sticker pack with the given identifier
  static Future<void> deleteStickerPack(String identifier) async {
    await database.delete(databaseName, where: 'identifier = "$identifier"');
  }
}

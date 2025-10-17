package de.dennisjacob.whatsapp_stickers_handler

import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.util.PathUtils
import java.io.File
import java.io.FileReader
import java.io.FileWriter


/**
 * Saves StickerPacks information in sticker_packs.json
 */
public class StickerPackStorageService {
    companion object {
        val stickerPackListType = object : TypeToken<List<StickerPack>>() {}.type
        val gson = Gson()

        /**
         * Returns StickerPacks from sticker_packs.json
         */
        fun getStickerPacks(context: Context): MutableList<StickerPack> {
            if (!File(getStickerPackFilePath(context)).exists()) {
                return mutableListOf()
            }

            val file = FileReader(getStickerPackFilePath(context))
            val stickerPacks: MutableList<StickerPack> = gson.fromJson(file, stickerPackListType)
            return stickerPacks
        }

        /**
         * Returns îndex of StickerPack with given identifier
         */
        fun getStickerPackIndex(context: Context, identifier: String): Int {
            return getStickerPacks(context).indexOfFirst { it.identifier == identifier }
        }

        /**
         * Addes StickerPack to sticker_packs.json
         * Is StickerPack already exists: deletes old StickerPack
         */
        fun addStickerPack(context: Context, stickerPack: StickerPack) {
            val stickerPacks = getStickerPacks(context)

            val existingStickerPackIndex = getStickerPackIndex(context, stickerPack.identifier)
            if (existingStickerPackIndex != -1) {
                stickerPacks.removeAt(existingStickerPackIndex)
            }

            stickerPacks.add(stickerPack)

            saveStickerPacks(context, stickerPacks)
        }

        /**
         * Updates StickerPack in sticker_packs.json
         */
        fun updateStickerPack(context: Context, stickerPack: StickerPack) {
            var stickerPacks = getStickerPacks(context)

            val oldStickerPackIndex = getStickerPackIndex(context, stickerPack.identifier)
            if (oldStickerPackIndex != -1) {
                stickerPacks.removeAt(oldStickerPackIndex)
            }

            stickerPacks.add(stickerPack)

            saveStickerPacks(context, stickerPacks)
        }

        /**
         * Deletes StickerPack from sticker_packs.json
         */
        fun deleteStickerPack(context: Context, identifier: String) {
            var stickerPacks = getStickerPacks(context)

            val oldStickerPackIndex = getStickerPackIndex(context, identifier)
            if (oldStickerPackIndex != -1) {
                stickerPacks.removeAt(oldStickerPackIndex)
                saveStickerPacks(context, stickerPacks)
            }
        }

        /**
         * Returns path of sticker_packs.json
         */
        private fun getStickerPackFilePath(context: Context): String {
            return PathUtils.getDataDirectory(context) + "/sticker_packs.json"
        }

        /**
         * Saves all StickerPacks in sticker_packs.json
         */
        private fun saveStickerPacks(context: Context, stickerPacks: List<StickerPack>) {
            val json = gson.toJson(stickerPacks, stickerPackListType)

            val stickerPackFile = File(getStickerPackFilePath(context))
            val fileWriter = FileWriter(stickerPackFile)
            fileWriter.write(json)
            fileWriter.close()
        }
    }
}

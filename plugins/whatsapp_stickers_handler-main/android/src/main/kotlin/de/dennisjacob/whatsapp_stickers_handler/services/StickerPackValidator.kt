package de.dennisjacob.whatsapp_stickers_handler

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.text.TextUtils
import java.io.IOException


/**
 * Validates StickerPacks
 */
public class StickerPackValidator {
    companion object {
        /**
         * Checks if StickerPack is valid
         */
        public fun checkStickerPack(stickerPack: StickerPack) {
            checkString(stickerPack.identifier, "identifier")
            checkString(stickerPack.name, "name")
            checkString(stickerPack.publisher, "publisher")

            checkFileSize(stickerPack.trayImage, 50)
            checkTrayDimensions(stickerPack.trayImage)

            checkStickers(stickerPack.identifier, stickerPack.stickers)
        }

        /**
         * Checks if string length is valid and if it does not contain illegal characters
         */
        private fun checkString(string: String, name: String) {
            if (TextUtils.isEmpty(string)) {
                throw Exception(name + " is empty")
            }

            if (string.length > 128) {
                throw Exception(name + " has too many characters")
            }

            val pattern = "[\\w-.,'\\s]+"
            val valid = string.matches(pattern.toRegex()) && !string.contains("..")
            if (!valid) {
                throw Exception(name + " contains invalid characters")
            }
        }

        /**
         * Checks the dimensions of the tray image
         */
        private fun checkTrayDimensions(trayImage: String) {
            try {
                val bytes: ByteArray = FileService.getFileAsByteArray(trayImage)
                val bitmap: Bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

                if (bitmap.getHeight() > 512 || bitmap.getHeight() < 24) {
                    throw Exception("tray image height is invalid")
                } else if (bitmap.getWidth() > 512 || bitmap.getWidth() < 24) {
                    throw Exception("tray image width is invalid")
                }
            } catch (e: IOException) {
                throw Exception("cannot open file: " + trayImage)
            }
        }

        /**
         * Checks if the file does not exceed the given size in kb
         */
        private fun checkFileSize(file: String, kb: Int) {
            try {
                val bytes: ByteArray = FileService.getFileAsByteArray(file)
                if (bytes.size > kb * (8 * 1024).toLong()) {
                    throw Exception("file has to be smaller than " + kb + "kb: " + file)
                }
            } catch (e: IOException) {
                throw Exception("cannot open file: " + file)
            }
        }

        /**
         * Checks if the StickerPack provides 3-30 stickers
         * Checks if the size of the stickers is valid
         */
        private fun checkStickers(identifier: String, stickers: List<String>) {
            if (stickers.size < 3) {
                throw Exception(identifier + " needs at least 3 stickers")
            } else if (stickers.size > 30) {
                throw Exception(identifier + " has too many stickers")
            }

            for (sticker in stickers) {
                checkSticker(identifier, sticker)
            }
        }

        /**
         * Checks if sticker file size is not too big
         */
        private fun checkSticker(identifier: String, file: String) {
            if (TextUtils.isEmpty(file)) {
                throw Exception("sticker is empty in pack: " + identifier)
            }

            checkFileSize(file, 100)
        }
    }
}

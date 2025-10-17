package de.dennisjacob.whatsapp_stickers_handler

import android.content.res.AssetFileDescriptor
import android.os.ParcelFileDescriptor
import android.util.Log
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.IOException
import java.io.InputStream


/**
 * Handle files from file system
 */
class FileService {
    companion object {
        /**
         * Returns the file name formatted for the ContentProvider
         */
        fun getFileName(name: String): String {
            return name.removePrefix("/").replace("/", "._.")
        }

        /**
         * Returns the File with given name
         */
        fun getFile(fileName: String): AssetFileDescriptor? {
            return try {
                val file = File(fileName)
                AssetFileDescriptor(
                    ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY),
                    0,
                    AssetFileDescriptor.UNKNOWN_LENGTH
                )
            } catch (e: IOException) {
                Log.e("error", "IOException when getting asset file:$fileName", e)
                null
            }
        }

        /**
         * Gets file as byte array
         */
        fun getFileAsByteArray(name: String): ByteArray {
            val inputStream: InputStream = getFile(name)!!.createInputStream()
            val buffer = ByteArrayOutputStream()
            var read: Int
            val data = ByteArray(16384)
            while (inputStream.read(data, 0, data.size).also { read = it } != -1) {
                buffer.write(data, 0, read)
            }
            return buffer.toByteArray()
        }
    }
}

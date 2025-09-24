package com.example.wa_sticker_maker

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.OutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "wa_sticker_maker/saveSticker"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveWebPToDCIM") {
                    val filePath = call.argument<String>("filePath")
                    val fileName = call.argument<String>("fileName")
                    if (filePath != null && fileName != null) {
                        val success = saveWebPToDCIM(filePath, fileName)
                        if (success) result.success("Saved to DCIM/WA WhatsApp Stickers")
                        else result.error("UNAVAILABLE", "Failed to save", null)
                    } else {
                        result.error("INVALID_ARGS", "File path or name missing", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun saveWebPToDCIM(filePath: String, fileName: String): Boolean {
        return try {
            val inputFile = File(filePath)
            val resolver = contentResolver
            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/webp")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DCIM + "/WA WhatsApp Stickers")
                } else {
                    val dcimDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM)
                    val waDir = File(dcimDir, "WA WhatsApp Stickers")
                    if (!waDir.exists()) waDir.mkdirs()
                    put(MediaStore.MediaColumns.DATA, File(waDir, fileName).absolutePath)
                }
            }

            val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
                ?: return false

            resolver.openOutputStream(uri).use { outStream ->
                FileInputStream(inputFile).use { inputStream ->
                    inputStream.copyTo(outStream!!)
                }
            }

            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}

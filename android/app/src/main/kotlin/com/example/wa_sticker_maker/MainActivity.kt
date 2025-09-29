package com.example.wa_sticker_maker

import android.os.Build
import android.os.Environment
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "wa_sticker_maker/saveSticker"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveWebPToWhatsApp" -> {
                        val filePath = call.argument<String>("filePath")
                        val fileName = call.argument<String>("fileName")
                        if (filePath != null && fileName != null) {
                            val savedPath = saveWebPToWhatsApp(filePath, fileName)
                            if (savedPath != null) {
                                result.success(savedPath)
                            } else {
                                result.error("UNAVAILABLE", "Failed to save", null)
                            }
                        } else {
                            result.error("INVALID_ARGS", "File path or name missing", null)
                        }
                    }
                    "getAndroidVersion" -> {
                        result.success(Build.VERSION.SDK_INT)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun saveWebPToWhatsApp(filePath: String, fileName: String): String? {
        return try {
            val inputFile = File(filePath)
            val whatsappDir = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                File(Environment.getExternalStorageDirectory(), "Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Stickers")
            } else {
                File(Environment.getExternalStorageDirectory(), "WhatsApp/Media/WhatsApp Stickers")
            }
            if (!whatsappDir.exists()) whatsappDir.mkdirs()
            val outputFile = File(whatsappDir, fileName)
            FileInputStream(inputFile).use { input ->
                FileOutputStream(outputFile).use { output ->
                    input.copyTo(output)
                }
            }
            outputFile.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}

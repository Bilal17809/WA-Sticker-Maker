package de.dennisjacob.whatsapp_stickers_handler

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import android.content.ActivityNotFoundException
import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull


class WhatsappStickersHandler : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    companion object {
        /**
         * Returns contentProviderAuthority regarding package name
         */
        fun getContentProviderAuthority(context: Context): String {
            return context.packageName + ".stickercontentprovider"
        }
    }

    private var handler = WhatsappStickersHandlerService;

    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity
    private lateinit var result: Result

    /**
     * Handles MethodCalls and calls WhatsappStickersHandlerService functionality
     */
    override fun onMethodCall(call: MethodCall, result: Result) {
        this.result = result
        val context: Context = activity.applicationContext
        try {
            when (call.method) {
                "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
                "isWhatsAppInstalled" -> handler.isWhatsAppInstalled(result, context)
                "launchWhatsApp" -> handler.launchWhatsApp(result, activity)
                "isStickerPackAdded" -> handler.isStickerPackAdded(call, result, context)
                "addStickerPack" -> handler.addStickerPack(call, activity)
                "updateStickerPack" -> handler.updateStickerPack(call, activity)
                "deleteStickerPack" -> handler.deleteStickerPack(call, context)
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result?.error("error", e.message, null)
        }
    }

    /**
     * Handle validation error on addStickerPack intent result
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
        if (requestCode != 200) {
            return true
        }

        val validationError = intent?.getStringExtra("validation_error")
        if (resultCode == Activity.RESULT_CANCELED && validationError != null) {
            result?.error("validation error", validationError, null)
        }

        return true
    }

    /**
     * Initilaizes MethodChannel
     */
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "whatsapp_stickers_handler")
        channel.setMethodCallHandler(this)
    }

    /**
     * Sets MethodChannel to null
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Initalizes activity and starts listening to activity results
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {}


}

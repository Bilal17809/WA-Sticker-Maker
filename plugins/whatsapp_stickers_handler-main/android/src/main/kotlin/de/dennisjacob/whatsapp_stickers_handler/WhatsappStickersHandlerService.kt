package de.dennisjacob.whatsapp_stickers_handler

import android.app.Activity
import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Handles MethodCalls (from Dart code) and executes the requested functionality
 */
class WhatsappStickersHandlerService {
    companion object {
        /**
         * Returns if WhatsApp is installed
         */
        fun isWhatsAppInstalled(result: Result, context: Context) {
            val isWhatsAppInstalled = WhatsAppService.isWhatsAppInstalled(context.packageManager)
            result.success(isWhatsAppInstalled)
        }

        /**
         * Launches WhatsApp
         */
        fun launchWhatsApp(result: Result, activity: Activity) {
            WhatsAppService.launchWhatsApp(activity)
            result.success(true)
        }

        /**
         * Returns if StickerPack is added to WhatsApp
         */
        fun isStickerPackAdded(call: MethodCall, result: Result, context: Context) {
            val stickerPackIdentifier = call.argument<String>("identifier");
            if (stickerPackIdentifier == null) {
                result.error("400", "No identifier was passed", null)
                return
            }

            val isAdded = WhatsAppService.isStickerPackAdded(context, stickerPackIdentifier)
            result.success(isAdded)
        }

        /**
         * Adds StickerPack to sticker_pack.json and sends intent to add it to WhatsApp
         * Also validates StickerPack
         */
        fun addStickerPack(call: MethodCall, activity: Activity) {
            val stickerPack: StickerPack = StickerPack(call)
            StickerPackValidator.checkStickerPack(stickerPack);

            StickerPackStorageService.addStickerPack(activity.applicationContext, stickerPack)
            WhatsAppService.addStickerPack(activity, stickerPack)
        }

        /**
         * Increments imageDataVersion and updates StickerPack in sticker_pack.json
         * Also validates StickerPack
         */
        fun updateStickerPack(call: MethodCall, activity: Activity) {
            val stickerPack: StickerPack = StickerPack(call)
            StickerPackValidator.checkStickerPack(stickerPack);

            val oldStickerPack =
                StickerPackStorageService.getStickerPacks(activity.applicationContext)
                    .firstOrNull { it.identifier == stickerPack.identifier }

            if (oldStickerPack == null) {
                addStickerPack(call, activity)
                return
            }

            stickerPack.imageDataVersion = (oldStickerPack.imageDataVersion.toInt() + 1).toString()
            StickerPackStorageService.updateStickerPack(activity.applicationContext, stickerPack)
        }

        /**
         * Deletes StickerPack from sticker_pack.json
         */
        fun deleteStickerPack(call: MethodCall, context: Context) {
            val identifier: String = call.argument("identifier")!!
            StickerPackStorageService.deleteStickerPack(context, identifier)
        }
    }
}
package de.dennisjacob.whatsapp_stickers_handler

import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri


/**
 * Interacts with WhatsApp to add StickerPacks and retrieve information
 */
public class WhatsAppService {
    companion object {
        const val authority = "com.whatsapp"

        /**
         * Checks if WhatsApp is installed
         */
        fun isWhatsAppInstalled(packageManager: PackageManager): Boolean {
            val appInfo: ApplicationInfo = packageManager.getApplicationInfo(authority, 0)
            return appInfo.enabled
        }

        /**
         * Creates and sends intent to open WhatsApp
         */
        fun launchWhatsApp(activity: Activity) {
            val packageManager = activity.applicationContext.packageManager
            val launchIntent = packageManager.getLaunchIntentForPackage(authority)
            activity.startActivity(launchIntent)
        }

        /**
         * Queries WhatsApp and checks if the given StickerPack is available in WhatsApp
         */
        fun isStickerPackAdded(context: Context, identifier: String): Boolean {
            val contentProviderAuthority: String =
                WhatsappStickersHandler.getContentProviderAuthority(context);

            val queryUri: Uri = Uri.Builder().scheme(ContentResolver.SCHEME_CONTENT)
                .authority(authority + ".provider.sticker_whitelist_check")
                .appendPath("is_whitelisted")
                .appendQueryParameter("authority", contentProviderAuthority)
                .appendQueryParameter("identifier", identifier).build()

            context.getContentResolver().query(queryUri, null, null, null, null).use { cursor ->
                if (cursor != null && cursor.moveToFirst()) {
                    val whiteListResult: Int = cursor.getInt(cursor.getColumnIndexOrThrow("result"))
                    return whiteListResult == 1
                }
                return false
            }
        }

        /**
         * Creates and sends intent for adding a StickerPack
         */
        fun addStickerPack(activity: Activity, stickerPack: StickerPack) {
            val contentProviderAuthority: String =
                WhatsappStickersHandler.getContentProviderAuthority(activity.applicationContext);

            val intent = Intent()
            intent.action = authority + ".intent.action.ENABLE_STICKER_PACK"
            intent.putExtra("sticker_pack_id", stickerPack.identifier)
            intent.putExtra("sticker_pack_name", stickerPack.name)
            intent.putExtra("sticker_pack_authority", contentProviderAuthority)

            val chooser = Intent.createChooser(intent, "ADD Sticker")
            activity.startActivityForResult(chooser, 200)
        }
    }
}

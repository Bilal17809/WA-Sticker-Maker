package de.dennisjacob.whatsapp_stickers_handler

import android.database.MatrixCursor
import io.flutter.plugin.common.MethodCall


/**
 * For more information see
 * https://github.com/WhatsApp/stickers/tree/main/Android#modifying-the-contentsjson-file
 */
public class StickerPack(
    val identifier: String,
    val name: String,
    val publisher: String,

    val trayImage: String,
    val stickers: List<String>,
    var imageDataVersion: String,
    val animatedStickerPack: Boolean,

    val publisherEmail: String?,
    val publisherWebsite: String?,
    val privacyPolicyWebsite: String?,
    val licenseAgreementWebsite: String?,
    val iosAppStoreLink: String?,
    val androidPlayStoreLink: String?,
) {

    /**
     * Secondary constructor for method call from Dart code
     */
    constructor(call: MethodCall) : this(
        call.argument("identifier")!!,
        call.argument("name")!!,
        call.argument("publisher")!!,

        call.argument("trayImage")!!,
        call.argument("stickers")!!,
        "1",
        call.argument<Boolean>("animatedStickerPack") == true,

        call.argument("publisherEmail"),
        call.argument("publisherWebsite"),
        call.argument("privacyPolicyWebsite"),
        call.argument("licenseAgreementWebsite"),
        call.argument("iosAppStoreLink"),
        call.argument("androidPlayStoreLink")
    )

    companion object {
        /**
         * The column names for the ContentProvider
         */
        val whatsappColumns: Array<String> = arrayOf(
            "sticker_pack_identifier",
            "sticker_pack_name",
            "sticker_pack_publisher",

            "sticker_pack_icon",
            "image_data_version",
            "animated_sticker_pack",

            "sticker_pack_publisher_email",
            "sticker_pack_publisher_website",
            "sticker_pack_privacy_policy_website",
            "sticker_pack_license_agreement_website",
            "ios_app_download_link",
            "android_play_store_link",
        )
    }

    /**
     * Returns the properties of the StickerPack in an Array for the ContentProvider
     */
    fun rowForWhatsApp(): Array<Any?> {
        return arrayOf<Any?>(
            identifier,
            name,
            publisher,

            FileService.getFileName(trayImage),
            imageDataVersion,
            if (animatedStickerPack) 1 else 0,

            publisherEmail,
            publisherWebsite,
            privacyPolicyWebsite,
            licenseAgreementWebsite,
            iosAppStoreLink,
            androidPlayStoreLink,
        )
    }

    /**
     * Returns a cursor for the stickers of the StickerPack
     */
    fun stickerCursor(): MatrixCursor {
        val cursor = MatrixCursor(
            arrayOf<String>(
                "sticker_file_name",
                "sticker_emoji",
                "sticker_accessibility_text"
            )
        )
        stickers.forEach { cursor.addRow(arrayOf<String>(FileService.getFileName(it), "", "")) }
        return cursor
    }
}

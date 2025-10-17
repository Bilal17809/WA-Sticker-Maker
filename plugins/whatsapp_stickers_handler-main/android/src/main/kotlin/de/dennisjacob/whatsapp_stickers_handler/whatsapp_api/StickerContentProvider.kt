package de.dennisjacob.whatsapp_stickers_handler;

import android.content.ContentProvider
import android.content.ContentValues
import android.content.UriMatcher
import android.content.res.AssetFileDescriptor
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.util.Log
import de.dennisjacob.whatsapp_stickers_handler.FileService
import de.dennisjacob.whatsapp_stickers_handler.StickerPack
import de.dennisjacob.whatsapp_stickers_handler.StickerPackStorageService
import de.dennisjacob.whatsapp_stickers_handler.WhatsappStickersHandler
import java.io.File


/**
 * Provider StickerPacks from sticker_packs.json to WhatsApp
 */
class StickerContentProvider : ContentProvider() {
    companion object {
        private val matcher: UriMatcher = UriMatcher(UriMatcher.NO_MATCH)
    }

    /**
     * Creates endpoints
     */
    override fun onCreate(): Boolean {
        val authority: String = WhatsappStickersHandler.getContentProviderAuthority(context!!);

        matcher.addURI(authority, "metadata", 1)  // Get metadata for all packs
        matcher.addURI(authority, "metadata/*", 2) // Get metadata for single pack
        matcher.addURI(authority, "stickers" + "/*", 3) // Get stickers of pack
        // Gets sticker asset from a sticker pack
        matcher.addURI(authority, "stickers_asset" + "/*/*", 4)

        return true
    }

    /**
     * Handles endpoints
     */
    override fun query(
        uri: Uri,
        projection: Array<String>?,
        selection: String?,
        selectionArgs: Array<String>?,
        sortOrder: String?
    ): Cursor? {
        return when (matcher.match(uri)) {
            1 -> getMetadataForAllPacks(uri)
            2 -> getMetadataForOnePack(uri)
            3 -> getStickersOfPack(uri)
            else -> throw IllegalArgumentException("Unknown URI: $uri")
        }
    }

    /**
     * Returns the sticker file at the URI
     */
    override fun openAssetFile(uri: Uri, mode: String): AssetFileDescriptor? {
        val matchCode: Int = matcher.match(uri)
        if (matchCode == 4 || matchCode == 5) {
            return getStickerFile(uri)
        }
        return null
    }

    /**
     * Returns the response type of the endpoint
     */
    override fun getType(uri: Uri): String? {
        val authority: String = WhatsappStickersHandler.getContentProviderAuthority(context!!);

        return when (matcher.match(uri)) {
            1 -> "vnd.android.cursor.dir/vnd." + authority + ".metadata"
            2 -> "vnd.android.cursor.item/vnd." + authority + ".metadata"
            3 -> "vnd.android.cursor.dir/vnd." + authority + ".stickers"
            4 -> "image/webp"
            5 -> "image/png"
            else -> throw IllegalArgumentException("Unknown URI: $uri")
        }
    }

    /**
     * Returns cursor for all StickerPacks
     * Sets available colums and adds a row with the properties for each StickerPack
     */
    private fun getMetadataForAllPacks(uri: Uri): Cursor {
        return getStickerPackInfo(uri, getStickerPacks())
    }


    /**
     * Returns cursor for one StickerPack
     * Sets available colums and adds one row with the properties of the StickerPack
     */
    private fun getMetadataForOnePack(uri: Uri): Cursor {
        val identifier: String = uri.getLastPathSegment()!!
        val stickerPack = getStickerPacks().filter { it.identifier == identifier }
        return getStickerPackInfo(uri, stickerPack)
    }

    /**
     * Returns cursor for the given StickerPacks
     * Sets available colums and adds a row with the properties for each given StickerPack
     */
    private fun getStickerPackInfo(uri: Uri, stickerPackList: List<StickerPack>): Cursor {
        val cursor = MatrixCursor(StickerPack.whatsappColumns)
        stickerPackList.forEach { cursor.addRow(it.rowForWhatsApp()) }
        cursor.setNotificationUri(getContext()!!.getContentResolver(), uri)
        return cursor
    }

    /**
     * Returns cursor for the stickers of the StickerPack at the URI
     */
    private fun getStickersOfPack(uri: Uri): Cursor {
        val identifier: String = uri.getLastPathSegment()!!
        val stickerPack = getStickerPacks().firstOrNull { it.identifier == identifier }
            ?: throw Exception("No sticker pack found")

        val cursor: MatrixCursor = stickerPack.stickerCursor()
        cursor.setNotificationUri(getContext()!!.getContentResolver(), uri)
        return cursor
    }

    /**
     * Returns the sticker file at the URI
     */
    private fun getStickerFile(uri: Uri): AssetFileDescriptor? {
        val pathSegments: List<String> = uri.getPathSegments()
        val fileName = pathSegments[pathSegments.size - 1]

        return FileService.getFile(fileName.replace("._.", File.separator))
    }

    /**
     * Returns StickerPacks that are saved in the StickerPackStorageService
     */
    private fun getStickerPacks(): List<StickerPack> {
        return StickerPackStorageService.getStickerPacks(getContext()!!)
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        throw UnsupportedOperationException("Not supported")
    }

    override fun update(
        uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<String>?
    ): Int {
        throw UnsupportedOperationException("Not supported")
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int {
        throw UnsupportedOperationException("Not supported")
    }
}

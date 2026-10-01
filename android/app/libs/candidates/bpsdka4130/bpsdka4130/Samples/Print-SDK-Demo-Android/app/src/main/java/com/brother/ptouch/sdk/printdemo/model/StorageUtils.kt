package com.brother.ptouch.sdk.printdemo.model

import android.content.Context
import android.net.Uri
import android.provider.OpenableColumns
import java.io.File
import java.io.FileOutputStream

object StorageUtils {
    fun getInternalFolder(context: Context): String {
        return context.filesDir.absolutePath
    }

    fun getExternalFolder(context: Context): String {
        return context.getExternalFilesDir(null)?.absolutePath ?: ""
    }

    fun getSelectFileUri(context: Context, uri: Uri): String? {
        return kotlin.runCatching {
            val file = File(selectFileTemDir(context, uri))
            if (file.exists()) {
                file.delete()
            }
            file.parentFile?.mkdirs()
            context.contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(file).use { output ->
                    input.copyTo(output)
                }
            }
            file.path
        }.getOrNull()
    }

    fun deleteSelectFolder(context: Context) {
        File(context.externalCacheDir?.path + File.separator + "select").delete()
    }

    private fun selectFileTemDir(context: Context, src: Uri): String {
        return context.externalCacheDir?.path + File.separator + "select" + File.separator + src.originalFileName(context)
    }

    private fun Uri.originalFileName(context: Context): String = when (scheme) {
        "content" -> {
            context.contentResolver.query(this, null, null, null, null, null)?.use {
                if (!it.moveToFirst()) return@use ""
                val index = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                return@use if (index < 0) "" else it.getString(index)
            } ?: ""
        }
        else -> {
            this.lastPathSegment ?: ""
        }
    }

    fun Uri.hasFileWithExtension(extension: String, context: Context): Boolean {
        return originalFileName(context).endsWith(".$extension", true)
    }
}

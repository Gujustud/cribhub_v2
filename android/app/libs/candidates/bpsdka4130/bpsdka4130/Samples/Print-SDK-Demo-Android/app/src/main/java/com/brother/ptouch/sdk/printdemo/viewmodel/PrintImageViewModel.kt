package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.ImagePrintData
import com.brother.ptouch.sdk.printdemo.model.ImagePrnType
import com.brother.ptouch.sdk.printdemo.model.StorageUtils.hasFileWithExtension
import com.brother.ptouch.sdk.printdemo.model.print.PrintImageTask

class PrintImageViewModel : ViewModel() {
    companion object {
        private const val PrnExtension = "prn"
        private const val BinExtension = "bin"
    }

    private val printTask = PrintImageTask()
    var printData = ImagePrintData(ImagePrnType.ImageFile, arrayListOf())
    fun getPrintImageMenuList(context: Context): List<String> {
        return mutableListOf(
            context.getString(R.string.print_image_with_image),
            context.getString(R.string.print_image_with_URL),
            context.getString(R.string.print_image_with_URLs),
            context.getString(R.string.print_image_with_Closures)
        )
    }

    fun starPrintPrnWithNoSettings(context: Context, callback: (String) -> Unit) {
        val currentPrint = PrintDemoApp.instance.currentSelectedPrinter
        if (currentPrint != null) {
            printTask.startPrint(context, printData, currentPrint, null, callback)
        } else
            callback.invoke(context.getString(R.string.select_printer_message))
    }

    fun cancelPrint() {
        printTask.cancelPrint()
    }

    @Suppress("UNUSED_PARAMETER")
    fun isSupportFile(context: Context, uri: Uri): Boolean {
        return true
    }
}

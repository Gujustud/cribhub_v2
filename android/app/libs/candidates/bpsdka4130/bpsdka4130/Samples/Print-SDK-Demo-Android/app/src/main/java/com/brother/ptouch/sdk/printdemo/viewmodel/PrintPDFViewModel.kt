package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.PdfPrintData

class PrintPDFViewModel : ViewModel() {
    var currentPDFData: PdfPrintData? = null

    fun getPrintPDFMenuList(context: Context): List<String> {
        return mutableListOf(
            context.getString(R.string.print_PDF_with_URL),
            context.getString(R.string.print_PDF_with_URLs),
            context.getString(R.string.print_PDF_with_URL_pages)
        )
    }
}

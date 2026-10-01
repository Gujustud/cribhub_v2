package com.brother.ptouch.sdk.printdemo.model.printersearch

import android.content.Context
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo

interface IPrinterSearcher {
    fun start(
        context: Context,
        targetModels: Array<String>,
        callback: (PrinterSearchError?, com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode?, ArrayList<DiscoveredPrinterInfo>) -> Unit
    )

    fun cancel()
}

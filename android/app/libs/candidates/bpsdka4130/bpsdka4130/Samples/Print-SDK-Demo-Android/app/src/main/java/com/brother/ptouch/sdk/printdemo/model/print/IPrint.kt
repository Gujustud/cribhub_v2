package com.brother.ptouch.sdk.printdemo.model.print

import android.content.Context
import com.brother.ptouch.sdk.printdemo.model.IPrintData
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.sdk.lmprinter.setting.PrintSettings

interface IPrint {
    fun startPrint(
            context: Context,
            printData: IPrintData,
            printerInfo: DiscoveredPrinterInfo,
            printerSettings: PrintSettings?,
            callback: (String) -> Unit
    )

    fun cancelPrint()
}

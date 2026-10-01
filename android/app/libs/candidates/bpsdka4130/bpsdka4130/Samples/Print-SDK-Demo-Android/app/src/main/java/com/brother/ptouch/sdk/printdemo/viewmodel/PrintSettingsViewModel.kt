package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.model.IPrintData
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.ImagePrintData
import com.brother.ptouch.sdk.printdemo.model.PdfPrintData
import com.brother.ptouch.sdk.printdemo.model.StorageUtils.hasFileWithExtension
import com.brother.ptouch.sdk.printdemo.model.print.IPrint
import com.brother.ptouch.sdk.printdemo.model.print.PrintImageTask
import com.brother.ptouch.sdk.printdemo.model.print.PrintPDFTask
import com.brother.ptouch.sdk.printdemo.model.printsettings.*
import com.brother.sdk.lmprinter.PrinterModel

class PrintSettingsViewModel : ViewModel() {
    companion object {
        private const val BinaryExtension = "bin"
    }

    var printSettings: ISimplePrintSettings? = null
    var printerInfo: DiscoveredPrinterInfo? = null
    var data: IPrintData? = null
    var printTask: IPrint? = null
    var printerModelName: String? = null
    fun getOptionsInfoList(context: Context): MutableMap<PrintSettingsItemType, Any> {
        val modelName = getPrinterModel(printerModelName) ?: printerInfo?.getPrinterModel()
        if (printSettings != null && modelName == printSettings?.printerModel) {
            return printSettings?.settingsMap ?: mutableMapOf()
        }
        modelName?.let {
            if (it.name.startsWith("PJ")) {
                printSettings = PJModelPrintSettings(context, it)
            } else if (it.name.startsWith("MW")) {
                printSettings = MWModelPrintSettings(context, it)
            } else if (it.name.startsWith("RJ")) {
                printSettings = RJModelPrintSettings(context, it)
            } else if (it.name.startsWith("QL")) {
                printSettings = QLModelPrintSettings(context, it)
            } else if (it.name.startsWith("TD")) {
                printSettings = TDModelPrintSettings(context, it)
            } else if (it.name.startsWith("PT")) {
                printSettings = PTModelPrintSettings(context, it)
            }
        }
        return printSettings?.settingsMap ?: mutableMapOf()
    }

    fun setSettingsMap(key: PrintSettingsItemType, value: Any) {
        printSettings?.settingsMap?.set(key, value)
    }

    fun getSettingItemList(key: PrintSettingsItemType): Array<String> {
        return printSettings?.getSettingItemList(key) ?: arrayOf()
    }

    private fun saveSettingsInfo() {
        printSettings?.apply {
            settingsMap.forEach {
                setSettingInfo(it.key, it.value)
            }
        }
    }

    fun startToPrint(context: Context, callback: (String) -> Unit) {
        saveSettingsInfo()
        data?.let {
            when (it) {
                is ImagePrintData -> startToPrintImage(context, it, callback)
                is PdfPrintData -> startToPrintPDF(context, it, callback)
                else -> null
            }
        }
    }

    private fun startToPrintImage(context: Context, imageData: ImagePrintData, callback: (String) -> Unit) {
        val currentPrint = PrintDemoApp.instance.currentSelectedPrinter ?: return
        val printSettings = printSettings?.getPrintSettings()
        printSettings?.let {
            printTask = PrintImageTask()
            printTask?.startPrint(context, imageData, currentPrint, it, callback)
        }
    }

    private fun startToPrintPDF(context: Context, printData: PdfPrintData, callback: (String) -> Unit) {
        val currentPrint = PrintDemoApp.instance.currentSelectedPrinter ?: return
        val printSettings = printSettings?.getPrintSettings()
        printSettings?.let {
            printTask = PrintPDFTask()
            printTask?.startPrint(context, printData, currentPrint, it, callback)
        }
    }

    fun cancelPrint() {
        printTask?.cancelPrint()
    }

    fun validateSettingsInfo(callback: (String) -> Unit) {
        saveSettingsInfo()
        printSettings?.validateSettings {
            callback(it.description())
        }
    }

    private fun getPrinterModel(name: String?): PrinterModel? {
        return PrinterModel.values().firstOrNull { it.name == name }
    }

    fun isSupportFile(context: Context, uri: Uri): Boolean {
        return uri.hasFileWithExtension(BinaryExtension, context)
    }
}

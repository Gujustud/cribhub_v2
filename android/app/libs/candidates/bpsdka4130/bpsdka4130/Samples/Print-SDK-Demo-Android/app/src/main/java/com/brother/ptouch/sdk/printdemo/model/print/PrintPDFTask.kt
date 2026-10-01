package com.brother.ptouch.sdk.printdemo.model.print

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.*
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrintError
import com.brother.sdk.lmprinter.PrintError.ErrorCode
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import com.brother.sdk.lmprinter.setting.PrintSettings
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class PrintPDFTask : IPrint, CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()
    private var cancelRoutine: (() -> Unit)? = null

    override fun startPrint(
            context: Context,
            printData: IPrintData,
            printerInfo: DiscoveredPrinterInfo,
            printerSettings: PrintSettings?,
            callback: (String) -> Unit
    ) {
        // run in thread
        launch {
            if (printData !is PdfPrintData) {
                withContext(Dispatchers.Main) {
                    callback(context.getString(R.string.wrong_print_data_type))
                }
                return@launch
            }

            val result = when (printData.type) {
                PDFPrintType.File -> printFile(context, printData, printerInfo, printerSettings)
                PDFPrintType.Files -> printFiles(context, printData, printerInfo, printerSettings)
                PDFPrintType.Pages -> printPages(context, printData, printerInfo, printerSettings)
            }

            withContext(Dispatchers.Main) {
                callback(result)
            }
        }
    }

    override fun cancelPrint() {
        launch {
            cancelRoutine?.invoke()
            cancelRoutine = null
        }
    }

    private fun printFile(context: Context, printData: PdfPrintData, printerInfo: DiscoveredPrinterInfo, printSettings: PrintSettings?): String {
        val channel = PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString(R.string.create_channel_error)
        val path = printData.pdfData.firstOrNull() ?: return context.getString(R.string.no_print_data)
        val settings = printSettings ?: return context.getString(R.string.no_print_settings)
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val driverResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (driverResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return driverResult.error.code.toString()
        }
        val driver = driverResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }

        val error = driver.printPDF(path, settings)
        driver.closeChannel()
        cancelRoutine = null

        return error.code.toString() + "\r\n" + error.allLogs.joinToString("\r\n")
    }

    private fun printFiles(context: Context, printData: PdfPrintData, printerInfo: DiscoveredPrinterInfo, printSettings: PrintSettings?): String {
        val channel = PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString(R.string.create_channel_error)
        val settings = printSettings ?: return context.getString(R.string.no_print_settings)
        val list = printData.pdfData.toTypedArray()
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val driverResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (driverResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return driverResult.error.code.toString()
        }
        val driver = driverResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }

        val error = driver.printPDF(list, settings)
        driver.closeChannel()
        cancelRoutine = null

        return error.code.toString() + "\r\n" + error.allLogs.joinToString("\r\n")
    }

    private fun printPages(context: Context, printData: PdfPrintData, printerInfo: DiscoveredPrinterInfo, printSettings: PrintSettings?): String {
        val channel = PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString(R.string.create_channel_error)
        val path = printData.pdfData.firstOrNull() ?: return context.getString(R.string.no_print_data)
        val settings = printSettings ?: return context.getString(R.string.no_print_settings)
        val pages = printData.pages.toIntArray()
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val driverResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (driverResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return driverResult.error.code.toString()
        }
        val driver = driverResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }

        val error = kotlin.runCatching {
            driver.printPDF(path, pages, settings)
        }.getOrElse {
            ErrorCode.PDFPageError
        }
        driver.closeChannel()
        cancelRoutine = null

        return when (error) {
            is PrintError -> error.code.toString() + "\r\n" + error.allLogs.joinToString("\r\n")
            is ErrorCode -> error.toString()
            else -> ""
        }
    }
}

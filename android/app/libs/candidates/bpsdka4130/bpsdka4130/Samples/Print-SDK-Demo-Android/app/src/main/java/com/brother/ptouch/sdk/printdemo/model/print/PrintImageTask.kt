package com.brother.ptouch.sdk.printdemo.model.print

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.*
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import com.brother.sdk.lmprinter.setting.PrintSettings
import kotlinx.coroutines.*
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import kotlin.coroutines.CoroutineContext

class PrintImageTask : IPrint, CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()
    private var cancelRoutine: (() -> Unit)? = null

    private fun printImageWithImage(
            context: Context,
            printerInfo: DiscoveredPrinterInfo,
            imageData: ImagePrintData,
            printerSettings: PrintSettings?
    ): String {
        val channel =
            PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString((R.string.create_channel_error))
        val path = imageData.imagePrnData.firstOrNull() ?: return context.getString((R.string.no_print_data))
        val bitmapData = BitmapFactory.decodeFile(path) ?: return context.getString((R.string.no_print_data))
        val sdkPrinterSettings = printerSettings ?: return context.getString(R.string.no_print_settings)
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return generateResult.error.toString()
        }
        val driver = generateResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }
        val printError = driver.printImage(bitmapData, sdkPrinterSettings)
        driver.closeChannel()
        cancelRoutine = null
        return printError.code.toString() + "\r\n" + printError.allLogs.joinToString("\r\n")
    }

    private fun printImageWithURL(
            context: Context,
            printerInfo: DiscoveredPrinterInfo,
            imageData: ImagePrintData,
            printerSettings: PrintSettings?
    ): String {
        val channel =
            PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString((R.string.create_channel_error))
        val path = imageData.imagePrnData.firstOrNull() ?: return context.getString((R.string.no_print_data))
        val sdkPrinterSettings = printerSettings ?: return context.getString(R.string.no_print_settings)
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return generateResult.error.toString()
        }
        val driver = generateResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }
        val printError = driver.printImage(path, sdkPrinterSettings)
        driver.closeChannel()
        cancelRoutine = null
        return printError.code.toString() + "\r\n" + printError.allLogs.joinToString("\r\n")
    }

    private fun printImageWithURLs(
            context: Context,
            printerInfo: DiscoveredPrinterInfo,
            imageData: ImagePrintData,
            printerSettings: PrintSettings?
    ): String {
        val channel =
            PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString((R.string.create_channel_error))
        val paths = imageData.imagePrnData.toTypedArray()
        val sdkPrinterSettings = printerSettings ?: return context.getString(R.string.no_print_settings)
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return generateResult.error.toString()
        }
        val driver = generateResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }
        val printError = driver.printImage(paths, sdkPrinterSettings)
        driver.closeChannel()
        cancelRoutine = null
        return printError.code.toString() + "\r\n" + printError.allLogs.joinToString("\r\n")
    }


    private fun printImageWithClosures(
            context: Context,
            printerInfo: DiscoveredPrinterInfo,
            imageData: ImagePrintData,
            printerSettings: PrintSettings?
    ): String {
        val channel =
            PrinterConnectUtil.getCurrentChannel(context, printerInfo) ?: return context.getString((R.string.create_channel_error))
        val paths = imageData.imagePrnData.toTypedArray()
        val sdkPrinterSettings = printerSettings ?: return context.getString(R.string.no_print_settings)
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
        val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
            return generateResult.error.toString()
        }
        val driver = generateResult.driver
        cancelRoutine = {
            driver.cancelPrinting()
        }

        var closures = ArrayList<Function0<Bitmap>>()
        for (path in paths) {
            closures.add(object : Function0<Bitmap> {
                override fun invoke(): Bitmap {
                    val bitmap = BitmapFactory.decodeFile(path)
                    return bitmap
                }
            })
        }

        val printError = driver.printImageWithClosures(closures, sdkPrinterSettings)
        driver.closeChannel()
        cancelRoutine = null
        return printError.code.toString() + "\r\n" + printError.allLogs.joinToString("\r\n")
    }

    private fun readBinaryDataFromFile(filePath: String): ByteArray? {
        return try {
            val fis = FileInputStream(filePath)
            val data = ByteArray(fis.available())
            fis.read(data)
            fis.close()
            data
        } catch (var4: FileNotFoundException) {
            null
        } catch (var5: IOException) {
            null
        }
    }

    override fun startPrint(
            context: Context,
            printData: IPrintData,
            printerInfo: DiscoveredPrinterInfo,
            printerSettings: PrintSettings?,
            callback: (String) -> Unit
    ) {
        launch {
            if (printData !is ImagePrintData) {
                withContext(Dispatchers.Main) {
                    callback(context.getString(R.string.wrong_print_data_type))
                }
                return@launch
            }
            val result = when (printData.dataType) {
                ImagePrnType.ImageFile -> printImageWithURL(context, printerInfo, printData, printerSettings)
                ImagePrnType.ImageFiles -> printImageWithURLs(context, printerInfo, printData, printerSettings)
                ImagePrnType.BitmapData -> printImageWithImage(context, printerInfo, printData, printerSettings)
                ImagePrnType.Closures -> printImageWithClosures(context, printerInfo, printData, printerSettings)
            }
            withContext(Dispatchers.Main) {
                callback.invoke(result)
            }
        }
    }

    override fun cancelPrint() {
        launch {
            cancelRoutine?.invoke()
            cancelRoutine = null
        }
    }
}

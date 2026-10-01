package com.brother.ptouch.sdk.printdemo.model.print

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.PrinterConnectUtil
import com.brother.ptouch.sdk.printdemo.model.TemplatePrintData
import com.brother.ptouch.sdk.printdemo.model.guessPrinterModels
import com.brother.ptouch.sdk.printdemo.ui.EditTemplateFragment
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import com.brother.sdk.lmprinter.setting.ITemplatePrintSettings
import com.brother.sdk.lmprinter.setting.MWTemplatePrintSettings
import com.brother.sdk.lmprinter.setting.PJTemplatePrintSettings
import com.brother.sdk.lmprinter.setting.PTTemplatePrintSettings
import com.brother.sdk.lmprinter.setting.QLTemplatePrintSettings
import com.brother.sdk.lmprinter.setting.RJTemplatePrintSettings
import com.brother.sdk.lmprinter.setting.TDTemplatePrintSettings
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class PrintTemplateTask : CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()
    private var cancelRoutine: (() -> Unit)? = null

    fun startPrint(
            context: Context,
            printerInfo: DiscoveredPrinterInfo,
            printData: TemplatePrintData,
            callback: (String) -> Unit
    ) {
        launch {
            var cancelflag = false
            cancelRoutine = {cancelflag = true}
            val key = printData.key
            if (key == null) {
                withContext(Dispatchers.Main) {
                    callback(context.getString(R.string.no_print_data))
                }
                return@launch
            }
            val channel = PrinterConnectUtil.getCurrentChannel(context, printerInfo)

            val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
            val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
            if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                withContext(Dispatchers.Main) {
                    callback(generateResult.error.toString())
                }
                return@launch
            }
            val driver = generateResult.driver
            if (cancelflag) {
                driver.closeChannel()
                withContext(Dispatchers.Main) {
                    callback(context.getString(R.string.canceled_before_print))
                }
                return@launch
            }
            cancelRoutine = {driver.cancelPrinting()}
            val result = driver.printTemplate(printData.key, tranformTemplateSettingsForTemplatePrintData(printData), printData.replacer)
            withContext(Dispatchers.Main) {
                callback(result.toString())
            }
            driver.closeChannel()
        }
    }

    private fun tranformTemplateSettingsForTemplatePrintData(printData: TemplatePrintData): ITemplatePrintSettings? {
        val printerModels = guessPrinterModels(printData.modelName!!)
        val printerModel = printerModels.firstOrNull()

        printerModel?.let {
            if (it.name.startsWith("PJ")) {
                val printSettings = PJTemplatePrintSettings(it)
                printSettings.numCopies = printData.copies
                return printSettings
            } else if (it.name.startsWith("MW")) {
                val printSettings = MWTemplatePrintSettings(it)
                printSettings.numCopies = printData.copies
                return printSettings
            } else if (it.name.startsWith("RJ")) {
                val printSettings = RJTemplatePrintSettings(it)
                printSettings.numCopies = printData.copies
                printSettings.peelLabel = printData.peel
                return printSettings
            } else if (it.name.startsWith("QL")) {
                val printSettings = QLTemplatePrintSettings(it)
                printSettings.numCopies = printData.copies
                return printSettings
            } else if (it.name.startsWith("TD")) {
                val printSettings = TDTemplatePrintSettings(it)
                printSettings.numCopies = printData.copies
                printSettings.peelLabel = printData.peel
                return printSettings
            } else if (it.name.startsWith("PT")) {
                val printSettings = PTTemplatePrintSettings(it)
                printSettings.numCopies = printData.copies
                return printSettings
            }
        }
        return null;
    }

    /**
     * cancel communication
     */
    fun cancelPrint() {
        launch {
            cancelRoutine?.invoke()
            cancelRoutine = null
        }
    }
}

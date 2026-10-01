package com.brother.ptouch.sdk.printdemo.model.printertemplate

import android.content.Context
import com.brother.ptouch.sdk.PrinterStatus
import com.brother.ptouch.sdk.PtouchTemplateInfo
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.PrinterConnectUtil
import com.brother.sdk.lmprinter.Log
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import com.brother.sdk.lmprinter.RequestPrinterInfoErrorCode
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class ManagePrinterTemplateTask : CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()

    fun getTemplateList(context: Context, printerInfo: DiscoveredPrinterInfo, callback: (RequestPrinterInfoErrorCode, ArrayList<PtouchTemplateInfo>?, List<Log>?) -> Unit) {
        launch {
            val channel =
                    PrinterConnectUtil.getCurrentChannel(context, printerInfo)
            val unwrapChannel = if(channel != null) { channel }
            else{
                callback(RequestPrinterInfoErrorCode.UnknownError, null, null)
                return@launch
            }
            val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( printerInfo)
            val generateResult = PrinterConnectUtil.generatePrinterDriver(unwrapChannel, channelCredential)
            if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                callback(RequestPrinterInfoErrorCode.ConnectionFailed, null, null)
                return@launch
            }
            val driver = generateResult.driver
            val result = driver.requestTemplateInfoList()
            withContext(Dispatchers.Main) {
                callback(result.error.code, result.printerInfo, result.error.allLogs)
            }
            driver.closeChannel()
        }
    }
}

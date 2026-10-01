package com.brother.ptouch.sdk.printdemo.model.printersearch

import android.content.Context
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.sdk.lmprinter.Channel
import com.brother.sdk.lmprinter.PrinterSearcher
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class USBPrinterSearcher : IPrinterSearcher, CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()

    override fun start(
        context: Context,
        targetModels: Array<String>,
        callback: (PrinterSearchError?, com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode?, ArrayList<DiscoveredPrinterInfo>) -> Unit
    ) {
        launch {
            val result = PrinterSearcher.startUSBSearch(context)

            when (result.error.code) {
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.NoError -> {
                    if (result.channels.isEmpty()) {
                        withContext(Dispatchers.Main) {
                            callback(PrinterSearchError.None, result.error.code, arrayListOf())
                        }
                        return@launch
                    }
                }
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.NotPermitted -> {
                    withContext(Dispatchers.Main) {
                        callback(PrinterSearchError.USBPermissionNotGrant, result.error.code, arrayListOf())
                    }
                    return@launch
                }
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.Canceled,
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.InterfaceInactive,
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.InterfaceUnsupported,
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.AlreadySearching,
                com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.UnknownError -> {
                }
                null -> {}
            }

            // require permission: com.android.example.USB_PERMISSION
            val usbDeviceList = result.channels.map {
                DiscoveredPrinterInfo(
                        Channel.ChannelType.USB,
                        it.extraInfo[Channel.ExtraInfoKey.ModelName] ?: "",
                        it.channelInfo,
                        it.extraInfo)
            }
            withContext(Dispatchers.Main) {
                callback(PrinterSearchError.None, result.error.code, ArrayList(usbDeviceList))
            }
        }
    }

    override fun cancel() {
        // ignore
    }
}

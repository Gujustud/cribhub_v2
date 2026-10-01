package com.brother.ptouch.sdk.printdemo.model.printersearch

import android.content.Context
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.NetworkUtils
import com.brother.sdk.lmprinter.Channel
import com.brother.sdk.lmprinter.NetworkSearchOption
import com.brother.sdk.lmprinter.PrinterSearcher.cancelNetworkSearch
import com.brother.sdk.lmprinter.PrinterSearcher.startNetworkSearch
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class WiFiPrinterSearcher : IPrinterSearcher, CoroutineScope {
    companion object {
        const val searchDurationSeconds = 15.0
    }

    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()

    private var cancelRoutine: (() -> Unit)? = null

    override fun start(
        context: Context,
        targetModels: Array<String>,
        callback: (PrinterSearchError?, com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode?, ArrayList<DiscoveredPrinterInfo>) -> Unit
    ) {

        if (!NetworkUtils.isWiFiOn(context)) {
            callback.invoke(PrinterSearchError.WiFiOff, null, arrayListOf())
            return
        }

        if (!NetworkUtils.isWiFiConnected(context)) {
            callback.invoke(PrinterSearchError.WiFiNotConnect, null, arrayListOf())
            return
        }

        launch {
            val option = NetworkSearchOption(searchDurationSeconds, false)
            cancelRoutine = {
                cancelNetworkSearch()
            }
            val result = startNetworkSearch(context, option) { channel ->
                val info = DiscoveredPrinterInfo(
                        Channel.ChannelType.Wifi,
                        channel.extraInfo[Channel.ExtraInfoKey.ModelName] ?: "",
                        channel.channelInfo,
                        channel.extraInfo)
                launch(Dispatchers.Main) {
                    callback(PrinterSearchError.None, null, arrayListOf(info))
                }
            }
            cancelRoutine = null

            withContext(Dispatchers.Main) {
                callback(null, result.error.code, arrayListOf())
            }
        }
    }

    override fun cancel() {
        launch {
            cancelRoutine?.invoke()
            cancelRoutine = null
        }
    }
}

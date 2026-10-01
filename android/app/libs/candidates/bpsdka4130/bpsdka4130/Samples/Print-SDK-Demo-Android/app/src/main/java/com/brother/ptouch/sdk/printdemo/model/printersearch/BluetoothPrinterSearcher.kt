package com.brother.ptouch.sdk.printdemo.model.printersearch

import android.bluetooth.BluetoothManager
import android.content.Context
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.sdk.lmprinter.Channel
import com.brother.sdk.lmprinter.Channel.ChannelType
import com.brother.sdk.lmprinter.PrinterSearcher
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class BluetoothPrinterSearcher : IPrinterSearcher, CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()

    override fun start(
        context: Context,
        targetModels: Array<String>,
        callback: (PrinterSearchError?, com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode?, ArrayList<DiscoveredPrinterInfo>) -> Unit
    ) {
        val manager = context.getSystemService(BluetoothManager::class.java)
        val adapter = manager.adapter
        // For apps targeting Build.VERSION_CODES#R or lower, require permission：BLUETOOTH
        if (!adapter.isEnabled) {
            callback(PrinterSearchError.BluetoothOff, null, arrayListOf())
            return
        }

        launch {
            // OS >= android 12 require permission: BLUETOOTH_CONNECT
            val result = PrinterSearcher.startBluetoothSearch(context)
            val list = result.channels.map { channel ->
                DiscoveredPrinterInfo(
                        ChannelType.Bluetooth,
                        channel.extraInfo[Channel.ExtraInfoKey.ModelName] ?: "",
                        channel.channelInfo,
                        channel.extraInfo)
            }

            withContext(Dispatchers.Main) {
                callback(PrinterSearchError.None, result.error.code, ArrayList(list))
            }
        }
    }

    override fun cancel() {
        // ignore
    }
}

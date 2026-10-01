package com.brother.ptouch.sdk.printdemo.model.printersearch

import android.bluetooth.BluetoothManager
import android.content.Context
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.sdk.lmprinter.BLESearchOption
import com.brother.sdk.lmprinter.Channel
import com.brother.sdk.lmprinter.PrinterSearcher
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class BLEPrinterSearcher : IPrinterSearcher, CoroutineScope {
    companion object {
        const val searchDurationSeconds = 5.0
    }

    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()
    private var cancelRoutine: (() -> Unit)? = null

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
            cancelRoutine = {
                PrinterSearcher.cancelBLESearch()
            }
            // OS < android 12 require permission: BLUETOOTH_ADMIN
            // OS >= android 12 require permission: BLUETOOTH_SCAN && android:usesPermissionFlags="neverForLocation"
            // OS < android Q require permission: ACCESS_COARSE_LOCATION in order to get results
            // OS >= android Q require permission: ACCESS_FINE_LOCATION in order to get results
            // timeout: seconds
            val option = BLESearchOption(searchDurationSeconds)
            val result = PrinterSearcher.startBLESearch(context, option) { channel ->
                launch(Dispatchers.Main) {
                    callback(PrinterSearchError.None, null, arrayListOf(DiscoveredPrinterInfo(
                            Channel.ChannelType.BluetoothLowEnergy,
                            channel.extraInfo.get(Channel.ExtraInfoKey.ModelName) ?: "",
                            channel.channelInfo,
                            channel.extraInfo)))
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

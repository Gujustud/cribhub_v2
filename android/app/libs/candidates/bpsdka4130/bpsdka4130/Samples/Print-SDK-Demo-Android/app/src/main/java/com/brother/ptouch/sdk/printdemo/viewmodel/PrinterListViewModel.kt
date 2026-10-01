package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.getResId
import com.brother.ptouch.sdk.printdemo.model.printersearch.*
import com.brother.sdk.lmprinter.Channel.ChannelType
import com.brother.sdk.lmprinter.PrinterModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlin.coroutines.CoroutineContext

class PrinterListViewModel : ViewModel(), CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()

    var printerType: ChannelType? = null
    var printerList: ArrayList<DiscoveredPrinterInfo> = arrayListOf()

    var printerSearcher: IPrinterSearcher? = null

    fun setPrinterType(text: String, context: Context) {
        printerType = when (text) {
            context.getString(ChannelType.Wifi.getResId()) -> ChannelType.Wifi
            context.getString(ChannelType.Bluetooth.getResId()) -> ChannelType.Bluetooth
            context.getString(ChannelType.BluetoothLowEnergy.getResId()) -> ChannelType.BluetoothLowEnergy
            context.getString(ChannelType.USB.getResId()) -> ChannelType.USB
            else -> null
        }
    }

    fun stopSearch() {
        printerSearcher?.cancel()
    }

    fun search(
        context: Context,
        callback: (PrinterSearchError?, com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode?) -> Unit
    ) {
        printerList.clear()
        val searcher = getSearcher(printerType)
        searchAllModels(context, searcher, callback)
    }

    fun cancelSearching() {
        printerSearcher?.cancel()
    }

    private fun getSearcher(type: ChannelType?): IPrinterSearcher? {
        if (printerSearcher != null) {
            return printerSearcher
        }

        val target = when (type) {
            ChannelType.Wifi -> WiFiPrinterSearcher()
            ChannelType.Bluetooth -> BluetoothPrinterSearcher()
            ChannelType.BluetoothLowEnergy -> BLEPrinterSearcher()
            ChannelType.USB -> USBPrinterSearcher()
            null -> null
        }

        printerSearcher = target
        return target
    }

    private fun searchAllModels(
        context: Context,
        searcher: IPrinterSearcher?,
        callback: (PrinterSearchError?, com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode?) -> Unit
    ) {
        if (searcher == null) {
            callback(PrinterSearchError.None, null)
            return
        }

        val models = PrinterModel.values().map { it.name.replace('_', '-') }.toTypedArray()
        searcher.start(context, models, callback = { err, sdkError, data ->
            printerList.addAll(data)
            callback.invoke(err, sdkError)
        })
    }
}

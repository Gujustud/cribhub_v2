package com.brother.ptouch.sdk.printdemo.model

import android.os.Parcelable
import com.brother.ptouch.sdk.printdemo.R
import com.brother.sdk.lmprinter.Channel
import com.brother.sdk.lmprinter.PrinterModel
import kotlinx.parcelize.IgnoredOnParcel
import kotlinx.parcelize.Parcelize

fun Channel.ChannelType.getResId(): Int {
    return when (this) {
        Channel.ChannelType.USB -> R.string.usb
        Channel.ChannelType.Wifi -> R.string.network
        Channel.ChannelType.Bluetooth -> R.string.classic_bluetooth
        Channel.ChannelType.BluetoothLowEnergy -> R.string.bluetooth_low_energy
    }
}

@Parcelize
class DiscoveredPrinterInfo(var channelType: Channel.ChannelType,
                            var modelName: String,
                            var channelInfo: String,
                            var extraInfo: Map<Channel.ExtraInfoKey,String>) : Parcelable {
    @IgnoredOnParcel
    var determinedModel: PrinterModel? = null

    @IgnoredOnParcel
    var password: String? = null

    fun getPrinterModel(): PrinterModel? {
        return determinedModel ?: guessPrinterModels(modelName).firstOrNull()
    }

    fun getListOfWhatPrinterModel(): ArrayList<PrinterModel> {
        return guessPrinterModels(modelName)
    }
}

fun guessPrinterModels(modelName: String): ArrayList<PrinterModel> {
    var model: PrinterModel? = null
    PrinterModel.values().forEach {
        if (it.name.contains(Regex(".+_.+_.+"))) { // TD_2350D_203など
            return@forEach
        }
        if (modelName.lowercase().replace("-", "_").contains(it.name.lowercase())) {
            if (it.name.length >= (model?.name?.length ?: 0)) {
                model = it
            }
        }
    }
    if (model != null) {
        return arrayListOf(model!!)
    }

    var models: ArrayList<PrinterModel> = ArrayList<PrinterModel>()
    PrinterModel.values().forEach {
        if (it.name.contains(Regex(".+_.+_.+"))) { // TD_2350D_203など
            val nameWithoutResolution = it.name.replace(Regex("(.+_.+)_.+"), "$1")
            if (modelName.lowercase().replace("-", "_").contains(nameWithoutResolution.lowercase())) {
                models.add(it)
            }
        }
    }

    if(models.isEmpty()) {
        models = ArrayList<PrinterModel>(PrinterModel.values().toList())
    }
    return models
}

enum class PrinterInfoType {
    FirmVersion, Serial, Status, SystemReport, MediaVersion, Battery
}

package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.sdk.lmprinter.Channel

class SelectorWithSearchViewModel : ViewModel() {
    var currentPrinterInfo: DiscoveredPrinterInfo? = null
        set(value) {
            field = value

            var subinfo = mutableListOf<String>()

            bean.title.set(value?.modelName ?: "")
            if (value?.channelType == Channel.ChannelType.Wifi) {
                value.extraInfo.get(Channel.ExtraInfoKey.IpAddress)?.let{subinfo.add(it)}
            }
            if (value?.password != null) {
                value.password?.let{subinfo.add(it)}
            }
            bean.subTitle.set(subinfo.joinToString("\n"))
        }

    var bean: DisplayBean = DisplayBean()

    class DisplayBean : BaseObservable() {
        var title: ObservableField<String> = ObservableField("")
        var subTitle: ObservableField<String> = ObservableField("")
    }
}

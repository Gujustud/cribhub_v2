package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.getResId
import com.brother.sdk.lmprinter.Channel

class PrinterInterfaceViewModel : ViewModel() {
    fun getPrinterTypeList(context: Context): List<String> {
        return Channel.ChannelType.values().map { context.getString(it.getResId()) }.sorted()
    }
}

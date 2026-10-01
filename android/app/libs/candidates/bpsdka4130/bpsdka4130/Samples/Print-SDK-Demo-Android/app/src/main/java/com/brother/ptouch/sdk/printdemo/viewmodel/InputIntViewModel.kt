package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel

class InputIntViewModel : ViewModel() {
    var bean: DisplayBean = DisplayBean()
    fun getInputValue(): Int? {
        return bean.intValue.get()?.toIntOrNull()
    }

    class DisplayBean : BaseObservable() {
        var intValue: ObservableField<String> = ObservableField("")
        var message: ObservableField<String> = ObservableField("")

        fun onTextChanged(
            s: CharSequence,
            @Suppress("UNUSED_PARAMETER") start: Int,
            @Suppress("UNUSED_PARAMETER") before: Int,
            @Suppress("UNUSED_PARAMETER") count: Int
        ) {
            intValue.set(s.toString())
            message.set("")
        }
    }
}

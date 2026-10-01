package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel

class InputIntListViewModel : ViewModel() {
    var bean: DisplayBean = DisplayBean()

    fun getInputIntList(): ArrayList<Int> {
        val str = bean.intListString.get() ?: ""
        val result: ArrayList<Int> = arrayListOf()

        str.split(';').forEach {
            it.toIntOrNull()?.apply {
                result.add(this)
            }
        }

        return result
    }

    class DisplayBean : BaseObservable() {
        var intListString: ObservableField<String> = ObservableField("")
        var message: ObservableField<String> = ObservableField("")

        fun onTextChanged(
            s: CharSequence,
            @Suppress("UNUSED_PARAMETER") start: Int,
            @Suppress("UNUSED_PARAMETER") before: Int,
            @Suppress("UNUSED_PARAMETER") count: Int
        ) {
            intListString.set(s.toString())
            message.set("")
        }
    }
}

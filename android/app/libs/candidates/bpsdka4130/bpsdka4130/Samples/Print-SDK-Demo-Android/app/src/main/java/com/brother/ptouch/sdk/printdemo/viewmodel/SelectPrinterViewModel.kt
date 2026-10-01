package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.R
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.PrinterModelSpec

class SelectPrinterViewModel : ViewModel() {
    var isModelSpec: Boolean? = null
    fun getPrinterModelNameList(): List<String> {
        return PrinterModel.values().map { it.name }.sorted()
    }

    private fun <E> arrayToString(array: Array<E>): String {
        return "[" + array.joinToString { it.toString() } + "]"
    }

    fun getModelSpec(context: Context, model: PrinterModel): String {
        val spec = PrinterModelSpec(model)
        val hexCardinal = 16
        return context.getString(R.string.spec_xdpi) + ": " + spec.Xdpi + "\n" +
                context.getString(R.string.spec_ydpi) + ": " + spec.Ydpi + "\n" +
                context.getString(R.string.spec_series_code) + ": 0x" + spec.seriesCode.toString(hexCardinal) + "\n" +
                context.getString(R.string.spec_model_code) + ": 0x" + spec.modelCode.toString(hexCardinal) + "\n" +
                context.getString(R.string.spec_pt_label_supported) + ": " + arrayToString(spec.supportedPTLabels) + "\n" +
                context.getString(R.string.spec_ql_label_supported) + ": " + arrayToString(spec.supportedQLLabels) + "\n";

    }
}

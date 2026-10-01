package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleData

class MainViewModel : ViewModel() {
    fun getMainMenuList(context: Context): List<SimpleData> {
        return mutableListOf(
            SimpleData(false, context.getString(R.string.print_image)),
            SimpleData(false, context.getString(R.string.print_pdf)),
            SimpleData(false, context.getString(R.string.template_print)),
            SimpleData(false, context.getString(R.string.transfer_files)),
            SimpleData(false, context.getString(R.string.printer_info)),
            SimpleData(false, context.getString(R.string.model_spec)),
            SimpleData(false, context.getString(R.string.validate)),
            SimpleData(false, context.getString(R.string.file_analyze))
        )
    }
}

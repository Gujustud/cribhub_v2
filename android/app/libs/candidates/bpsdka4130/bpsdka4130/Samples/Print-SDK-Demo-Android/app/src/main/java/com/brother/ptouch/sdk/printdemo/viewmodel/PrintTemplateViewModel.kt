package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.R
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlin.coroutines.CoroutineContext

class PrintTemplateViewModel : ViewModel(), CoroutineScope {
    override val coroutineContext: CoroutineContext = Dispatchers.Default + Job()
    public lateinit var job : Job
    fun getPrintTemplateMenuList(context: Context): List<String> {
        return mutableListOf(
            context.getString(R.string.remove_template_with_key),
            context.getString(R.string.print_template)
        )
    }
}

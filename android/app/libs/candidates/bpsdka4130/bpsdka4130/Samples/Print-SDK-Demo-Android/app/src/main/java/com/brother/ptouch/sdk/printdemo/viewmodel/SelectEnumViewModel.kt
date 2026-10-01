package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.EnumDesc

class SelectEnumViewModel : ViewModel() {
    var displayData: MutableList<EnumDesc> = mutableListOf()
    var currentSelectedData: EnumDesc? = null
}

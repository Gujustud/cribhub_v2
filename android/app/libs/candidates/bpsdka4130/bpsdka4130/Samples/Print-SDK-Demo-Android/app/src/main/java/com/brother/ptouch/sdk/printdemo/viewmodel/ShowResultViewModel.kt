package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.TemplateData

class ShowResultViewModel : ViewModel() {
    var bean: DisplayBean = DisplayBean()

    class DisplayBean : BaseObservable() {
        var templateList: ObservableField<ArrayList<TemplateData>?> = ObservableField(arrayListOf())
    }
}

package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.TemplateEditType
import com.brother.ptouch.sdk.printdemo.model.TemplateEncoding
import com.brother.ptouch.sdk.printdemo.model.TemplatePrintData

class InputTemplateKeyViewModel : ViewModel() {
    var data: TemplatePrintData = TemplatePrintData(null, TemplateEncoding.UTF_8, TemplateEditType.Index, arrayListOf(), arrayListOf(), null, 1,false)
}

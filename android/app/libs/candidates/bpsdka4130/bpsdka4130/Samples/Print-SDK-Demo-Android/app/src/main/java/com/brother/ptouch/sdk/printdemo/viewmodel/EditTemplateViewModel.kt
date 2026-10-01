package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import android.widget.RadioGroup
import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.TemplateEditType
import com.brother.ptouch.sdk.printdemo.model.TemplateEncoding
import com.brother.ptouch.sdk.printdemo.model.TemplatePrintData
import com.brother.ptouch.sdk.printdemo.model.print.PrintTemplateTask
import com.brother.ptouch.sdk.printdemo.ui.EditTemplateFragment
import com.brother.sdk.lmprinter.TemplateObjectReplacer

class EditTemplateViewModel : ViewModel() {
    var data: TemplatePrintData? = null
    val bean: Bean = Bean()
    private val printTask = PrintTemplateTask()
    fun starPrintTemplate(context: Context, callback: (String) -> Unit) {
        val currentPrint = PrintDemoApp.instance.currentSelectedPrinter
        if (currentPrint != null) {
            if (data != null)
                printTask.startPrint(context, currentPrint, data!!, callback)
            else
                callback.invoke(context.getString(R.string.no_print_data))
        } else
            callback.invoke(context.getString(R.string.select_printer_message))
    }

    fun cancelPrint() {
        printTask.cancelPrint()
    }

    fun addInputData(index: String, objectName: String, text: String, encode: TemplateEncoding) {
        if (data == null) return
        val dataMap = HashMap<String, String>()
        if (data!!.itemList.isEmpty() || data!!.itemList.last().keys.last() == EditTemplateFragment.KeyEnd) {
            val tempData = HashMap<String, String>()
            tempData[EditTemplateFragment.KeyStartTemplate] = data!!.key.toString()
            data!!.itemList.add(tempData)
            data!!.replacer = ArrayList<TemplateObjectReplacer>()
        }

        when (bean.selectedEditType.get()) {
            TemplateEditType.Index -> {
                dataMap[EditTemplateFragment.KeyIndex] = index
                data!!.replacer.add(TemplateObjectReplacer(index.safeToInt(), text, transformEncode(encode)))
            }
            TemplateEditType.ObjectName -> {
                dataMap[EditTemplateFragment.KeyObjectName] = objectName
                data!!.replacer.add(TemplateObjectReplacer(objectName, text, transformEncode(encode)))
            }
            TemplateEditType.NoText -> {
            }
            null -> return
        }
        dataMap[EditTemplateFragment.KeyText] = text
        dataMap[EditTemplateFragment.KeyEncoding] = encode.toString();
        data!!.itemList.add(dataMap)
    }

    private fun transformEncode(encode:TemplateEncoding) : TemplateObjectReplacer.Encode {
        return when (encode) {
            TemplateEncoding.UTF_8 -> TemplateObjectReplacer.Encode.UTF_8
            TemplateEncoding.CHN_GB_18030_2000 -> TemplateObjectReplacer.Encode.GB_18030_2000
            TemplateEncoding.JPN_SHIFT_JIS -> TemplateObjectReplacer.Encode.SHIFT_JIS
        }
    }

    fun deleteInputData() {
        data?.itemList?.let { itemList ->
            if (itemList.size == 2) {
                itemList.clear()
                data!!.replacer.clear()
            } else {
                itemList.removeLastOrNull()
                data!!.replacer.removeLastOrNull()
            }
        }
    }

    fun addEndKey() {
        data?.itemList?.let { itemList ->
            if (itemList.isEmpty() || itemList.last().keys.last() == "End") return
            val endMap = HashMap<String, String>()
            endMap[EditTemplateFragment.KeyEnd] = ""
            itemList.add(endMap)
        }
    }

    class Bean : BaseObservable() {
        var selectedEditType: ObservableField<TemplateEditType> = ObservableField(TemplateEditType.Index)

        fun onCheckedChanged(@Suppress("UNUSED_PARAMETER") group: RadioGroup?, checkedId: Int) {
            when (checkedId) {
                R.id.edit_template_index -> selectedEditType.set(TemplateEditType.Index)
                R.id.edit_template_object -> selectedEditType.set(TemplateEditType.ObjectName)
                else -> {}
            }
        }
    }
}

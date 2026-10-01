package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.TemplatePrintData
import com.brother.ptouch.sdk.printdemo.model.printsettings.PrintSettingsItemType

class TemplatePrintSettingsViewModel : ViewModel() {
    var data: TemplatePrintData? = null

    fun getOptionsInfoList(): MutableMap<PrintSettingsItemType, Any> {
        val modelName = data?.modelName ?: ""
        val copies = data?.copies ?: 1
        val peel = if (data?.peel ?: false) "ON" else "OFF"
        var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = modelName
        settingsMap[PrintSettingsItemType.NUM_COPIES] = copies.toString()

        if (modelName.startsWith("PJ")) {
            // nop
        } else if (modelName.startsWith("MW")) {
            // nop
        } else if (modelName.startsWith("RJ")) {
            settingsMap[PrintSettingsItemType.PEEL_LABEL] = peel
        } else if (modelName.startsWith("QL")) {
            // nop
        } else if (modelName.startsWith("TD")) {
            settingsMap[PrintSettingsItemType.PEEL_LABEL] = peel
        } else if (modelName.startsWith("PT")) {
            // nop
        }

        return settingsMap
    }

    fun setSettingsMap(key: PrintSettingsItemType, value: Any) {
        when (key) {
            PrintSettingsItemType.NUM_COPIES -> {
                if(value is String) {
                    data?.copies = value.safeToInt()
                }
            }
            PrintSettingsItemType.PEEL_LABEL -> {
                if(value is String) {
                    data?.peel = (value == "ON")
                }
            }
            else -> {}
        }
    }

    fun getSettingItemList(key: PrintSettingsItemType): Array<String> {
        return when (key) {
            PrintSettingsItemType.PEEL_LABEL -> {
                arrayOf("ON", "OFF")
            }
            else -> { arrayOf() }
        }
    }
}

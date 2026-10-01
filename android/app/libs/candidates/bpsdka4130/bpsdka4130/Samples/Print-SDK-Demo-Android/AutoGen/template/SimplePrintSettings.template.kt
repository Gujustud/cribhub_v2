package com.brother.ptouch.sdk.printdemo.model.printsettings

import com.brother.ptouch.sdk.printdemo.R
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.PrintSettings
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport

interface ISimplePrintSettings {
    val printerModel: PrinterModel
    var settingsMap: MutableMap<PrintSettingsItemType, Any>

    fun getSettingItemList(key: PrintSettingsItemType): Array<String>

    fun setSettingInfo(key: PrintSettingsItemType, message: Any)

    fun getPrintSettings(): PrintSettings

    fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {}
}

enum class PrintSettingsItemType(val stringId: Int) {
{% set ITEMTYPES = [] %}
{% for element in elementSetDictionary["GeneralPrintSettings"].elements %}
    {% set _ = ITEMTYPES.append(snakeCase(withoutPrefix(inSyntax(element.key))).upper()) %}
{% endfor %}
{% set ITEMTYPES = removeDuplicates(ITEMTYPES) %}
{% for value in ITEMTYPES %}
    {{ value }}(R.string.{{ value.lower() }}),
{% endfor %}
}


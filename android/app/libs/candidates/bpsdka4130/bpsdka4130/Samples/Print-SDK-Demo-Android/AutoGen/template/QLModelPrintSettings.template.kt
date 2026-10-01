package com.brother.ptouch.sdk.printdemo.model.printsettings

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToFloat
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.PrintImageSettings.*
import com.brother.sdk.lmprinter.setting.PrintSettings
import com.brother.sdk.lmprinter.setting.QLPrintSettings
import com.brother.sdk.lmprinter.setting.QLPrintSettings.LabelSize
import com.brother.sdk.lmprinter.setting.ValidatePrintSettings
import com.brother.sdk.lmprinter.setting.ValidatePrintSettingsReport
{% set ELEMENTS = [] %}
{% if ELEMENTS.extend(elementSetDictionary["BRLMPrintImageSettings"].elements) %} {% endif %}
{% if ELEMENTS.extend(elementSetDictionary["BRLMQLPrintSettings"].elements) %} {% endif %}
{% macro typeKey(key) -%}
{{ snakeCase(withoutPrefix(inSyntax(key))).upper() }}
{%- endmacro %}
{% set settingName = "qlSettings" %}
{% set settingClass = "QLPrintSettings" %}

class QLModelPrintSettings(val context: Context, override val printerModel: PrinterModel) : ISimplePrintSettings {
    private var {{ settingName }} = {{ settingClass }}(printerModel)
    override var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()

    init {
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = printerModel.name
{% for element in ELEMENTS if not element.key == "BRLMPrinterModel"%}
    {% if element.type == Type.enum %}
        settingsMap[PrintSettingsItemType.{{ typeKey(element.key) }}] = {{ settingName }}.{{ withoutSurfix(element.exif) }}.name
    {% elif element.type == Type.int %}
        settingsMap[PrintSettingsItemType.{{ typeKey(element.key) }}] = {{ settingName }}.{{ withoutSurfix(element.exif) }}.toString()
    {% elif element.type == Type.float %}
        settingsMap[PrintSettingsItemType.{{ typeKey(element.key) }}] = {{ settingName }}.{{ withoutSurfix(element.exif) }}.toString()
    {% elif element.type == Type.bool %}
        settingsMap[PrintSettingsItemType.{{ typeKey(element.key) }}] = if ({{ settingName }}.is{{ headUpper(withoutSurfix(element.exif)) }}) "ON" else "OFF"
    {% elif element.type == Type.string %}
        settingsMap[PrintSettingsItemType.{{ typeKey(element.key) }}] = {{ settingName }}.{{ withoutSurfix(element.exif) }} ?: ""
    {% elif element.type == Type.object %}
    {% elif element.type == Type.struct %}
    {% elif element.type == Type.uint8 %}
        settingsMap[PrintSettingsItemType.{{ typeKey(element.key) }}] = {{ settingName }}.{{ withoutSurfix(element.exif) }}.toString()
    {% endif %}
{% endfor %}
    }

    override fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {
        super.validateSettings(callback)
        val report = ValidatePrintSettings.validate({{ settingName }})
        callback(report)
    }

    override fun getSettingItemList(key: PrintSettingsItemType): Array<String> {
        var itemList: Array<String> = arrayOf()
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                itemList = arrayOf(context.getString(R.string.in_app_folder), context.getString(R.string.external_folder))
            }
{% for element in ELEMENTS if not element.key == "BRLMPrinterModel" and not element.key == "BRLMPrintSettingsWorkPath" %}
    {% if element.type == Type.enum %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                itemList = {{ headUpper(withoutPrefix(element.key)) }}.values().map { it.name }.toTypedArray()
            }
    {% elif element.type == Type.int %}
    {% elif element.type == Type.float %}
    {% elif element.type == Type.bool %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                itemList = arrayOf("ON", "OFF")
            }
    {% elif element.type == Type.string %}
    {% elif element.type == Type.object %}
    {% elif element.type == Type.struct %}
    {% elif element.type == Type.uint8 %}
    {% endif %}
{% endfor %}
            else -> {}
        }
        return itemList
    }

    override fun setSettingInfo(key: PrintSettingsItemType, message: Any) {

        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                {{ settingName }}.workPath = if (message == context.getString(R.string.in_app_folder))
                    StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
            }
{% for element in ELEMENTS if not element.key == "BRLMPrinterModel" and not element.key == "BRLMPrintSettingsWorkPath" %}
    {% if element.type == Type.enum %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                {{ settingName }}.{{ withoutSurfix(element.exif) }} = {{ headUpper(withoutPrefix(element.key)) }}.values().firstOrNull { value -> value.name == message }
            }
    {% elif element.type == Type.int %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                {{ settingName }}.{{ withoutSurfix(element.exif) }} = message.toString().safeToInt()
            }
    {% elif element.type == Type.float %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                {{ settingName }}.{{ withoutSurfix(element.exif) }} = message.toString().safeToFloat()
            }
    {% elif element.type == Type.bool %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                {{ settingName }}.is{{ headUpper(withoutSurfix(element.exif)) }} = message == "ON"
            }
    {% elif element.type == Type.string %}
    {% elif element.type == Type.object %}
    {% elif element.type == Type.struct %}
    {% elif element.type == Type.uint8 %}
            PrintSettingsItemType.{{ typeKey(element.key) }} -> {
                {{ settingName }}.{{ withoutSurfix(element.exif) }} = message.toString().safeToInt()
            }
    {% endif %}
{% endfor %}
            else -> {}
        }
    }

    override fun getPrintSettings(): PrintSettings {
        return {{ settingName }}
    }
}


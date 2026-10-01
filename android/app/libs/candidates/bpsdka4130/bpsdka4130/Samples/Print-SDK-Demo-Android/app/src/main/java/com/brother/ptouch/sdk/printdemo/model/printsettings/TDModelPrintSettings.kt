package com.brother.ptouch.sdk.printdemo.model.printsettings

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToFloat
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.*

class TDModelPrintSettings(val context: Context, override val printerModel: PrinterModel) : ISimplePrintSettings {
    private var tdSettings = TDPrintSettings(printerModel)
    override var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()

    init {
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = printerModel.name
        settingsMap[PrintSettingsItemType.CUSTOM_PAPER_SIZE] = tdSettings.customPaperSize
        settingsMap[PrintSettingsItemType.SCALE_MODE] = tdSettings.scaleMode.name
        settingsMap[PrintSettingsItemType.SCALE_VALUE] = tdSettings.scaleValue.toString()
        settingsMap[PrintSettingsItemType.ORIENTATION] = tdSettings.printOrientation.name
        settingsMap[PrintSettingsItemType.ROTATION] = tdSettings.imageRotation.name
        settingsMap[PrintSettingsItemType.HALFTONE] = tdSettings.halftone.name
        settingsMap[PrintSettingsItemType.HORIZONTAL_ALIGNMENT] = tdSettings.hAlignment.name
        settingsMap[PrintSettingsItemType.VERTICAL_ALIGNMENT] = tdSettings.vAlignment.name
        settingsMap[PrintSettingsItemType.COMPRESS_MODE] = tdSettings.compress.name
        settingsMap[PrintSettingsItemType.HALFTONE_THRESHOLD] = tdSettings.halftoneThreshold.toString()
        settingsMap[PrintSettingsItemType.NUM_COPIES] = tdSettings.numCopies.toString()
        settingsMap[PrintSettingsItemType.SKIP_STATUS_CHECK] = if (tdSettings.isSkipStatusCheck) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PRINT_QUALITY] = tdSettings.printQuality.name
        settingsMap[PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA] = if (tdSettings.isTrimTrailingBlankData) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.WORK_PATH] = tdSettings.workPath ?: ""
        settingsMap[PrintSettingsItemType.DENSITY] = tdSettings.density.name
        settingsMap[PrintSettingsItemType.PEEL_LABEL] = if (tdSettings.isPeelLabel) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.AUTO_CUT] = if (tdSettings.isAutoCut) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.CUT_AT_END] = if (tdSettings.isCutAtEnd) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT] = tdSettings.autoCutForEachPageCount.toString()
        settingsMap[PrintSettingsItemType.FEED_DIRECTION_MARGINS] = tdSettings.feedDirectionMargins.toString()
        settingsMap[PrintSettingsItemType.CUSTOM_RECORD] = tdSettings.customRecord ?: ""
    }

    override fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {
        super.validateSettings(callback)
        val report = ValidatePrintSettings.validate(tdSettings)
        callback(report)
    }

    fun getCustomPaperSize(): CustomPaperSize? {
        if (settingsMap[PrintSettingsItemType.CUSTOM_PAPER_SIZE] is CustomPaperSize) {
            return settingsMap[PrintSettingsItemType.CUSTOM_PAPER_SIZE] as CustomPaperSize
        }
        return null
    }

    override fun getSettingItemList(key: PrintSettingsItemType): Array<String> {
        var itemList: Array<String> = arrayOf()
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                itemList = arrayOf(context.getString(R.string.in_app_folder), context.getString(R.string.external_folder))
            }
            PrintSettingsItemType.SCALE_MODE -> {
                itemList = PrintImageSettings.ScaleMode.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.ORIENTATION -> {
                itemList = PrintImageSettings.Orientation.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.ROTATION -> {
                itemList = PrintImageSettings.Rotation.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.HALFTONE -> {
                itemList = PrintImageSettings.Halftone.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                itemList = PrintImageSettings.HorizontalAlignment.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                itemList = PrintImageSettings.VerticalAlignment.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                itemList = PrintImageSettings.CompressMode.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                itemList = PrintImageSettings.PrintQuality.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.DENSITY -> {
                itemList = TDPrintSettings.Density.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.PEEL_LABEL -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.AUTO_CUT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.CUT_AT_END -> {
                itemList = arrayOf("ON", "OFF")
            }
            else -> {}
        }
        return itemList
    }

    override fun getPrintSettings(): PrintSettings {
        return tdSettings
    }

    override fun setSettingInfo(key: PrintSettingsItemType, message: Any) {
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                tdSettings.workPath = if (message == context.getString(R.string.in_app_folder))
                    StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
            }
            PrintSettingsItemType.CUSTOM_PAPER_SIZE -> {
                tdSettings.customPaperSize = message as CustomPaperSize
            }
            PrintSettingsItemType.SCALE_MODE -> {
                tdSettings.scaleMode = PrintImageSettings.ScaleMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.SCALE_VALUE -> {
                tdSettings.scaleValue = message.toString().safeToFloat()
            }
            PrintSettingsItemType.ORIENTATION -> {
                tdSettings.printOrientation = PrintImageSettings.Orientation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROTATION -> {
                tdSettings.imageRotation = PrintImageSettings.Rotation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE -> {
                tdSettings.halftone = PrintImageSettings.Halftone.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                tdSettings.hAlignment = PrintImageSettings.HorizontalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                tdSettings.vAlignment = PrintImageSettings.VerticalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                tdSettings.compress = PrintImageSettings.CompressMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE_THRESHOLD -> {
                tdSettings.halftoneThreshold = message.toString().safeToInt()
            }
            PrintSettingsItemType.NUM_COPIES -> {
                tdSettings.numCopies = message.toString().safeToInt()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                tdSettings.isSkipStatusCheck = message == "ON"
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                tdSettings.printQuality = PrintImageSettings.PrintQuality.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                tdSettings.isTrimTrailingBlankData = message == "ON"
            }
            PrintSettingsItemType.DENSITY -> {
                tdSettings.density = TDPrintSettings.Density.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.PEEL_LABEL -> {
                tdSettings.isPeelLabel = message == "ON"
            }
            PrintSettingsItemType.AUTO_CUT -> {
                tdSettings.isAutoCut = message == "ON"
            }
            PrintSettingsItemType.CUT_AT_END -> {
                tdSettings.isCutAtEnd = message == "ON"
            }
            PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT -> {
                tdSettings.autoCutForEachPageCount = message.toString().safeToInt()
            }
            PrintSettingsItemType.FEED_DIRECTION_MARGINS -> {
                tdSettings.feedDirectionMargins = message.toString().safeToInt()
            }
            PrintSettingsItemType.CUSTOM_RECORD -> {
                tdSettings.customRecord = message.toString()
            }
            else -> {}
        }
    }
}
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

class QLModelPrintSettings(val context: Context, override val printerModel: PrinterModel) : ISimplePrintSettings {
    private var qlSettings = QLPrintSettings(printerModel)
    override var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()

    init {
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = printerModel.name
        settingsMap[PrintSettingsItemType.SCALE_MODE] = qlSettings.scaleMode.name
        settingsMap[PrintSettingsItemType.SCALE_VALUE] = qlSettings.scaleValue.toString()
        settingsMap[PrintSettingsItemType.ORIENTATION] = qlSettings.printOrientation.name
        settingsMap[PrintSettingsItemType.ROTATION] = qlSettings.imageRotation.name
        settingsMap[PrintSettingsItemType.HALFTONE] = qlSettings.halftone.name
        settingsMap[PrintSettingsItemType.HORIZONTAL_ALIGNMENT] = qlSettings.hAlignment.name
        settingsMap[PrintSettingsItemType.VERTICAL_ALIGNMENT] = qlSettings.vAlignment.name
        settingsMap[PrintSettingsItemType.COMPRESS_MODE] = qlSettings.compress.name
        settingsMap[PrintSettingsItemType.HALFTONE_THRESHOLD] = qlSettings.halftoneThreshold.toString()
        settingsMap[PrintSettingsItemType.NUM_COPIES] = qlSettings.numCopies.toString()
        settingsMap[PrintSettingsItemType.SKIP_STATUS_CHECK] = if (qlSettings.isSkipStatusCheck) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PRINT_QUALITY] = qlSettings.printQuality.name
        settingsMap[PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA] = if (qlSettings.isTrimTrailingBlankData) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.WORK_PATH] = qlSettings.workPath ?: ""
        settingsMap[PrintSettingsItemType.LABEL_SIZE] = qlSettings.labelSize.name
        settingsMap[PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT] = qlSettings.autoCutForEachPageCount.toString()
        settingsMap[PrintSettingsItemType.AUTO_CUT] = if (qlSettings.isAutoCut) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.CUT_AT_END] = if (qlSettings.isCutAtEnd) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.RESOLUTION] = qlSettings.resolution.name
        settingsMap[PrintSettingsItemType.BI_COLOR_RED_ENHANCEMENT] = qlSettings.biColorRedEnhancement.toString()
        settingsMap[PrintSettingsItemType.BI_COLOR_GREEN_ENHANCEMENT] = qlSettings.biColorGreenEnhancement.toString()
        settingsMap[PrintSettingsItemType.BI_COLOR_BLUE_ENHANCEMENT] = qlSettings.biColorBlueEnhancement.toString()
        settingsMap[PrintSettingsItemType.FEED_DIRECTION_MARGINS] = qlSettings.feedDirectionMargins.toString()
    }

    override fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {
        super.validateSettings(callback)
        val report = ValidatePrintSettings.validate(qlSettings)
        callback(report)
    }

    override fun getSettingItemList(key: PrintSettingsItemType): Array<String> {
        var itemList: Array<String> = arrayOf()
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                itemList = arrayOf(context.getString(R.string.in_app_folder), context.getString(R.string.external_folder))
            }
            PrintSettingsItemType.SCALE_MODE -> {
                itemList = ScaleMode.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.ORIENTATION -> {
                itemList = Orientation.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.ROTATION -> {
                itemList = Rotation.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.HALFTONE -> {
                itemList = Halftone.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                itemList = HorizontalAlignment.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                itemList = VerticalAlignment.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                itemList = CompressMode.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                itemList = PrintQuality.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.LABEL_SIZE -> {
                itemList = LabelSize.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.AUTO_CUT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.CUT_AT_END -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.RESOLUTION -> {
                itemList = Resolution.values().map { it.name }.toTypedArray()
            }
            else -> {}
        }
        return itemList
    }

    override fun setSettingInfo(key: PrintSettingsItemType, message: Any) {

        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                qlSettings.workPath = if (message == context.getString(R.string.in_app_folder))
                    StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
            }
            PrintSettingsItemType.SCALE_MODE -> {
                qlSettings.scaleMode = ScaleMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.SCALE_VALUE -> {
                qlSettings.scaleValue = message.toString().safeToFloat()
            }
            PrintSettingsItemType.ORIENTATION -> {
                qlSettings.printOrientation = Orientation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROTATION -> {
                qlSettings.imageRotation = Rotation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE -> {
                qlSettings.halftone = Halftone.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                qlSettings.hAlignment = HorizontalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                qlSettings.vAlignment = VerticalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                qlSettings.compress = CompressMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE_THRESHOLD -> {
                qlSettings.halftoneThreshold = message.toString().safeToInt()
            }
            PrintSettingsItemType.NUM_COPIES -> {
                qlSettings.numCopies = message.toString().safeToInt()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                qlSettings.isSkipStatusCheck = message == "ON"
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                qlSettings.printQuality = PrintQuality.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                qlSettings.isTrimTrailingBlankData = message == "ON"
            }
            PrintSettingsItemType.LABEL_SIZE -> {
                qlSettings.labelSize = LabelSize.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT -> {
                qlSettings.autoCutForEachPageCount = message.toString().safeToInt()
            }
            PrintSettingsItemType.AUTO_CUT -> {
                qlSettings.isAutoCut = message == "ON"
            }
            PrintSettingsItemType.CUT_AT_END -> {
                qlSettings.isCutAtEnd = message == "ON"
            }
            PrintSettingsItemType.RESOLUTION -> {
                qlSettings.resolution = Resolution.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.BI_COLOR_RED_ENHANCEMENT -> {
                qlSettings.biColorRedEnhancement = message.toString().safeToInt()
            }
            PrintSettingsItemType.BI_COLOR_GREEN_ENHANCEMENT -> {
                qlSettings.biColorGreenEnhancement = message.toString().safeToInt()
            }
            PrintSettingsItemType.BI_COLOR_BLUE_ENHANCEMENT -> {
                qlSettings.biColorBlueEnhancement = message.toString().safeToInt()
            }
            PrintSettingsItemType.FEED_DIRECTION_MARGINS -> {
                qlSettings.feedDirectionMargins = message.toString().safeToInt()
            }
            else -> {}
        }
    }

    override fun getPrintSettings(): PrintSettings {
        return qlSettings
    }
}

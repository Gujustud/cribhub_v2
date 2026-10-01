package com.brother.ptouch.sdk.printdemo.model.printsettings

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToFloat
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.*

class RJModelPrintSettings(val context: Context, override val printerModel: PrinterModel) : ISimplePrintSettings {
    private var rjSettings = RJPrintSettings(printerModel)
    override var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()

    init {
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = printerModel.name
        settingsMap[PrintSettingsItemType.CUSTOM_PAPER_SIZE] = rjSettings.customPaperSize
        settingsMap[PrintSettingsItemType.SCALE_MODE] = rjSettings.scaleMode.name
        settingsMap[PrintSettingsItemType.SCALE_VALUE] = rjSettings.scaleValue.toString()
        settingsMap[PrintSettingsItemType.ORIENTATION] = rjSettings.printOrientation.name
        settingsMap[PrintSettingsItemType.ROTATION] = rjSettings.imageRotation.name
        settingsMap[PrintSettingsItemType.HALFTONE] = rjSettings.halftone.name
        settingsMap[PrintSettingsItemType.HORIZONTAL_ALIGNMENT] = rjSettings.hAlignment.name
        settingsMap[PrintSettingsItemType.VERTICAL_ALIGNMENT] = rjSettings.vAlignment.name
        settingsMap[PrintSettingsItemType.COMPRESS_MODE] = rjSettings.compress.name
        settingsMap[PrintSettingsItemType.HALFTONE_THRESHOLD] = rjSettings.halftoneThreshold.toString()
        settingsMap[PrintSettingsItemType.NUM_COPIES] = rjSettings.numCopies.toString()
        settingsMap[PrintSettingsItemType.SKIP_STATUS_CHECK] = if (rjSettings.isSkipStatusCheck) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PRINT_QUALITY] = rjSettings.printQuality.name
        settingsMap[PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA] = if (rjSettings.isTrimTrailingBlankData) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.WORK_PATH] = rjSettings.workPath ?: ""
        settingsMap[PrintSettingsItemType.DENSITY] = rjSettings.density.name
        @Suppress("DEPRECATION")
        settingsMap[PrintSettingsItemType.ROTATE180DEGREES] = if (rjSettings.isRotate180degrees) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PEEL_LABEL] = if (rjSettings.isPeelLabel) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.FEED_DIRECTION_MARGINS] = rjSettings.feedDirectionMargins.toString()
    }

    fun getCustomPaperSize(): CustomPaperSize? {
        if (settingsMap[PrintSettingsItemType.CUSTOM_PAPER_SIZE] is CustomPaperSize) {
            return settingsMap[PrintSettingsItemType.CUSTOM_PAPER_SIZE] as CustomPaperSize
        }
        return null
    }

    override fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {
        super.validateSettings(callback)
        val report = ValidatePrintSettings.validate(rjSettings)
        callback(report)
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
                itemList = RJPrintSettings.Density.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.ROTATE180DEGREES -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.PEEL_LABEL -> {
                itemList = arrayOf("ON", "OFF")
            }
            else -> {}
        }
        return itemList
    }

    override fun getPrintSettings(): PrintSettings {
        return rjSettings
    }

    override fun setSettingInfo(key: PrintSettingsItemType, message: Any) {
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                rjSettings.workPath = if (message == context.getString(R.string.in_app_folder))
                    StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
            }
            PrintSettingsItemType.CUSTOM_PAPER_SIZE -> {
                rjSettings.customPaperSize = message as CustomPaperSize
            }
            PrintSettingsItemType.SCALE_MODE -> {
                rjSettings.scaleMode = PrintImageSettings.ScaleMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.SCALE_VALUE -> {
                rjSettings.scaleValue = message.toString().safeToFloat()
            }
            PrintSettingsItemType.ORIENTATION -> {
                rjSettings.printOrientation = PrintImageSettings.Orientation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROTATION -> {
                rjSettings.imageRotation = PrintImageSettings.Rotation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE -> {
                rjSettings.halftone = PrintImageSettings.Halftone.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                rjSettings.hAlignment = PrintImageSettings.HorizontalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                rjSettings.vAlignment = PrintImageSettings.VerticalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                rjSettings.compress = PrintImageSettings.CompressMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE_THRESHOLD -> {
                rjSettings.halftoneThreshold = message.toString().safeToInt()
            }
            PrintSettingsItemType.NUM_COPIES -> {
                rjSettings.numCopies = message.toString().safeToInt()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                rjSettings.isSkipStatusCheck = message == "ON"
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                rjSettings.printQuality = PrintImageSettings.PrintQuality.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                rjSettings.isTrimTrailingBlankData = message == "ON"
            }
            PrintSettingsItemType.DENSITY -> {
                rjSettings.density = RJPrintSettings.Density.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROTATE180DEGREES -> {
                @Suppress("DEPRECATION")
                rjSettings.isRotate180degrees = message == "ON"
            }
            PrintSettingsItemType.PEEL_LABEL -> {
                rjSettings.isPeelLabel = message == "ON"
            }
            PrintSettingsItemType.FEED_DIRECTION_MARGINS -> {
                rjSettings.feedDirectionMargins = message.toString().safeToInt()
            }
            else -> {}
        }
    }
}

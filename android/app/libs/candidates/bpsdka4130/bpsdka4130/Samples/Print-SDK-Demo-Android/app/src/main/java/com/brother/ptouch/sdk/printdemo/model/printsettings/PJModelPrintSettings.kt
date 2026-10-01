package com.brother.ptouch.sdk.printdemo.model.printsettings

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToFloat
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.*
import com.brother.sdk.lmprinter.setting.PJPrintSettings.*

class PJModelPrintSettings(val context: Context, override val printerModel: PrinterModel) : ISimplePrintSettings {
    private var pjSettings = PJPrintSettings(printerModel)
    override var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()

    init {
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = printerModel.name
        settingsMap[PrintSettingsItemType.PAPER_SIZE] = pjSettings.paperSize
        settingsMap[PrintSettingsItemType.SCALE_MODE] = pjSettings.scaleMode.name
        settingsMap[PrintSettingsItemType.SCALE_VALUE] = pjSettings.scaleValue.toString()
        settingsMap[PrintSettingsItemType.ORIENTATION] = pjSettings.printOrientation.name
        settingsMap[PrintSettingsItemType.ROTATION] = pjSettings.imageRotation.name
        settingsMap[PrintSettingsItemType.HALFTONE] = pjSettings.halftone.name
        settingsMap[PrintSettingsItemType.HORIZONTAL_ALIGNMENT] = pjSettings.hAlignment.name
        settingsMap[PrintSettingsItemType.VERTICAL_ALIGNMENT] = pjSettings.vAlignment.name
        settingsMap[PrintSettingsItemType.COMPRESS_MODE] = pjSettings.compress.name
        settingsMap[PrintSettingsItemType.HALFTONE_THRESHOLD] = pjSettings.halftoneThreshold.toString()
        settingsMap[PrintSettingsItemType.NUM_COPIES] = pjSettings.numCopies.toString()
        settingsMap[PrintSettingsItemType.SKIP_STATUS_CHECK] = if (pjSettings.isSkipStatusCheck) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PRINT_QUALITY] = pjSettings.printQuality.name
        settingsMap[PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA] = if (pjSettings.isTrimTrailingBlankData) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.WORK_PATH] = pjSettings.workPath ?: ""
        settingsMap[PrintSettingsItemType.PAPER_TYPE] = pjSettings.paperType.name
        settingsMap[PrintSettingsItemType.PAPER_INSERTION_POSITION] = pjSettings.paperInsertionPosition.name
        settingsMap[PrintSettingsItemType.FEED_MODE] = pjSettings.feedMode.name
        settingsMap[PrintSettingsItemType.EXTRA_FEED_DOTS] = pjSettings.extraFeedDots.toString()
        settingsMap[PrintSettingsItemType.DENSITY] = pjSettings.density.name
        settingsMap[PrintSettingsItemType.ROLL_CASE] = pjSettings.rollCase.name
        settingsMap[PrintSettingsItemType.PRINT_SPEED] = pjSettings.printSpeed.name
        settingsMap[PrintSettingsItemType.USING_CARBON_COPY_PAPER] = if (pjSettings.isUsingCarbonCopyPaper) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PRINT_DASH_LINE] = if (pjSettings.isPrintDashLine) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.FORCE_STRETCH_PRINTABLE_AREA] = pjSettings.forceStretchPrintableArea.toString()
    }

    override fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {
        super.validateSettings(callback)
        val report = ValidatePrintSettings.validate(pjSettings)
        callback(report)
    }

    fun getPaperSize(): PJPaperSize? {
        if (settingsMap[PrintSettingsItemType.PAPER_SIZE] is PJPaperSize) {
            return settingsMap[PrintSettingsItemType.PAPER_SIZE] as PJPaperSize
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
            PrintSettingsItemType.PAPER_TYPE -> {
                itemList = PJPrintSettings.PaperType.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.PAPER_INSERTION_POSITION -> {
                itemList = PJPrintSettings.PaperInsertionPosition.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.FEED_MODE -> {
                itemList = PJPrintSettings.FeedMode.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.DENSITY -> {
                itemList = PJPrintSettings.Density.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.ROLL_CASE -> {
                itemList = PJPrintSettings.RollCase.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.PRINT_SPEED -> {
                itemList = PJPrintSettings.PrintSpeed.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.USING_CARBON_COPY_PAPER -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.PRINT_DASH_LINE -> {
                itemList = arrayOf("ON", "OFF")
            }
            else -> {}
        }
        return itemList
    }

    override fun getPrintSettings(): PrintSettings {
        return pjSettings
    }

    override fun setSettingInfo(key: PrintSettingsItemType, message: Any) {
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                pjSettings.workPath = if (message == context.getString(R.string.in_app_folder))
                    StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
            }
            PrintSettingsItemType.PAPER_SIZE -> {
                pjSettings.paperSize = message as PJPaperSize
            }
            PrintSettingsItemType.SCALE_MODE -> {
                pjSettings.scaleMode = PrintImageSettings.ScaleMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.SCALE_VALUE -> {
                pjSettings.scaleValue = message.toString().safeToFloat()
            }
            PrintSettingsItemType.ORIENTATION -> {
                pjSettings.printOrientation = PrintImageSettings.Orientation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROTATION -> {
                pjSettings.imageRotation = PrintImageSettings.Rotation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE -> {
                pjSettings.halftone = PrintImageSettings.Halftone.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                pjSettings.hAlignment = PrintImageSettings.HorizontalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                pjSettings.vAlignment = PrintImageSettings.VerticalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                pjSettings.compress = PrintImageSettings.CompressMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE_THRESHOLD -> {
                pjSettings.halftoneThreshold = message.toString().safeToInt()
            }
            PrintSettingsItemType.NUM_COPIES -> {
                pjSettings.numCopies = message.toString().safeToInt()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                pjSettings.isSkipStatusCheck = message == "ON"
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                pjSettings.printQuality = PrintImageSettings.PrintQuality.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                pjSettings.isTrimTrailingBlankData = message == "ON"
            }
            PrintSettingsItemType.PAPER_TYPE -> {
                pjSettings.paperType = PJPrintSettings.PaperType.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.PAPER_INSERTION_POSITION -> {
                pjSettings.paperInsertionPosition = PJPrintSettings.PaperInsertionPosition.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.FEED_MODE -> {
                pjSettings.feedMode = PJPrintSettings.FeedMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.EXTRA_FEED_DOTS -> {
                pjSettings.extraFeedDots = message.toString().safeToInt()
            }
            PrintSettingsItemType.DENSITY -> {
                pjSettings.density = PJPrintSettings.Density.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROLL_CASE -> {
                pjSettings.rollCase = PJPrintSettings.RollCase.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.PRINT_SPEED -> {
                pjSettings.printSpeed = PJPrintSettings.PrintSpeed.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.USING_CARBON_COPY_PAPER -> {
                pjSettings.isUsingCarbonCopyPaper = message == "ON"
            }
            PrintSettingsItemType.PRINT_DASH_LINE -> {
                pjSettings.isPrintDashLine = message == "ON"
            }
            PrintSettingsItemType.FORCE_STRETCH_PRINTABLE_AREA -> {
                pjSettings.forceStretchPrintableArea = message.toString().safeToInt()
            }
            else -> {}
        }
    }
}

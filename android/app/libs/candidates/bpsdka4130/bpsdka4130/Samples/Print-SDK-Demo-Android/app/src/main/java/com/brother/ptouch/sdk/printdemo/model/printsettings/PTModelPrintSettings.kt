package com.brother.ptouch.sdk.printdemo.model.printsettings

import android.content.Context
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToFloat
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.*

class PTModelPrintSettings(val context: Context, override val printerModel: PrinterModel) : ISimplePrintSettings {
    private var ptSettings = PTPrintSettings(printerModel)
    override var settingsMap: MutableMap<PrintSettingsItemType, Any> = mutableMapOf()

    init {
        settingsMap[PrintSettingsItemType.PRINTER_MODEL] = printerModel.name
        settingsMap[PrintSettingsItemType.SCALE_MODE] = ptSettings.scaleMode.name
        settingsMap[PrintSettingsItemType.SCALE_VALUE] = ptSettings.scaleValue.toString()
        settingsMap[PrintSettingsItemType.ORIENTATION] = ptSettings.printOrientation.name
        settingsMap[PrintSettingsItemType.ROTATION] = ptSettings.imageRotation.name
        settingsMap[PrintSettingsItemType.HALFTONE] = ptSettings.halftone.name
        settingsMap[PrintSettingsItemType.HORIZONTAL_ALIGNMENT] = ptSettings.hAlignment.name
        settingsMap[PrintSettingsItemType.VERTICAL_ALIGNMENT] = ptSettings.vAlignment.name
        settingsMap[PrintSettingsItemType.COMPRESS_MODE] = ptSettings.compress.name
        settingsMap[PrintSettingsItemType.HALFTONE_THRESHOLD] = ptSettings.halftoneThreshold.toString()
        settingsMap[PrintSettingsItemType.NUM_COPIES] = ptSettings.numCopies.toString()
        settingsMap[PrintSettingsItemType.SKIP_STATUS_CHECK] = if (ptSettings.isSkipStatusCheck) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.PRINT_QUALITY] = ptSettings.printQuality.name
        settingsMap[PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA] = if (ptSettings.isTrimTrailingBlankData) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.WORK_PATH] = ptSettings.workPath ?: ""
        settingsMap[PrintSettingsItemType.LABEL_SIZE] = ptSettings.labelSize.name
        settingsMap[PrintSettingsItemType.CUTMARK_PRINT] = if (ptSettings.isCutmarkPrint) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.CUT_PAUSE] = if (ptSettings.isCutPause) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.AUTO_CUT] = if (ptSettings.isAutoCut) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.HALF_CUT] = if (ptSettings.isHalfCut) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.CHAIN_PRINT] = if (ptSettings.isChainPrint) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.SPECIAL_TAPE_PRINT] = if (ptSettings.isSpecialTapePrint) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.RESOLUTION] = ptSettings.resolution.name
        settingsMap[PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT] = ptSettings.autoCutForEachPageCount.toString()
        settingsMap[PrintSettingsItemType.FORCE_VANISHING_MARGIN] = if (ptSettings.isForceVanishingMargin) "ON" else "OFF"
        settingsMap[PrintSettingsItemType.FEED_DIRECTION_MARGINS] = ptSettings.feedDirectionMargins.toString()
    }

    override fun validateSettings(callback: (ValidatePrintSettingsReport) -> Unit) {
        super.validateSettings(callback)
        val report = ValidatePrintSettings.validate(ptSettings)
        callback(report)
    }

    override fun getSettingItemList(key: PrintSettingsItemType): Array<String> {
        var itemList: Array<String> = arrayOf()
        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                itemList = arrayOf(context.getString(R.string.in_app_folder), context.getString(R.string.external_folder))
            }
            PrintSettingsItemType.RESOLUTION -> {
                itemList = PrintImageSettings.Resolution.values().map { it.name }.toTypedArray()
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
            PrintSettingsItemType.LABEL_SIZE -> {
                itemList = PTPrintSettings.LabelSize.values().map { it.name }.toTypedArray()
            }
            PrintSettingsItemType.CUTMARK_PRINT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.CUT_PAUSE -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.AUTO_CUT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.HALF_CUT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.CHAIN_PRINT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.SPECIAL_TAPE_PRINT -> {
                itemList = arrayOf("ON", "OFF")
            }
            PrintSettingsItemType.FORCE_VANISHING_MARGIN -> {
                itemList = arrayOf("ON", "OFF")
            }
            else -> {}
        }
        return itemList
    }

    override fun setSettingInfo(key: PrintSettingsItemType, message: Any) {

        when (key) {
            PrintSettingsItemType.WORK_PATH -> {
                ptSettings.workPath = if (message == context.getString(R.string.in_app_folder))
                    StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
            }
            PrintSettingsItemType.RESOLUTION -> {
                ptSettings.resolution = PrintImageSettings.Resolution.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.SCALE_MODE -> {
                ptSettings.scaleMode = PrintImageSettings.ScaleMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.SCALE_VALUE -> {
                ptSettings.scaleValue = message.toString().safeToFloat()
            }
            PrintSettingsItemType.ORIENTATION -> {
                ptSettings.printOrientation = PrintImageSettings.Orientation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.ROTATION -> {
                ptSettings.imageRotation = PrintImageSettings.Rotation.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE -> {
                ptSettings.halftone = PrintImageSettings.Halftone.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT -> {
                ptSettings.hAlignment = PrintImageSettings.HorizontalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.VERTICAL_ALIGNMENT -> {
                ptSettings.vAlignment = PrintImageSettings.VerticalAlignment.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.COMPRESS_MODE -> {
                ptSettings.compress = PrintImageSettings.CompressMode.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.HALFTONE_THRESHOLD -> {
                ptSettings.halftoneThreshold = message.toString().safeToInt()
            }
            PrintSettingsItemType.NUM_COPIES -> {
                ptSettings.numCopies = message.toString().safeToInt()
            }
            PrintSettingsItemType.SKIP_STATUS_CHECK -> {
                ptSettings.isSkipStatusCheck = message == "ON"
            }
            PrintSettingsItemType.PRINT_QUALITY -> {
                ptSettings.printQuality = PrintImageSettings.PrintQuality.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA -> {
                ptSettings.isTrimTrailingBlankData = message == "ON"
            }
            PrintSettingsItemType.LABEL_SIZE -> {
                ptSettings.labelSize = PTPrintSettings.LabelSize.values().firstOrNull { value -> value.name == message }
            }
            PrintSettingsItemType.CUTMARK_PRINT -> {
                ptSettings.isCutmarkPrint = message == "ON"
            }
            PrintSettingsItemType.CUT_PAUSE -> {
                ptSettings.isCutPause = message == "ON"
            }
            PrintSettingsItemType.AUTO_CUT -> {
                ptSettings.isAutoCut = message == "ON"
            }
            PrintSettingsItemType.HALF_CUT -> {
                ptSettings.isHalfCut = message == "ON"
            }
            PrintSettingsItemType.CHAIN_PRINT -> {
                ptSettings.isChainPrint = message == "ON"
            }
            PrintSettingsItemType.SPECIAL_TAPE_PRINT -> {
                ptSettings.isSpecialTapePrint = message == "ON"
            }
            PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT -> {
                ptSettings.autoCutForEachPageCount = message.toString().safeToInt()
            }
            PrintSettingsItemType.FORCE_VANISHING_MARGIN -> {
                ptSettings.isForceVanishingMargin = message == "ON"
            }
            PrintSettingsItemType.FEED_DIRECTION_MARGINS -> {
                ptSettings.feedDirectionMargins = message.toString().safeToInt()
            }
            else -> {}
        }
    }

    override fun getPrintSettings(): PrintSettings {
        return ptSettings
    }
}

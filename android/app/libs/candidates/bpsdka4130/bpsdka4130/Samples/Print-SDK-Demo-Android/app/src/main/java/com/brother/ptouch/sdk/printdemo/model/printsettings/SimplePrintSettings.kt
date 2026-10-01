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
    AUTO_CUT(R.string.auto_cut),
    AUTO_CUT_FOR_EACH_PAGE_COUNT(R.string.auto_cut_for_each_page_count),
    BI_COLOR_BLUE_ENHANCEMENT(R.string.bi_color_blue_enhancement),
    BI_COLOR_GREEN_ENHANCEMENT(R.string.bi_color_green_enhancement),
    BI_COLOR_RED_ENHANCEMENT(R.string.bi_color_red_enhancement),
    CHAIN_PRINT(R.string.chain_print),
    CHANNEL_TYPE(R.string.channel_type),
    COMPRESS_MODE(R.string.compress_mode),
    CUSTOM_PAPER_SIZE(R.string.custom_paper_size),
    CUSTOM_RECORD(R.string.custom_record),
    CUTMARK_PRINT(R.string.cutmark_print),
    CUT_AT_END(R.string.cut_at_end),
    CUT_PAUSE(R.string.cut_pause),
    DENSITY(R.string.density),
    EXTRA_FEED_DOTS(R.string.extra_feed_dots),
    FEED_DIRECTION_MARGINS(R.string.feed_direction_margins),
    FEED_MODE(R.string.feed_mode),
    FORCE_STRETCH_PRINTABLE_AREA(R.string.force_stretch_printable_area),
    FORCE_VANISHING_MARGIN(R.string.force_vanishing_margin),
    HALFTONE(R.string.halftone),
    HALFTONE_THRESHOLD(R.string.halftone_threshold),
    HALF_CUT(R.string.half_cut),
    HORIZONTAL_ALIGNMENT(R.string.horizontal_alignment),
    LABEL_SIZE(R.string.label_size),
    MIRROR_PRINT(R.string.mirror_print),
    NUM_COPIES(R.string.num_copies),
    ORIENTATION(R.string.orientation),
    PAPER_INSERTION_POSITION(R.string.paper_insertion_position),
    PAPER_SIZE(R.string.paper_size),
    PAPER_TYPE(R.string.paper_type),
    PEEL_LABEL(R.string.peel_label),
    PRINTER_MODEL(R.string.printer_model),
    PRINT_DASH_LINE(R.string.print_dash_line),
    PRINT_QUALITY(R.string.print_quality),
    PRINT_SPEED(R.string.print_speed),
    RESOLUTION(R.string.resolution),
    ROLL_CASE(R.string.roll_case),
    ROTATE180DEGREES(R.string.rotate180degrees),
    ROTATION(R.string.rotation),
    SCALE_MODE(R.string.scale_mode),
    SCALE_VALUE(R.string.scale_value),
    SKIP_STATUS_CHECK(R.string.skip_status_check),
    SPECIAL_TAPE_PRINT(R.string.special_tape_print),
    TRIM_TRAILING_BLANK_DATA(R.string.trim_trailing_blank_data),
    USING_CARBON_COPY_PAPER(R.string.using_carbon_copy_paper),
    VERTICAL_ALIGNMENT(R.string.vertical_alignment),
    WORK_PATH(R.string.work_path),
}

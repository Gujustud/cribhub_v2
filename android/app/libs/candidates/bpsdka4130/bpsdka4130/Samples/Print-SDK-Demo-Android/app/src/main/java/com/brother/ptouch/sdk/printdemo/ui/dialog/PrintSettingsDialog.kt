package com.brother.ptouch.sdk.printdemo.ui.dialog

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.core.view.isVisible
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToFloat
import com.brother.ptouch.sdk.printdemo.model.StringUtils.safeToInt
import com.brother.sdk.lmprinter.setting.CustomPaperSize
import com.brother.sdk.lmprinter.setting.CustomPaperSize.*
import com.brother.sdk.lmprinter.setting.PJCustomPaperSize
import com.brother.sdk.lmprinter.setting.PJPaperSize
import com.brother.sdk.lmprinter.setting.PJPaperSize.PaperSize
import com.brother.sdk.lmprinter.setting.PJPaperSize.newCustomPaper
import com.google.android.material.textfield.TextInputEditText

object PrintSettingsDialog {

    fun showDialog(
        context: Context,
        type: SettingDialogType,
        title: String,
        message: String = "",
        itemList: Array<String> = arrayOf(),
        positiveDidTap: (String) -> Unit
    ) {
        when (type) {
            SettingDialogType.Edit -> {
                CommonDialog.showNumberEditDialog(context, title, message) {
                    positiveDidTap(it)
                }
            }
            SettingDialogType.SingleSelect -> {
                CommonDialog.showSingleSelectDialog(context, title, itemList) {
                    positiveDidTap(it)
                }
            }
            SettingDialogType.PJPaperSize -> {}
            SettingDialogType.RJAndTDPaperSize -> {}
        }
    }

    fun showPJPaperSizeDialog(
        context: Context,
        title: String,
        message: String,
        paperSize: PJPaperSize,
        positiveDidTap: (PJPaperSize) -> Unit
    ) {
        val inflater = LayoutInflater.from(context)
        val dialogLayout = inflater.inflate(R.layout.dialog_custom_paper_size, null)
        val layout = dialogLayout.findViewById<LinearLayout>(R.id.custom_paper_size_layout)
        val positiveButton = dialogLayout.findViewById<Button>(R.id.dialog_ok_btn)
        val widthDotsEditText = layout.findViewById<TextInputEditText>(R.id.text_input_width_dots)
        val lengthDotsEditText = layout.findViewById<TextInputEditText>(R.id.text_input_length_dots)
        var tempPJCustomPaperSize = paperSize.customPaperSize
        if (tempPJCustomPaperSize == null) {
            tempPJCustomPaperSize = newCustomPaper(PJCustomPaperSize(2400, 3300)).customPaperSize
        }
        widthDotsEditText.setText(tempPJCustomPaperSize.widthDots.toString())
        lengthDotsEditText.setText(tempPJCustomPaperSize.lengthDots.toString())
        val itemList = PaperSize.values().map { it.name }.toTypedArray()
        var selectPosition = itemList.indexOfFirst { it == message }
        layout.isVisible = selectPosition == itemList.indexOfFirst { it == PaperSize.Custom.name }
        val builder = AlertDialog.Builder(context, R.style.AppTheme_NoActionbar_Main)
            .setTitle(title)
            .setSingleChoiceItems(itemList, selectPosition) { _, which ->
                layout.isVisible = which == itemList.indexOfFirst { it == PaperSize.Custom.name }
                selectPosition = which
            }
            .setView(dialogLayout)
            .create()
        builder.show()
        positiveButton.setOnClickListener {
            if (layout.isVisible) {
                val pjPaperSize = PJPaperSize.newCustomPaper(
                    PJCustomPaperSize(
                        widthDotsEditText.text?.toString()?.safeToInt() ?: 0,
                        lengthDotsEditText.text?.toString()?.safeToInt() ?: 0
                    )
                )
                positiveDidTap(pjPaperSize)
            } else {
                val pjPaperSize = PJPaperSize.newPaperSize(PaperSize.values().firstOrNull { it.name == itemList[selectPosition] })
                positiveDidTap(pjPaperSize)
            }
            builder.dismiss()
        }
    }

    fun showTDOrRJPaperSizeDialog(
        context: Context,
        title: String,
        message: String,
        paperSize: CustomPaperSize,
        positiveDidTap: (CustomPaperSize) -> Unit,
        filePathDidTap: ((String) -> Unit) -> Unit
    ) {
        val inflater = LayoutInflater.from(context)
        val dialogLayout = inflater.inflate(R.layout.dialog_custom_paper_size, null)
        val tapWidthLayout = dialogLayout.findViewById<LinearLayout>(R.id.tape_width_layout)
        val tapLengthLayout = dialogLayout.findViewById<LinearLayout>(R.id.tape_length_layout)
        val marginsLayout = dialogLayout.findViewById<LinearLayout>(R.id.margins_layout)
        val gapLengthLayout = dialogLayout.findViewById<LinearLayout>(R.id.gap_length_layout)
        val markVerticalOffsetLayout = dialogLayout.findViewById<LinearLayout>(R.id.mark_vertical_offset_layout)
        val markLengthLayout = dialogLayout.findViewById<LinearLayout>(R.id.mark_length_layout)
        val unitLayout = dialogLayout.findViewById<LinearLayout>(R.id.unit_layout)
        val filePathLayout = dialogLayout.findViewById<LinearLayout>(R.id.file_path_layout)
        val energyRankLayout = dialogLayout.findViewById<LinearLayout>(R.id.energy_rank_layout)
        val positiveButton = dialogLayout.findViewById<Button>(R.id.dialog_ok_btn)

        val tapWidthEditText = tapWidthLayout.findViewById<TextInputEditText>(R.id.text_input_tape_width)
        val tapLengthEditText = tapLengthLayout.findViewById<TextInputEditText>(R.id.text_input_tape_length)
        val marginTopEditText = marginsLayout.findViewById<TextInputEditText>(R.id.text_input_margin_top)
        val marginLeftEditText = marginsLayout.findViewById<TextInputEditText>(R.id.text_input_margin_left)
        val marginBottomEditText = marginsLayout.findViewById<TextInputEditText>(R.id.text_input_margin_bottom)
        val marginRightEditText = marginsLayout.findViewById<TextInputEditText>(R.id.text_input_margin_right)
        val gapLengthEditText = gapLengthLayout.findViewById<TextInputEditText>(R.id.text_input_gap_length)
        val markVerticalOffsetEditText = markVerticalOffsetLayout.findViewById<TextInputEditText>(R.id.text_input_mark_vertical_offset)
        val markLengthEditText = markLengthLayout.findViewById<TextInputEditText>(R.id.text_input_mark_length)
        val unitSpinner = unitLayout.findViewById<Spinner>(R.id.unit_spinner)
        val filePathTextView = filePathLayout.findViewById<TextView>(R.id.text_view_file_path)
        val energyRankEditText = energyRankLayout.findViewById<TextInputEditText>(R.id.text_input_energy_rank)
        val energyRankDefaultCheckBox = energyRankLayout.findViewById<CheckBox>(R.id.checkbox_energy_rank_unspecified)

        tapWidthEditText.setText(paperSize.width.toString())
        tapLengthEditText.setText(paperSize.length.toString())
        marginTopEditText.setText(paperSize.margins.top.toString())
        marginLeftEditText.setText(paperSize.margins.left.toString())
        marginBottomEditText.setText(paperSize.margins.bottom.toString())
        marginRightEditText.setText(paperSize.margins.right.toString())
        gapLengthEditText.setText(paperSize.gapLength.toString())
        markVerticalOffsetEditText.setText(paperSize.markVerticalOffset.toString())
        markLengthEditText.setText(paperSize.markLength.toString())
        energyRankEditText.setText(if (paperSize.energyRank == null) "" else paperSize.energyRank.toString())
        energyRankEditText.isVisible = (paperSize.energyRank != null)
        energyRankDefaultCheckBox.isChecked = (paperSize.energyRank == null)
        paperSize.paperBinFilePath?.let {
            filePathTextView.text = it
        }

        val adapter = ArrayAdapter(
            context,
            androidx.appcompat.R.layout.support_simple_spinner_dropdown_item,
            CustomPaperSize.Unit.values().map { it.name }
        )
        unitSpinner.adapter = adapter
        var index = CustomPaperSize.Unit.values().indexOf(paperSize.unit)
        unitSpinner.setSelection(index)
        unitSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                if (index == position) return
                index = position
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
            }
        }

        val itemList = PaperKind.values().map { it.name }.toTypedArray()
        var selectPosition = itemList.indexOfFirst { it == message }

        fun refreshView(paperKind: PaperKind) {
            tapWidthLayout.isVisible = paperKind != PaperKind.ByFile
            marginsLayout.isVisible = paperKind != PaperKind.ByFile
            unitLayout.isVisible = paperKind != PaperKind.ByFile
            filePathLayout.isVisible = paperKind == PaperKind.ByFile
            tapLengthLayout.isVisible = (paperKind != PaperKind.ByFile && paperKind != PaperKind.Roll)
            gapLengthLayout.isVisible = paperKind == PaperKind.DieCut
            markLengthLayout.isVisible = paperKind == PaperKind.MarkRoll
            markVerticalOffsetLayout.isVisible = paperKind == PaperKind.MarkRoll
            energyRankLayout.isVisible = paperKind != PaperKind.ByFile
        }

        refreshView(paperSize.paperKind)
        val builder = AlertDialog.Builder(context)
            .setTitle(title)
            .setSingleChoiceItems(itemList, selectPosition) { _, which ->
                refreshView(PaperKind.values()[which])
                selectPosition = which
            }
            .setView(dialogLayout)
            .create()
        builder.show()

        energyRankDefaultCheckBox.setOnCheckedChangeListener{ _, isChecked ->
            energyRankEditText.isVisible = !isChecked
        }

        filePathLayout.setOnClickListener {
            filePathDidTap {
                filePathTextView.text = it
            }
        }

        positiveButton.setOnClickListener {
            when (PaperKind.values()[selectPosition]) {
                PaperKind.Roll -> {
                    positiveDidTap(
                        if (energyRankDefaultCheckBox.isChecked) {
                            newRollPaperSize(
                                tapWidthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                Margins(
                                    marginTopEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginLeftEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginBottomEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginRightEditText.text?.toString()?.safeToFloat() ?: 0f
                                ),
                                CustomPaperSize.Unit.values()[index]
                            )
                        } else {
                            newRollPaperSize(
                                tapWidthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                Margins(
                                    marginTopEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginLeftEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginBottomEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginRightEditText.text?.toString()?.safeToFloat() ?: 0f
                                ),
                                CustomPaperSize.Unit.values()[index],
                                energyRankEditText.text?.toString()?.safeToInt() ?: 0
                            )
                        }
                    )
                }
                PaperKind.DieCut -> {
                    positiveDidTap(
                        if (energyRankDefaultCheckBox.isChecked) {
                            newDieCutPaperSize(
                                tapWidthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                tapLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                Margins(
                                    marginTopEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginLeftEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginBottomEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginRightEditText.text?.toString()?.safeToFloat() ?: 0f
                                ),
                                gapLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                CustomPaperSize.Unit.values()[index]
                            )
                        } else {
                            newDieCutPaperSize(
                                tapWidthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                tapLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                Margins(
                                    marginTopEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginLeftEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginBottomEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginRightEditText.text?.toString()?.safeToFloat() ?: 0f
                                ),
                                gapLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                CustomPaperSize.Unit.values()[index],
                                energyRankEditText.text?.toString()?.safeToInt() ?: 0
                            )
                        }
                    )
                }
                PaperKind.MarkRoll -> {
                    positiveDidTap(
                        if (energyRankDefaultCheckBox.isChecked) {
                            newMarkRollPaperSize(
                                tapWidthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                tapLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                Margins(
                                    marginTopEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginLeftEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginBottomEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginRightEditText.text?.toString()?.safeToFloat() ?: 0f
                                ),
                                markVerticalOffsetEditText.text?.toString()?.safeToFloat() ?: 0f,
                                markLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                CustomPaperSize.Unit.values()[index]
                            )
                        } else {
                            newMarkRollPaperSize(
                                tapWidthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                tapLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                Margins(
                                    marginTopEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginLeftEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginBottomEditText.text?.toString()?.safeToFloat() ?: 0f,
                                    marginRightEditText.text?.toString()?.safeToFloat() ?: 0f
                                ),
                                markVerticalOffsetEditText.text?.toString()?.safeToFloat() ?: 0f,
                                markLengthEditText.text?.toString()?.safeToFloat() ?: 0f,
                                CustomPaperSize.Unit.values()[index],
                                energyRankEditText.text?.toString()?.safeToInt() ?: 0
                            )
                        }
                    )
                }
                PaperKind.ByFile -> {
                    positiveDidTap(newFile(filePathTextView.text.toString()))
                }
            }
            builder.dismiss()
        }
    }
}

enum class SettingDialogType {
    Edit,
    SingleSelect,
    PJPaperSize,
    RJAndTDPaperSize
}

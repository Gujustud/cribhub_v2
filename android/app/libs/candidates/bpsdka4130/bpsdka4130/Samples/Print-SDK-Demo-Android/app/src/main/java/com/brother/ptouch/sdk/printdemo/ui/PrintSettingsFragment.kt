package com.brother.ptouch.sdk.printdemo.ui

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentPrintSettingsBinding
import com.brother.ptouch.sdk.printdemo.model.IPrintData
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.ptouch.sdk.printdemo.model.printsettings.PJModelPrintSettings
import com.brother.ptouch.sdk.printdemo.model.printsettings.PrintSettingsItemType
import com.brother.ptouch.sdk.printdemo.model.printsettings.RJModelPrintSettings
import com.brother.ptouch.sdk.printdemo.model.printsettings.TDModelPrintSettings
import com.brother.ptouch.sdk.printdemo.ui.adapters.TitleWithMessageRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.ui.components.RecyclerViewDivider
import com.brother.ptouch.sdk.printdemo.ui.components.ShowResultFragment
import com.brother.ptouch.sdk.printdemo.ui.dialog.CommonDialog
import com.brother.ptouch.sdk.printdemo.ui.dialog.PrintSettingsDialog
import com.brother.ptouch.sdk.printdemo.ui.dialog.SettingDialogType
import com.brother.ptouch.sdk.printdemo.viewmodel.PrintSettingsViewModel
import com.brother.sdk.lmprinter.setting.CustomPaperSize

class PrintSettingsFragment : Fragment() {
    companion object {
        const val KeyDstFragmentId = "src_fragment_id"
        const val KeyIsShowPrintBtn = "is_show_print_btn"
        const val KeyPrintData = "print_data_key"
        const val KeyPrinterModelName = "printer_model_name"
        const val CustomRecordMaxInputLength = 64
        private val FileMimeTypes = arrayOf("application/octet-stream")
    }

    private lateinit var viewModel: PrintSettingsViewModel
    private lateinit var binding: FragmentPrintSettingsBinding
    private val dialogManager = PrintSettingsDialog

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_print_settings, null, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    @Suppress("DEPRECATION")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[PrintSettingsViewModel::class.java]
        viewModel.printerInfo = PrintDemoApp.instance.currentSelectedPrinter

        viewModel.data = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            arguments?.getParcelable(KeyPrintData, IPrintData::class.java)
        else
            arguments?.getParcelable(KeyPrintData)

        arguments?.getString(KeyPrinterModelName)?.let {
            viewModel.printerModelName = it
        }

        setupViews()
        setupViewEvents()
    }

    private fun setupViews() {
        val context = this.context ?: return

        binding.printSettingsMenuRecycler.layoutManager = LinearLayoutManager(context)
        binding.printSettingsMenuRecycler.addItemDecoration(RecyclerViewDivider())
        if (viewModel.getOptionsInfoList(context).isEmpty()) {
            binding.layoutPrintSettingsList.isVisible = false
            binding.layoutEmptyPage.isVisible = true
        }
        binding.printSettingsMenuRecycler.adapter = TitleWithMessageRecyclerAdapter(context, viewModel.getOptionsInfoList(
            context
        ), { key, message ->
            showSettingDialog(key, message)
        })
        arguments?.getBoolean(KeyIsShowPrintBtn)?.let {
            binding.toolbar.menu?.findItem(R.id.nextView_print)?.isVisible = it
        }
    }

    private fun showSettingDialog(key: PrintSettingsItemType, message: Any) {
        val context = this.context ?: return
        when (key) {
            PrintSettingsItemType.HALFTONE_THRESHOLD, PrintSettingsItemType.SCALE_VALUE,
            PrintSettingsItemType.NUM_COPIES, PrintSettingsItemType.EXTRA_FEED_DOTS,
            PrintSettingsItemType.FORCE_STRETCH_PRINTABLE_AREA, PrintSettingsItemType.AUTO_CUT_FOR_EACH_PAGE_COUNT,
            PrintSettingsItemType.FEED_DIRECTION_MARGINS,
            PrintSettingsItemType.BI_COLOR_RED_ENHANCEMENT, PrintSettingsItemType.BI_COLOR_GREEN_ENHANCEMENT,
            PrintSettingsItemType.BI_COLOR_BLUE_ENHANCEMENT -> {
                PrintSettingsDialog.showDialog(
                    context,
                    SettingDialogType.Edit,
                    context.getString(key.stringId),
                    message.toString()
                ) { value ->
                    viewModel.setSettingsMap(key, value)
                    binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                }
            }
            PrintSettingsItemType.CUSTOM_RECORD -> {
                CommonDialog.showEditDialog(
                    context,
                    context.getString(key.stringId),
                    message.toString(),
                    CustomRecordMaxInputLength
                ) { value ->
                    viewModel.setSettingsMap(key, value)
                    binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                }
            }
            PrintSettingsItemType.LABEL_SIZE,
            PrintSettingsItemType.CUTMARK_PRINT,
            PrintSettingsItemType.CUT_PAUSE,
            PrintSettingsItemType.AUTO_CUT,
            PrintSettingsItemType.HALF_CUT,
            PrintSettingsItemType.CHAIN_PRINT,
            PrintSettingsItemType.SPECIAL_TAPE_PRINT,
            PrintSettingsItemType.RESOLUTION,
            PrintSettingsItemType.FORCE_VANISHING_MARGIN,
            PrintSettingsItemType.SCALE_MODE,
            PrintSettingsItemType.ORIENTATION,
            PrintSettingsItemType.HALFTONE,
            PrintSettingsItemType.HORIZONTAL_ALIGNMENT,
            PrintSettingsItemType.VERTICAL_ALIGNMENT,
            PrintSettingsItemType.COMPRESS_MODE,
            PrintSettingsItemType.SKIP_STATUS_CHECK,
            PrintSettingsItemType.PRINT_QUALITY,
            PrintSettingsItemType.CUT_AT_END,
            PrintSettingsItemType.PAPER_TYPE,
            PrintSettingsItemType.PAPER_INSERTION_POSITION,
            PrintSettingsItemType.FEED_MODE,
            PrintSettingsItemType.DENSITY,
            PrintSettingsItemType.ROLL_CASE,
            PrintSettingsItemType.PRINT_SPEED,
            PrintSettingsItemType.USING_CARBON_COPY_PAPER,
            PrintSettingsItemType.PRINT_DASH_LINE,
            PrintSettingsItemType.PEEL_LABEL,
            PrintSettingsItemType.WORK_PATH,
            PrintSettingsItemType.ROTATE180DEGREES,
            PrintSettingsItemType.MIRROR_PRINT,
            PrintSettingsItemType.TRIM_TRAILING_BLANK_DATA,
            PrintSettingsItemType.ROTATION -> {
                PrintSettingsDialog.showDialog(
                    context, SettingDialogType.SingleSelect,
                    context.getString(key.stringId),
                    itemList = viewModel.getSettingItemList(key)
                ) { value ->
                    if (key == PrintSettingsItemType.WORK_PATH) {
                        viewModel.setSettingsMap(
                            key,
                            if (value == context.getString(R.string.in_app_folder))
                                StorageUtils.getInternalFolder(context) else StorageUtils.getExternalFolder(context)
                        )
                    } else {
                        viewModel.setSettingsMap(key, value)
                    }
                    binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                }
            }
            PrintSettingsItemType.PAPER_SIZE -> {
                if (viewModel.printSettings is PJModelPrintSettings) {
                    (viewModel.printSettings as PJModelPrintSettings).getPaperSize()?.let {
                        PrintSettingsDialog.showPJPaperSizeDialog(
                            context,
                            context.getString(key.stringId),
                            message.toString(),
                            it
                        ) { value ->
                            viewModel.setSettingsMap(key, value)
                            binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                        }
                    }
                } else {
                    PrintSettingsDialog.showDialog(
                        context, SettingDialogType.SingleSelect,
                        context.getString(key.stringId),
                        itemList = viewModel.getSettingItemList(key)
                    ) { value ->
                        viewModel.setSettingsMap(key, value)
                        binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                    }
                }
            }
            PrintSettingsItemType.CUSTOM_PAPER_SIZE -> {
                var paperSize: CustomPaperSize? = null
                if (viewModel.printSettings is RJModelPrintSettings) {
                    paperSize = (viewModel.printSettings as RJModelPrintSettings).getCustomPaperSize()
                } else if (viewModel.printSettings is TDModelPrintSettings) {
                    paperSize = (viewModel.printSettings as TDModelPrintSettings).getCustomPaperSize()
                }
                paperSize?.let {
                    dialogManager.showTDOrRJPaperSizeDialog(
                        context,
                        context.getString(key.stringId),
                        message.toString(),
                        it,
                        positiveDidTap = { value ->
                            viewModel.setSettingsMap(key, value)
                            binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                        },
                        filePathDidTap = {
                            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                                addCategory(Intent.CATEGORY_OPENABLE)
                                type = "*/*"
                                putExtra(Intent.EXTRA_MIME_TYPES, FileMimeTypes)
                                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, false)
                            }
                            filePathCallback = it
                            launcher.launch(intent)
                        }
                    )
                }
            }
            PrintSettingsItemType.PRINTER_MODEL,
            PrintSettingsItemType.CHANNEL_TYPE -> return
        }
    }

    private fun setupViewEvents() {
        binding.toolbar.menu.findItem(R.id.nextView_print)?.setOnMenuItemClickListener {
            val context = context ?: return@setOnMenuItemClickListener true
            val cancelDialog = CommonDialog.cancelingDialog(context)
            val dialog = CommonDialog.waitingDialog(context, context.getString(R.string.print_message)) {
                cancelDialog.show()
                viewModel.cancelPrint()
            }
            dialog.show()
            viewModel.startToPrint(context) {
                dialog.dismiss()
                cancelDialog.dismiss()
                findNavController().navigate(PrintImageFragmentDirections.toShowResult().apply {
                    arguments.putString(ShowResultFragment.KeyPrintResult, it)
                })
            }
            return@setOnMenuItemClickListener true
        }

        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }

        binding.validate.setOnClickListener {
            viewModel.validateSettingsInfo { report ->
                findNavController().navigate(PrintSettingsFragmentDirections.toShowResult().apply {
                    arguments.putString(ShowResultFragment.KeyPrintResult, report)
                })
            }
        }
    }

    private var filePathCallback: ((String) -> Unit)? = null

    private val launcher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
        if (it.resultCode != AppCompatActivity.RESULT_OK) {
            return@registerForActivityResult
        }
        val context = context ?: return@registerForActivityResult
        it.data?.data?.let { uri ->
            if (viewModel.isSupportFile(context, uri)) {
                val path = StorageUtils.getSelectFileUri(context, uri) ?: return@registerForActivityResult
                filePathCallback?.invoke(path)
            }
        }
    }
}

package com.brother.ptouch.sdk.printdemo.ui

import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentTemplatePrintSettingsBinding
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.ptouch.sdk.printdemo.model.TemplatePrintData
import com.brother.ptouch.sdk.printdemo.model.printsettings.PrintSettingsItemType
import com.brother.ptouch.sdk.printdemo.ui.adapters.TitleWithMessageRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.ui.components.RecyclerViewDivider
import com.brother.ptouch.sdk.printdemo.ui.dialog.PrintSettingsDialog
import com.brother.ptouch.sdk.printdemo.ui.dialog.SettingDialogType
import com.brother.ptouch.sdk.printdemo.viewmodel.TemplatePrintSettingsViewModel

class TemplatePrintSettingsFragment : Fragment() {
    private lateinit var viewModel: TemplatePrintSettingsViewModel
    private lateinit var binding: FragmentTemplatePrintSettingsBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_template_print_settings, null, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[TemplatePrintSettingsViewModel::class.java]
        @Suppress("DEPRECATION")
        viewModel.data = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            arguments?.getParcelable(EditTemplateFragment.KeyPrintData, TemplatePrintData::class.java)
        else
            arguments?.getParcelable(EditTemplateFragment.KeyPrintData)

        setupViews()
        setupViewEvents()
    }

    private fun setupViews() {
        val context = this.context ?: return

        binding.printSettingsMenuRecycler.layoutManager = LinearLayoutManager(context)
        binding.printSettingsMenuRecycler.addItemDecoration(RecyclerViewDivider())
        if (viewModel.getOptionsInfoList().isEmpty()) {
            binding.layoutPrintSettingsList.isVisible = false
            binding.layoutEmptyPage.isVisible = true
        }
        binding.printSettingsMenuRecycler.adapter = TitleWithMessageRecyclerAdapter(context, viewModel.getOptionsInfoList(), { key, message ->
            showSettingDialog(key, message)
        })

        binding.toolbar.menu?.findItem(R.id.nextView_print)?.isVisible = true
    }


    private fun showSettingDialog(key: PrintSettingsItemType, message: Any) {
        val context = this.context ?: return
        when (key) {
            PrintSettingsItemType.NUM_COPIES -> {
                PrintSettingsDialog.showDialog(
                        context,
                        SettingDialogType.Edit,
                        context.getString(key.stringId),
                        message.toString()
                ) { value ->
                    viewModel.setSettingsMap(key, value)
                    setupViews()
                    binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                }
            }
            PrintSettingsItemType.PEEL_LABEL -> {
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
                    setupViews()
                    binding.printSettingsMenuRecycler.adapter?.notifyDataSetChanged()
                }
            }
            else -> {}
        }
    }

    private fun setupViewEvents() {
        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }

        binding.toolbar.menu.findItem(R.id.next_menu)?.setOnMenuItemClickListener {
            findNavController().navigate(TemplatePrintSettingsFragmentDirections.toEditTemplateFragment().apply {
                arguments.putParcelable(EditTemplateFragment.KeyPrintData, viewModel.data)
            })
            return@setOnMenuItemClickListener true
        }

    }
}

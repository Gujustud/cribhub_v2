package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.ui.components.ShowResultFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.SelectPrinterViewModel
import com.brother.sdk.lmprinter.PrinterModel

class SelectPrinterFragment : Fragment() {
    companion object {
        const val KeyIsModelSpec = "is_model_spec"
    }

    private lateinit var viewModel: SelectPrinterViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[SelectPrinterViewModel::class.java]
        setupView()
        setupEvents()
    }

    private fun setupView() {
        viewModel.isModelSpec = arguments?.getBoolean(KeyIsModelSpec)
        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.printer)
            putStringArrayList(SelectorFragment.KeyMenuList, ArrayList(viewModel.getPrinterModelNameList()))
        }

        val fragment = SelectorFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val context = this.context ?: return
        val isModelSpec = viewModel.isModelSpec
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.getLiveData<String>(SelectorFragment.KeySelectedMenu)?.observe(viewLifecycleOwner) {
            handle.remove<String>(SelectorFragment.KeySelectedMenu)

            if (isModelSpec == true) {
                val printerModel = PrinterModel.values().firstOrNull { model -> model.name == it } ?: return@observe
                val modelSpec = viewModel.getModelSpec(context, printerModel)
                findNavController().navigate(SelectPrinterFragmentDirections.toShowResult().apply {
                    arguments.putString(ShowResultFragment.KeyPrintResult, modelSpec)
                })
            } else {
                findNavController().navigate(SelectPrinterFragmentDirections.toPrintSettings().apply {
                    arguments.putString(PrintSettingsFragment.KeyPrinterModelName, it)
                    arguments.putBoolean(PrintSettingsFragment.KeyIsShowPrintBtn, false)
                })
            }
        }
    }
}

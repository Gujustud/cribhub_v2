package com.brother.ptouch.sdk.printdemo.ui

import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.PdfPrintData
import com.brother.ptouch.sdk.printdemo.ui.components.InputIntListFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.InputPDFPageViewModel

class InputPDFPageFragment : Fragment() {
    private lateinit var viewModel: InputPDFPageViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    @Suppress("DEPRECATION")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[InputPDFPageViewModel::class.java]

        viewModel.data = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            arguments?.getParcelable(PrintSettingsFragment.KeyPrintData, PdfPrintData::class.java)
        else
            arguments?.getParcelable(PrintSettingsFragment.KeyPrintData)

        setupView()
        setupEvents()
    }

    private fun setupView() {
        val bundle = Bundle().apply {
            putInt(InputIntListFragment.KeyTitleId, R.string.print_pdf)
            putInt(InputIntListFragment.KeyMenuStringId, R.string.next)
            viewModel.data?.pages?.let {
                putString(InputIntListFragment.KeyInputIntListString, it.joinToString(";"))
            }
        }

        val fragment = InputIntListFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.getLiveData<ArrayList<Int>>(InputIntListFragment.KeyInputIntList)?.observe(viewLifecycleOwner) {
            handle.remove<ArrayList<Int>>(InputIntListFragment.KeyInputIntList)
            viewModel.data?.pages?.clear()
            viewModel.data?.pages?.addAll(it)

            val data = viewModel.data ?: return@observe
            val temp = PdfPrintData(data.type, data.pages, data.pdfData)
            findNavController().navigate(InputPDFPageFragmentDirections.toPrintSettings().apply {
                arguments.putParcelable(PrintSettingsFragment.KeyPrintData, temp)
                arguments.putBoolean(PrintSettingsFragment.KeyIsShowPrintBtn, true)
            })
        }
    }
}

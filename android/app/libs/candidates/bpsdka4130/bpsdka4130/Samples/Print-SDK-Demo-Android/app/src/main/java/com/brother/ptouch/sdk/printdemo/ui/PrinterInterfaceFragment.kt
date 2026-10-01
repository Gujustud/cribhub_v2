package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.PrinterInterfaceViewModel

class PrinterInterfaceFragment : Fragment() {
    private lateinit var viewModel: PrinterInterfaceViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[PrinterInterfaceViewModel::class.java]
        setupView()
        setupEvents()
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.select_printer_interface)
            putStringArrayList(SelectorFragment.KeyMenuList, ArrayList(viewModel.getPrinterTypeList(context)))
        }

        val fragment = SelectorFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.getLiveData<String>(SelectorFragment.KeySelectedMenu)?.observe(viewLifecycleOwner) {
            handle.remove<String>(SelectorFragment.KeySelectedMenu)

            findNavController().navigate(R.id.fragment_printer_list, Bundle().apply {
                this.putString(PrinterListFragment.KeyPrinterInterface, it)
            })
        }

        handle?.getLiveData<DiscoveredPrinterInfo>(PrinterListFragment.KeyPrinterInfo)?.observe(viewLifecycleOwner) {
            handle.remove<DiscoveredPrinterInfo>(PrinterListFragment.KeyPrinterInfo)

            findNavController().popBackStack()
            findNavController().currentBackStackEntry?.savedStateHandle?.set(PrinterListFragment.KeyPrinterInfo, it)
        }
    }
}

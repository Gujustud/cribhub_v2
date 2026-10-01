package com.brother.ptouch.sdk.printdemo.ui.components

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentListWithSearchBinding
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.ui.PrinterListFragment
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleCategoryButtonRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleData
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleStringRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.viewmodel.SelectorWithSearchViewModel

class SelectorWithSearchFragment : Fragment() {
    private lateinit var viewModel: SelectorWithSearchViewModel
    lateinit var binding: FragmentListWithSearchBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val context = this.context ?: return super.onCreateView(inflater, container, savedInstanceState)
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_list_with_search, null, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[SelectorWithSearchViewModel::class.java]
        binding.bean = viewModel.bean

        setupViews()
    }

    override fun onResume() {
        super.onResume()
        viewModel.currentPrinterInfo = PrintDemoApp.instance.currentSelectedPrinter
    }

    @Suppress("DEPRECATION")
    private fun setupViews() {
        val context = this.context ?: return

        arguments?.getInt(SelectorFragment.KeyTitleId)?.let {
            binding.toolbar.title = context.getString(it)
        }

        val stringItems = arguments?.getStringArrayList(SelectorFragment.KeyMenuList) ?: listOf<String>()
        val buttonItems = arguments?.getParcelableArrayList(SelectorFragment.KeyButtonMenuList) ?: listOf<SimpleData>()
        val itemGravity = arguments?.getInt(SelectorFragment.KeyItemGravity, Gravity.CENTER_HORIZONTAL) ?: Gravity.CENTER_HORIZONTAL

        // recycler view
        binding.baseRecyclerView.layoutManager = LinearLayoutManager(context)

        if (stringItems.isNotEmpty()) {
            binding.baseRecyclerView.addItemDecoration(RecyclerViewDivider())
            binding.baseRecyclerView.adapter = SimpleStringRecyclerAdapter(
                context,
                stringItems,
                onItemSelected = ::onItemSelected,
                itemGravity
            )
        } else {
            binding.baseRecyclerView.adapter =
                SimpleCategoryButtonRecyclerAdapter(context, buttonItems, onItemSelected = ::onButtonItemSelected)
        }

        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }

        binding.mainFindPrinter.setOnClickListener {
            findNavController().navigate(R.id.fragment_printer_interface)
        }

        binding.passwordInputButton.setOnClickListener {
            showPasswordInputDialog()
        }

        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.getLiveData<DiscoveredPrinterInfo>(PrinterListFragment.KeyPrinterInfo)?.observe(viewLifecycleOwner) {
            handle.remove<DiscoveredPrinterInfo>(PrinterListFragment.KeyPrinterInfo)

            PrintDemoApp.instance.currentSelectedPrinter = it
            viewModel.currentPrinterInfo = it
        }
    }

    private fun onItemSelected(info: String) {
        val controller = findNavController()
        with(controller) {
            currentBackStackEntry?.savedStateHandle?.set(SelectorFragment.KeySelectedMenu, info)
        }
    }

    private fun onButtonItemSelected(data: SimpleData) {
        val controller = findNavController()
        with(controller) {
            currentBackStackEntry?.savedStateHandle?.set(SelectorFragment.KeySelectedButtonMenu, data)
        }
    }

    @SuppressLint("SetTextI18n")
    private fun showPasswordInputDialog() {
        val builder = AlertDialog.Builder(this.context)
        builder.setTitle("Enter Password")

        val input = EditText(this.context)
        builder.setView(input)

        builder.setPositiveButton("OK") { _, _ ->
            val password = input.text.toString()
            if (password.isEmpty()) {
                PrintDemoApp.instance.currentSelectedPrinter?.password = null
            }
            else {
                PrintDemoApp.instance.currentSelectedPrinter?.password = password
            }
            onResume()
        }

        builder.setNegativeButton("Cancel") { dialog, _ -> dialog.cancel() }

        builder.show()
    }
}

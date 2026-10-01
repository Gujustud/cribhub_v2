package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentMainBinding
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleCategoryButtonRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.viewmodel.MainViewModel

class MainFragment : Fragment() {
    private lateinit var viewModel: MainViewModel
    private lateinit var binding: FragmentMainBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_main, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[MainViewModel::class.java]

        setupViews()
        setupViewEvents()
    }

    private fun setupViews() {
        val context = this.context ?: return

        binding.mainMenuRecycler.layoutManager = LinearLayoutManager(context)
        binding.mainMenuRecycler.adapter = SimpleCategoryButtonRecyclerAdapter(context, viewModel.getMainMenuList(context)) {
            when (it.info) {
                context.getString(R.string.print_image) -> {
                    findNavController().navigate(MainFragmentDirections.toPrintImage())
                }

                context.getString(R.string.print_pdf) -> {
                    findNavController().navigate(MainFragmentDirections.toPrintPdf())
                }

                context.getString(R.string.template_print) -> {
                    findNavController().navigate(MainFragmentDirections.toPrintTemplate())
                }

                context.getString(R.string.transfer_files) -> {
                    findNavController().navigate(MainFragmentDirections.toTransferFiles())
                }

                context.getString(R.string.printer_info) -> {
                    findNavController().navigate(MainFragmentDirections.toPrinterInfo())
                }

                context.getString(R.string.validate) -> {
                    findNavController().navigate(MainFragmentDirections.toSelectPrinter().apply {
                        arguments.putBoolean(SelectPrinterFragment.KeyIsModelSpec, false)
                    })
                }

                context.getString(R.string.model_spec) -> {
                    findNavController().navigate(MainFragmentDirections.toSelectPrinter().apply {
                        arguments.putBoolean(SelectPrinterFragment.KeyIsModelSpec, true)
                    })
                }

                context.getString(R.string.file_analyze) -> {
                    findNavController().navigate(MainFragmentDirections.toFileAnalyze())
                }
            }
        }
    }

    private fun setupViewEvents() {
        binding.mainAboutButton.setOnClickListener {
            findNavController().navigate(MainFragmentDirections.toAbout())
        }
    }
}

package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.ui.components.InputIntFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.InputTemplateKeyViewModel

class InputTemplateKeyFragment : Fragment() {
    private lateinit var viewModel: InputTemplateKeyViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[InputTemplateKeyViewModel::class.java]

        val currentPrint = PrintDemoApp.instance.currentSelectedPrinter
        viewModel.data.modelName = currentPrint?.modelName ?: ""

        setupView()
        setupEvents()
    }

    private fun setupView() {
        val bundle = Bundle().apply {
            putInt(InputIntFragment.KeyTitleId, R.string.print_template)
            putInt(InputIntFragment.KeyInputIntHintId, R.string.template_key)
        }

        val fragment = InputIntFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.getLiveData<Int>(InputIntFragment.KeyInputValue)?.observe(viewLifecycleOwner) {
            handle.remove<Int>(InputIntFragment.KeyInputValue)
            viewModel.data.key = it


            val templateData = viewModel.data
            findNavController().navigate(InputTemplateKeyFragmentDirections.toSelectTemplateEncodingFragment().apply {
                arguments.putParcelable(EditTemplateFragment.KeyPrintData, templateData)
            })
        }
    }
}

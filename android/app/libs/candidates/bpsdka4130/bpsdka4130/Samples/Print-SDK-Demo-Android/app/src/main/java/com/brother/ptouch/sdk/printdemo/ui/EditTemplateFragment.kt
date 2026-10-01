package com.brother.ptouch.sdk.printdemo.ui

import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentEditTemplateBinding
import com.brother.ptouch.sdk.printdemo.model.TemplateEditType
import com.brother.ptouch.sdk.printdemo.model.TemplateEncoding
import com.brother.ptouch.sdk.printdemo.model.TemplatePrintData
import com.brother.ptouch.sdk.printdemo.ui.components.ShowResultFragment
import com.brother.ptouch.sdk.printdemo.ui.dialog.CommonDialog
import com.brother.ptouch.sdk.printdemo.viewmodel.EditTemplateViewModel

class EditTemplateFragment : Fragment() {
    companion object {
        const val KeyPrintData = "print_data_key"
        const val KeyIndex = "Index"
        const val KeyObjectName = "ObjectName"
        const val KeyText = "Text"
        const val KeyEnd = "End"
        const val KeyStartTemplate = "Start template key"
        const val KeyEncoding = "Encode"
    }

    private lateinit var viewModel: EditTemplateViewModel
    private lateinit var binding: FragmentEditTemplateBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_edit_template, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    @Suppress("DEPRECATION")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[EditTemplateViewModel::class.java]
        viewModel.data = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            arguments?.getParcelable(KeyPrintData, TemplatePrintData::class.java)
        else
            arguments?.getParcelable(KeyPrintData)

        binding.bean = viewModel.bean
        updateInputData()
        setupEvents()
    }

    private fun setupEvents() {
        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }

        binding.editTemplatePrintButton.setOnClickListener {
            startPrint()
        }

        binding.editTemplateAddButton.setOnClickListener {
            if (checkInputData()) {
                viewModel.addInputData(
                    binding.editTemplateIndexEditor.text.toString(),
                    binding.editTempalteObjectEditor.text.toString(),
                    binding.editTemplateTextEditor.text.toString(),
                    TemplateEncoding.valueOf(binding.editTemplateEncodingSpinner.selectedItem.toString())
                )
                updateInputData()
            }
        }

        binding.editTemplateDeleteButton.setOnClickListener {
            viewModel.deleteInputData()
            updateInputData()
        }


        val context = context ?: return

        binding.editTemplateEncodingSpinner.adapter = ArrayAdapter(context, android.R.layout.simple_spinner_item, TemplateEncoding.values().map { it.desc })
        val index = TemplateEncoding.values().indexOfFirst { it == TemplateEncoding.UTF_8 }
        binding.editTemplateEncodingSpinner.setSelection(index)
    }

    private fun startPrint() {
        val templateData = viewModel.data ?: return
        viewModel.addEndKey()
        updateInputData()
        val type = binding.bean?.selectedEditType?.get() ?: return
        templateData.type = type
        viewModel.data = templateData
        val context = context ?: return
        val cancelDialog = CommonDialog.cancelingDialog(context)
        val dialog = CommonDialog.waitingDialog(context, context.getString(R.string.print_message)) {
            viewModel.cancelPrint()
            cancelDialog.show()
        }

        dialog.show()
        viewModel.starPrintTemplate(context) {
            dialog.dismiss()
            cancelDialog.dismiss()
            findNavController().navigate(EditTemplateFragmentDirections.toShowResult().apply {
                arguments.putString(ShowResultFragment.KeyPrintResult, it)
            })
        }
    }

    private fun checkInputData(): Boolean {
        val context = context ?: return false
        val type = binding.bean?.selectedEditType?.get() ?: return false
        val result: Boolean = when (type) {

            TemplateEditType.Index -> {
                binding.editTemplateIndexEditor.text.toString() != ""
            }
            TemplateEditType.ObjectName -> {
                binding.editTempalteObjectEditor.text.toString() != ""
            }
            TemplateEditType.NoText -> return true
        }

        if (!result) {
            CommonDialog.showErrorDialog(context, context.getString(R.string.msg_title_warning), context.getString(R.string.error_input))
        }
        return result
    }

    private fun updateInputData() {
        val templateData = viewModel.data ?: return
        val list = templateData.itemList
        var data = ""
        list.forEach { item ->
            item.toSortedMap().forEach {
                data += it.key + (if (it.key != KeyEnd) ": " else "") + it.value + "  "
            }
            data += "\n"
        }
        context?.let {
            binding.editTemplateDataTextView.text = it.getString(R.string.data_input) + "\n" + data
        }
    }
}

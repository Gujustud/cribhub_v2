package com.brother.ptouch.sdk.printdemo.ui.components

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentSelectEnumBinding
import com.brother.ptouch.sdk.printdemo.model.EnumDesc
import com.brother.ptouch.sdk.printdemo.viewmodel.SelectEnumViewModel

class SelectEnumFragment : Fragment() {
    companion object {
        const val KeySelectEnumTitleId = "select.enum.title.id"
        const val KeySelectEnumHintId = "select.enum.hint.id"
        const val KeyEnumDisplayData = "enum.display.data"
        const val KeySelectedEnum = "selected.enum"
    }

    private lateinit var viewModel: SelectEnumViewModel
    private lateinit var binding: FragmentSelectEnumBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_select_enum, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    @Suppress("DEPRECATION", "UNCHECKED_CAST")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[SelectEnumViewModel::class.java]

        val result = arguments?.getParcelableArray(KeyEnumDisplayData) as? Array<EnumDesc>
        result?.let {
            viewModel.displayData.addAll(it)
            viewModel.currentSelectedData = it.firstOrNull()
        }

        val input = arguments?.getParcelable(KeySelectedEnum) as? EnumDesc
        input?.let {
            viewModel.currentSelectedData = it
        }

        setupViews()
    }

    private fun setupViews() {
        val context = context ?: return

        arguments?.getInt(KeySelectEnumTitleId)?.let {
            binding.toolbar.title = context.getString(it)
        }

        arguments?.getInt(KeySelectEnumHintId)?.let {
            binding.selectHint.text = context.getString(it)
        }

        binding.toolbar.menu.findItem(R.id.next_menu)?.setOnMenuItemClickListener {
            val controller = findNavController()
            with(controller) {
                currentBackStackEntry?.savedStateHandle?.set(KeySelectedEnum, viewModel.currentSelectedData)
            }

            return@setOnMenuItemClickListener true
        }

        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }

        binding.selectSpinner.adapter = ArrayAdapter(context, android.R.layout.simple_spinner_item, viewModel.displayData.map { it.desc })
        val index = viewModel.displayData.indexOfFirst { it == viewModel.currentSelectedData }
        binding.selectSpinner.setSelection(index)
        binding.selectSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                viewModel.currentSelectedData = viewModel.displayData.getOrNull(position)
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
            }
        }
    }
}

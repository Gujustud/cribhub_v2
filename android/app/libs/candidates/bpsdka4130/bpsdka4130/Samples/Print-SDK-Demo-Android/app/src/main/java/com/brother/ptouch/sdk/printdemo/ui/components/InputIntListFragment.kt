package com.brother.ptouch.sdk.printdemo.ui.components

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentInputIntListBinding
import com.brother.ptouch.sdk.printdemo.viewmodel.InputIntListViewModel

class InputIntListFragment : Fragment() {
    companion object {
        const val KeyMenuStringId = "input.int.list.menu.id"
        const val KeyTitleId = "input.int.list.title.id"
        const val KeyInputIntList = "input.int.list.value"
        const val KeyInputIntListString = "input.int.list.string"
    }

    private lateinit var viewModel: InputIntListViewModel
    private lateinit var binding: FragmentInputIntListBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_input_int_list, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[InputIntListViewModel::class.java]
        binding.bean = viewModel.bean

        setupViews()
    }

    private fun setupViews() {
        val context = context ?: return
        arguments?.getInt(KeyTitleId)?.let {
            kotlin.runCatching { binding.toolbar.title = context.getString(it) }
        }

        arguments?.getInt(KeyMenuStringId)?.let {
            kotlin.runCatching { binding.toolbar.menu.findItem(R.id.delete_menu).title = context.getString(it) }
        }

        arguments?.getString(KeyInputIntListString)?.let {
            viewModel.bean.intListString.set(it)
        }

        binding.toolbar.menu.findItem(R.id.delete_menu)?.setOnMenuItemClickListener {
            val data = viewModel.getInputIntList()
            if (data.isEmpty()) {
                viewModel.bean.message.set(context.getString(R.string.error_invalidate_input))
                return@setOnMenuItemClickListener true
            }

            val controller = findNavController()
            with(controller) {
                currentBackStackEntry?.savedStateHandle?.set(KeyInputIntList, data)
            }

            return@setOnMenuItemClickListener true
        }

        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }
    }
}

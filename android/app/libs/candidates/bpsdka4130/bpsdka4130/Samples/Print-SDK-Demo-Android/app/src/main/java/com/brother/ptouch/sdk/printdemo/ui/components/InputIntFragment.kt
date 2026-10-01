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
import com.brother.ptouch.sdk.printdemo.databinding.FragmentInputIntBinding
import com.brother.ptouch.sdk.printdemo.viewmodel.InputIntViewModel

class InputIntFragment : Fragment() {
    companion object {
        const val KeyTitleId = "input.int.title.id"
        const val KeyInputIntHintId = "input.int.hint.id"
        const val KeyInputValue = "input.int.value"
    }

    private lateinit var viewModel: InputIntViewModel
    private lateinit var binding: FragmentInputIntBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_input_int, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[InputIntViewModel::class.java]
        binding.bean = viewModel.bean

        setupViews()
    }

    private fun setupViews() {
        val context = context ?: return

        arguments?.getInt(KeyTitleId)?.let {
            binding.toolbar.title = context.getString(it)
        }

        arguments?.getInt(KeyInputIntHintId)?.let {
            binding.inputIntHint.text = context.getString(it)
        }

        arguments?.getString(KeyInputValue)?.let {
            viewModel.bean.intValue.set(it)
        }

        binding.toolbar.menu.findItem(R.id.next_menu)?.setOnMenuItemClickListener {
            val data = viewModel.getInputValue()
            if (data == null) {
                viewModel.bean.message.set(context.getString(R.string.error_invalidate_input))
                return@setOnMenuItemClickListener true
            }

            val controller = findNavController()
            with(controller) {
                currentBackStackEntry?.savedStateHandle?.set(KeyInputValue, data)
            }

            return@setOnMenuItemClickListener true
        }

        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }
    }
}

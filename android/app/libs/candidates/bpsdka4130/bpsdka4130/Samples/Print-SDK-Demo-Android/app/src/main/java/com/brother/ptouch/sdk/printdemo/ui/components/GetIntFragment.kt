package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.ui.components.InputIntFragment

class GetIntFragment : Fragment() {
    companion object {
        const val KeyInputValue = "get.int.value"
        const val KeyTitle = "get.int.title"
        const val KeyHint = "get.int.hint"
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupView()
        setupEvents()
    }

    private fun setupView() {
        val bundle = Bundle().apply {
            putInt(InputIntFragment.KeyTitleId, R.string.print_template)
            putInt(InputIntFragment.KeyInputIntHintId, R.string.template_key)

            arguments?.getInt(KeyTitle)?.let {
                putInt(InputIntFragment.KeyTitleId, it)
            }

            arguments?.getInt(KeyHint)?.let {
                putInt(InputIntFragment.KeyInputIntHintId, it)
            }


        }

        val fragment = InputIntFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.getLiveData<Int>(InputIntFragment.KeyInputValue)?.observe(viewLifecycleOwner) {

            findNavController().previousBackStackEntry?.savedStateHandle?.set(KeyInputValue, it)
            handle.remove<Int>(InputIntFragment.KeyInputValue)
            findNavController().popBackStack()
        }
    }
}

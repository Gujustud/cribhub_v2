package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.ui.components.InputIntListFragment

class GetIntListFragment : Fragment() {
    companion object {
        const val KeyInputValue = "get.int.value"
        const val KeyTitle = "get.int.title"
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
            putInt(InputIntListFragment.KeyTitleId, R.string.print_template)
            putInt(InputIntListFragment.KeyMenuStringId, R.string.next)

            arguments?.getInt(KeyTitle)?.let {
                putInt(InputIntListFragment.KeyTitleId, it)
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
            findNavController().previousBackStackEntry?.savedStateHandle?.set(KeyInputValue, it)
            handle.remove<ArrayList<Int>>(InputIntListFragment.KeyInputIntList)
            findNavController().popBackStack()
        }
    }
}

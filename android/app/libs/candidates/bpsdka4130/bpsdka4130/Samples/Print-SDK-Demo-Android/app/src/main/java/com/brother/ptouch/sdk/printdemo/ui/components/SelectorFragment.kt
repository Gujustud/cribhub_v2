package com.brother.ptouch.sdk.printdemo.ui.components

import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentBaseListBinding
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleCategoryButtonRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleData
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleStringRecyclerAdapter

open class SelectorFragment : Fragment() {
    companion object {
        const val KeyTitleId = "title.id"
        const val KeyMenuList = "menu.list"
        const val KeyButtonMenuList = "menu.button.list"
        const val KeyItemGravity = "item.gravity"
        const val KeySelectedMenu = "selected.menu"
        const val KeySelectedButtonMenu = "selected.button.menu"
    }

    lateinit var binding: FragmentBaseListBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val context = this.context ?: return super.onCreateView(inflater, container, savedInstanceState)
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_base_list, null, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupViews()
    }

    @Suppress("DEPRECATION")
    private fun setupViews() {
        val context = this.context ?: return

        arguments?.getInt(KeyTitleId)?.let {
            binding.toolbar.title = context.getString(it)
        }

        val stringItems = arguments?.getStringArrayList(KeyMenuList) ?: listOf<String>()
        val buttonItems = arguments?.getParcelableArrayList(KeyButtonMenuList) ?: listOf<SimpleData>()
        val itemGravity = arguments?.getInt(KeyItemGravity, Gravity.CENTER_HORIZONTAL) ?: Gravity.CENTER_HORIZONTAL

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
    }

    private fun onItemSelected(info: String) {
        val controller = findNavController()
        with(controller) {
            currentBackStackEntry?.savedStateHandle?.set(KeySelectedMenu, info)
        }
    }

    private fun onButtonItemSelected(data: SimpleData) {
        val controller = findNavController()
        with(controller) {
            currentBackStackEntry?.savedStateHandle?.set(KeySelectedButtonMenu, data)
        }
    }
}

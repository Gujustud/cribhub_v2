package com.brother.ptouch.sdk.printdemo.ui.components

import android.os.Build
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
import com.brother.ptouch.sdk.printdemo.databinding.FragmentShowResultBinding
import com.brother.ptouch.sdk.printdemo.model.TemplateData
import com.brother.ptouch.sdk.printdemo.ui.adapters.KeyAndValueRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.viewmodel.ShowResultViewModel

class ShowResultFragment : Fragment() {
    companion object {
        const val KeyPrintResult = "print_result_key"
        const val KeyTemplateList = "template_list"
    }

    private lateinit var viewModel: ShowResultViewModel
    private lateinit var binding: FragmentShowResultBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_show_result, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    @Suppress("DEPRECATION")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[ShowResultViewModel::class.java]
        binding.bean = viewModel.bean
        viewModel.bean.templateList.set(arrayListOf())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            viewModel.bean.templateList.set(arguments?.getParcelableArrayList(KeyTemplateList, TemplateData::class.java))
        } else {
            viewModel.bean.templateList.set(arguments?.getParcelableArrayList(KeyTemplateList))
        }

        setupViews()
        setupViewEvents()
    }

    private fun setupViews() {
        binding.printResult.text = arguments?.getString(KeyPrintResult)

        val context = this.context ?: return

        binding.resultListRecycler.layoutManager = LinearLayoutManager(context)
        binding.resultListRecycler.addItemDecoration(RecyclerViewDivider())
        binding.resultListRecycler.adapter = KeyAndValueRecyclerAdapter(
            context,
            viewModel.bean.templateList.get()?.map { it.key.toString() } ?: listOf(),
            viewModel.bean.templateList.get()?.map {
                context.getString(R.string.template_name) + ":" + it.name + "  " +
                        context.getString(R.string.template_file_size) + ":" + it.fileSize.toString() + "  " +
                        context.getString(R.string.template_modified_date) + ":" + it.modifiedDate.toString()
            } ?: listOf()
        )
    }

    private fun setupViewEvents() {
        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }
    }
}

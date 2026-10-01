package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentAboutBinding
import com.brother.ptouch.sdk.printdemo.viewmodel.AboutViewModel

class AboutFragment : Fragment() {
    private lateinit var viewModel: AboutViewModel
    private lateinit var binding: FragmentAboutBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_about, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[AboutViewModel::class.java]

        setupViews()
    }

    private fun setupViews() {
        val context = context ?: return
        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }
        binding.aboutInfo.text = viewModel.getVersionCode(context)
    }
}

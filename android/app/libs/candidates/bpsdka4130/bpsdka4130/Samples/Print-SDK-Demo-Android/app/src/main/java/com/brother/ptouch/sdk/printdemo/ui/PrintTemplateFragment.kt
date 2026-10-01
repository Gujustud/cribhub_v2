package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.TransitionUtils
import com.brother.ptouch.sdk.printdemo.model.PrinterConnectUtil
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorWithSearchFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.PrintTemplateViewModel
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class PrintTemplateFragment : Fragment() {
    private lateinit var viewModel: PrintTemplateViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[PrintTemplateViewModel::class.java]
        setupView()
        setupEvents()
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.print_template)
            putStringArrayList(SelectorFragment.KeyMenuList, ArrayList(viewModel.getPrintTemplateMenuList(context)))
            putInt(SelectorFragment.KeyItemGravity, Gravity.START)
        }

        val fragment = SelectorWithSearchFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private suspend fun showResult(result :String) {
        TransitionUtils.showResult(
            this,
            PrintTemplateFragmentDirections.actionGlobalFragmentShowResult(),
            result
        )
    }
    private fun showGetIntList(titleId:Int, decisionBlock: (ArrayList<Int>) -> Unit) {
        TransitionUtils.getIntListArgument(this, PrintTemplateFragmentDirections.actionGlobalFragmentGetIntList(), titleId, decisionBlock)
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.remove<String>(SelectorFragment.KeySelectedMenu)
        handle?.getLiveData<String>(SelectorFragment.KeySelectedMenu)?.observe(viewLifecycleOwner) {
            val context = context ?: return@observe

            val currentPrinter = PrintDemoApp.instance.currentSelectedPrinter
            if (currentPrinter == null) {
                Toast.makeText(context, R.string.select_printer_message, Toast.LENGTH_SHORT).show()
                return@observe
            }

            when (it) {
                context.getString(R.string.remove_template_with_key) -> {

                    showGetIntList( R.string.remove_template_key_title) { removeKeys ->

                        val waitingDialog = TransitionUtils.showWaitingDialog(context)

                        lifecycleScope.launch(Dispatchers.Default) {

                            val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                            val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)

                            val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                            if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                                showResult(generateResult.error.toString())
                                return@launch
                            }
                            val driver = generateResult.driver

                            val result = driver.removeTemplateWithKeys(removeKeys)

                            showResult(result.toString())

                            driver.closeChannel()

                        }.invokeOnCompletion {
                            waitingDialog.dismiss()
                        }
                    }

                }
                context.getString(R.string.print_template) -> {
                    findNavController().navigate(PrintTemplateFragmentDirections.toInputTemplateKeyFragment())
                }

            }

        }
    }

}

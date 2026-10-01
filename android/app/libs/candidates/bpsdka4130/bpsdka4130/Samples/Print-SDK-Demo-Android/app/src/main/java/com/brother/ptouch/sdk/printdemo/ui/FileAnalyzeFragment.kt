package com.brother.ptouch.sdk.printdemo.ui

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.TransitionUtils
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleData
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.sdk.lmprinter.FileAnalyzer
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class FileAnalyzeFragment : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupView()
        setupEvents()
    }

    private suspend fun startAnalyze(buttonCaption: String, context: Context, filepath: String) {
        when (buttonCaption) {
            context.getString(R.string.analyze_pd3) -> {
                var result = FileAnalyzer.analyzePD3(filepath)
                showResult(getResultString(context, result))

            }
        }
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.file_analyze)
            putParcelableArrayList(
                SelectorFragment.KeyButtonMenuList,
                ArrayList(mutableListOf(
                    SimpleData(false, context.getString(R.string.analyze_pd3)),
                ))
            )
        }

        val fragment = SelectorFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.remove<SimpleData>(SelectorFragment.KeySelectedButtonMenu)
        handle?.getLiveData<SimpleData>(SelectorFragment.KeySelectedButtonMenu)?.observe(viewLifecycleOwner) {
            val context = context ?: return@observe

            val waitingDialog = TransitionUtils.showWaitingDialog(context)

            lifecycleScope.launch(Dispatchers.Default) {
                val buttonCaption = it.info
                showSelectFile {
                    lifecycleScope.launch(Dispatchers.Default) {
                        startAnalyze(buttonCaption, context, it)
                    }
                }
            }.invokeOnCompletion {
                waitingDialog.dismiss()
            }

        }
    }

    private suspend fun showResult(result :String) {
        TransitionUtils.showResult(
            this,
            PrintTemplateFragmentDirections.actionGlobalFragmentShowResult(),
            result
        )
    }

    private val fileLauncher = TransitionUtils.fileLauncher(this)
    private fun showSelectFile(decisionBlock:(String)->Unit) {
        TransitionUtils.getFileArgument(fileLauncher,false) {
            decisionBlock(it.firstOrNull() ?: return@getFileArgument)
        }
    }

    private fun <T> getResultString(context: Context, ret : FileAnalyzer.Result<T>) : String {
        return context.getString((R.string.result)) + " : " + ret.error.code.toString() + "\r\n" + context.getString((R.string.value)) + " : " + ret.report.toString() + "\r\n" + context.getString((R.string.error_destination)) + " : " + ret.error.description + "\r\n" + "\r\n" + ret.error.allLogs.joinToString("\r\n")
    }
}

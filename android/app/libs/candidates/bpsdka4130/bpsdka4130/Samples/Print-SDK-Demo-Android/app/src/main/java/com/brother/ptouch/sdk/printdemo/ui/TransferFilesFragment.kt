package com.brother.ptouch.sdk.printdemo.ui

import android.content.Context
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.PrinterConnectUtil
import com.brother.ptouch.sdk.printdemo.model.TransitionUtils
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorWithSearchFragment
import com.brother.ptouch.sdk.printdemo.ui.dialog.CommonDialog
import com.brother.sdk.lmprinter.FileConverter
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.nio.ByteBuffer
import java.nio.file.Files
import java.nio.file.Paths

class TransferFilesFragment : Fragment() {

    fun getTransferMenuList(context: Context): List<String> {
        return mutableListOf(
            context.getString(R.string.transferFirmwareFiles),
            context.getString(R.string.transferTemplateFiles),
            context.getString(R.string.transferDatabaseFiles),
            context.getString(R.string.transferBinaryFiles),
            context.getString(R.string.transferBinaryData),
            context.getString(R.string.transferPrinterConfigurationFiles),
        )
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupView()
        setupEvents()
    }

    private suspend fun startTransfer(buttonCaption: String, context: Context, currentSelectedPrinter: DiscoveredPrinterInfo, filepaths: List<String>, progressBar: ProgressBar, progressText: TextView) {
        val activity = activity ?: return
        val channel = PrinterConnectUtil.getCurrentChannel(context, currentSelectedPrinter) ?: return
        val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentSelectedPrinter)

        val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
        if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
            showResult(generateResult.error.toString())
            return
        }
        val driver = generateResult.driver
        val convertResult = FileConverter.convertPDZtoPD3(filepaths, context.cacheDir.toString())
        if (convertResult.errorCode != FileConverter.ErrorCode.NoError) {
            showResult(convertResult.toString())
            return
        }
        val convertedFilepaths = convertResult.filePaths

        when (buttonCaption) {
            context.getString(R.string.transferFirmwareFiles) -> {
                val result = driver.transferFirmwareFiles(convertedFilepaths) { name, progressPercentage ->
                    activity.runOnUiThread {
                        progressBar.progress = progressPercentage
                        progressText.text = name
                    }
                }
                driver.closeChannel()
                showResult(result.toString())
            }
            context.getString(R.string.transferTemplateFiles) -> {
                val result = driver.transferTemplateFiles(convertedFilepaths) { name, progressPercentage ->
                    activity.runOnUiThread {
                        progressBar.progress = progressPercentage
                        progressText.text = name
                    }
                }
                driver.closeChannel()
                showResult(result.toString())
            }
            context.getString(R.string.transferDatabaseFiles) -> {
                val result = driver.transferDatabaseFiles(convertedFilepaths) { name, progressPercentage ->
                    activity.runOnUiThread {
                        progressBar.progress = progressPercentage
                        progressText.text = name
                    }
                }
                driver.closeChannel()
                showResult(result.toString())
            }
            context.getString(R.string.transferBinaryFiles) -> {
                val result = driver.transferBinaryFiles(convertedFilepaths) { name, progressPercentage ->
                    activity.runOnUiThread {
                        progressBar.progress = progressPercentage
                        progressText.text = name
                    }
                }
                driver.closeChannel()
                showResult(result.toString())
            }
            context.getString(R.string.transferBinaryData) -> {
                val data: List<ByteBuffer> = convertedFilepaths.map {
                    ByteBuffer.wrap(Files.readAllBytes(Paths.get(it)))
                }
                val result = driver.transferBinaryData(data) { index, progressPercentage ->
                    activity.runOnUiThread {
                        progressBar.progress = progressPercentage
                        progressText.text = index.toString()
                    }
                }
                driver.closeChannel()
                showResult(result.toString())
            }
            context.getString(R.string.transferPrinterConfigurationFiles) -> {
                val result = driver.transferPrinterConfigurationFiles(convertedFilepaths) { name, progressPercentage ->
                    activity.runOnUiThread {
                        progressBar.progress = progressPercentage
                        progressText.text = name
                    }
                }
                driver.closeChannel()
                showResult(result.toString())
            }
        }
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.transfer_files)
            putStringArrayList(SelectorFragment.KeyMenuList, ArrayList(getTransferMenuList(context)))
            putInt(SelectorFragment.KeyItemGravity, Gravity.START)
        }

        val fragment = SelectorWithSearchFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val activity = activity ?: return
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.remove<String>(SelectorFragment.KeySelectedMenu)
        handle?.getLiveData<String>(SelectorFragment.KeySelectedMenu)?.observe(viewLifecycleOwner) {
            val context = context ?: return@observe
            val currentPrint = PrintDemoApp.instance.currentSelectedPrinter
            if (currentPrint == null) {
                Toast.makeText(context, R.string.select_printer_message, Toast.LENGTH_SHORT).show()
                return@observe
            }

            lifecycleScope.launch(Dispatchers.Default) {
                val buttonCaption = it
                showFileSelectionView {
                    val fileList = it
                    showSelectedFileDialog(context, fileList) {
                        activity.runOnUiThread {
                            val (progressDialog, progressBar, progressText) = CommonDialog.progressDialog(context, "preparing")
                            progressDialog.show()
                            lifecycleScope.launch(Dispatchers.Default) {
                                startTransfer(buttonCaption, context, currentPrint, fileList, progressBar, progressText)
                                activity.runOnUiThread {
                                    progressDialog.dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private val fileLauncher = TransitionUtils.fileLauncher(this)
    private fun showFileSelectionView(decisionBlock:(List<String>)->Unit) {
        TransitionUtils.getFileArgument(fileLauncher,true) {
            decisionBlock(it)
        }
    }

    private suspend fun showResult(result :String) {
        TransitionUtils.showResult(
            this,
            PrintTemplateFragmentDirections.actionGlobalFragmentShowResult(),
            result
        )
    }

    private fun showSelectedFileDialog(context: Context, filePaths: List<String>, callback: () -> Unit) {
        MaterialAlertDialogBuilder(context)
            .setMessage(filePaths.joinToString(separator = "\n"))
            .setPositiveButton(R.string.transfer) { _, _ ->
                callback()
            }
            .setNegativeButton(R.string.cancel, null)
            .show()
    }
}

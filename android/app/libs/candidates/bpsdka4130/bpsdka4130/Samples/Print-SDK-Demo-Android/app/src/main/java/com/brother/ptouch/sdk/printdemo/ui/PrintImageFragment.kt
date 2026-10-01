package com.brother.ptouch.sdk.printdemo.ui

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.model.ImagePrnType
import com.brother.ptouch.sdk.printdemo.model.StorageUtils.deleteSelectFolder
import com.brother.ptouch.sdk.printdemo.model.StorageUtils.getSelectFileUri
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorWithSearchFragment
import com.brother.ptouch.sdk.printdemo.ui.components.ShowResultFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.PrintImageViewModel
import com.google.android.material.dialog.MaterialAlertDialogBuilder

class PrintImageFragment : Fragment() {
    companion object {
        private val ImageMimeTypes = arrayOf("image/jpeg", "image/png", "image/x-ms-bmp", "image/gif")
        private val PrnRawMimeTypes = arrayOf("application/octet-stream")
    }

    private lateinit var viewModel: PrintImageViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[PrintImageViewModel::class.java]
        setupView()
        setupEvents()
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.print_image)
            putStringArrayList(SelectorFragment.KeyMenuList, ArrayList(viewModel.getPrintImageMenuList(context)))
            putInt(SelectorFragment.KeyItemGravity, Gravity.START)
        }

        val fragment = SelectorWithSearchFragment().apply {
            arguments = bundle
        }
        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.remove<String>(SelectorFragment.KeySelectedMenu)
        handle?.getLiveData<String>(SelectorFragment.KeySelectedMenu)?.observe(viewLifecycleOwner) {
            val context = context ?: return@observe
            val currentPrint = PrintDemoApp.instance.currentSelectedPrinter
            if (currentPrint == null) {
                Toast.makeText(context, R.string.select_printer_message, Toast.LENGTH_SHORT).show()
                return@observe
            }
            var type = ImagePrnType.ImageFile
            when (it) {
                context.getString(R.string.print_image_with_image) -> {
                    type = ImagePrnType.BitmapData
                    startToSelectFiles(ImageMimeTypes, false)
                }
                context.getString(R.string.print_image_with_URL) -> {
                    type = ImagePrnType.ImageFile
                    startToSelectFiles(ImageMimeTypes, false)
                }
                context.getString(R.string.print_image_with_URLs) -> {
                    type = ImagePrnType.ImageFiles
                    startToSelectFiles(ImageMimeTypes, true)
                }
                context.getString(R.string.print_image_with_Closures) -> {
                    type = ImagePrnType.Closures
                    startToSelectFiles(ImageMimeTypes, true)
                }
            }
            viewModel.printData.dataType = type
        }
    }

    private fun startToSelectFiles(mineTypes: Array<String>, isMultiple: Boolean) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, mineTypes)
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, isMultiple)
        }
        startForPrnResult.launch(intent)
    }

    private val startForPrnResult = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
        if (it.resultCode != AppCompatActivity.RESULT_OK) {
            return@registerForActivityResult
        }
        val context = context ?: return@registerForActivityResult
        val data = viewModel.printData
        data.imagePrnData.clear()

        it.data?.data?.let { uri ->
            if (viewModel.isSupportFile(context, uri)) {
                val path = getSelectFileUri(context, uri) ?: return@registerForActivityResult
                data.imagePrnData.add(path)
            } else {
                showUnsupportedFileDialog()
                return@registerForActivityResult
            }
        }

        val clipData = it.data?.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount) {
                if (viewModel.isSupportFile(context, clipData.getItemAt(i).uri)) {
                    val path = getSelectFileUri(context, clipData.getItemAt(i).uri) ?: return@registerForActivityResult
                    data.imagePrnData.add(path)
                }
            }
        }

        if (data.imagePrnData.isEmpty())
            return@registerForActivityResult

        findNavController().currentBackStackEntry?.savedStateHandle?.remove<String>(SelectorFragment.KeySelectedMenu)
        findNavController().navigate(PrintImageFragmentDirections.toPrintSettings().apply {
            arguments.putParcelable(PrintSettingsFragment.KeyPrintData, data)
            arguments.putBoolean(PrintSettingsFragment.KeyIsShowPrintBtn, true)
        })
    }

    private fun getPrintDialog(context: Context): androidx.appcompat.app.AlertDialog {
        val builder = MaterialAlertDialogBuilder(context)
        builder.setMessage(R.string.print_message)
        builder.setNegativeButton(R.string.cancel) { _, _ ->
            viewModel.cancelPrint()
        }
        return builder.create()
    }

    private fun showUnsupportedFileDialog() {
        val context = context ?: return
        MaterialAlertDialogBuilder(context)
            .setTitle(R.string.unsupported_file)
            .setPositiveButton(android.R.string.ok) { _, _ ->
            }
            .show()
    }
}

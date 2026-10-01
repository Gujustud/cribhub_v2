package com.brother.ptouch.sdk.printdemo.ui

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
import com.brother.ptouch.sdk.printdemo.model.PDFPrintType
import com.brother.ptouch.sdk.printdemo.model.PdfPrintData
import com.brother.ptouch.sdk.printdemo.model.StorageUtils
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorWithSearchFragment
import com.brother.ptouch.sdk.printdemo.viewmodel.PrintPDFViewModel

class PrintPDFFragment : Fragment() {

    companion object {
        private val MimeTypes = arrayOf("application/pdf")
    }

    private lateinit var viewModel: PrintPDFViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[PrintPDFViewModel::class.java]
        setupView()
        setupEvents()
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.print_pdf)
            putStringArrayList(SelectorFragment.KeyMenuList, ArrayList(viewModel.getPrintPDFMenuList(context)))
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

            val type = when (it) {
                context.getString(R.string.print_PDF_with_URL) -> PDFPrintType.File
                context.getString(R.string.print_PDF_with_URLs) -> PDFPrintType.Files
                context.getString(R.string.print_PDF_with_URL_pages) -> PDFPrintType.Pages
                else -> null
            } ?: return@observe

            viewModel.currentPDFData = PdfPrintData(type, arrayListOf(), arrayListOf())
            showSelectPDFView()
        }
    }

    private fun showSelectPDFView() {
        val isMultiple = viewModel.currentPDFData?.type == PDFPrintType.Files
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, MimeTypes)
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, isMultiple)
        }
        launcher.launch(intent)
    }

    private val launcher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
        if (it.resultCode != AppCompatActivity.RESULT_OK) {
            return@registerForActivityResult
        }
        val context = context ?: return@registerForActivityResult
        val data = viewModel.currentPDFData ?: return@registerForActivityResult

        it.data?.data?.let { uri ->
            val temp = StorageUtils.getSelectFileUri(context, uri) ?: return@let
            data.pdfData.add(temp)
        }

        // multiple
        val clipData = it.data?.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount) {
                val temp = StorageUtils.getSelectFileUri(context, clipData.getItemAt(i).uri) ?: continue
                data.pdfData.add(temp)
            }
        }

        if (data.pdfData.isEmpty()) {
            return@registerForActivityResult
        }

        // remove listener
        findNavController().currentBackStackEntry?.savedStateHandle?.remove<String>(SelectorFragment.KeySelectedMenu)

        if (viewModel.currentPDFData?.type == PDFPrintType.Pages) {
            findNavController().navigate(PrintPDFFragmentDirections.toInputPages().apply {
                arguments.putParcelable(PrintSettingsFragment.KeyPrintData, data)
            })
        } else {
            findNavController().navigate(PrintPDFFragmentDirections.toPrintSettings().apply {
                arguments.putParcelable(PrintSettingsFragment.KeyPrintData, data)
                arguments.putBoolean(PrintSettingsFragment.KeyIsShowPrintBtn, true)
            })
        }
    }
}

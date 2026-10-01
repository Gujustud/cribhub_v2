package com.brother.ptouch.sdk.printdemo.ui

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.brother.ptouch.sdk.printdemo.PrintDemoApp
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.FragmentPrinterListBinding
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.LocationUtils
import com.brother.ptouch.sdk.printdemo.model.printersearch.PrinterSearchError
import com.brother.ptouch.sdk.printdemo.ui.adapters.PrinterListRecyclerAdapter
import com.brother.ptouch.sdk.printdemo.ui.components.RecyclerViewDivider
import com.brother.ptouch.sdk.printdemo.ui.dialog.CommonDialog
import com.brother.ptouch.sdk.printdemo.viewmodel.PrinterListViewModel
import com.brother.sdk.lmprinter.Channel

class PrinterListFragment : Fragment() {
    companion object {
        const val KeyPrinterInterface = "printer_interface"
        const val KeyDstFragmentId = "src_fragment_id"
        const val KeyPrinterInfo = "printer_info"
        private const val ActionUSBPermission = "com.android.example.USB_PERMISSION"
    }

    private lateinit var viewModel: PrinterListViewModel
    private lateinit var binding: FragmentPrinterListBinding
    private var waitingDialog: AlertDialog? = null
    private var cancelDialog: AlertDialog? = null
    private val requestPermissionLauncher =
        registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { result ->
            if (result.isEmpty()) {
                return@registerForActivityResult
            }

            if (!result.values.contains(false)) {
                startSearch()
            } else {
                binding.printerListRecycler.visibility = View.GONE
                binding.printerListText.text = getWarningMessage(result.entries.filter { !it.value }.map { it.key }.toTypedArray())
            }
        }

    private val usbReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (ActionUSBPermission == intent?.action && intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                startSearch()
            } else {
                binding.printerListRecycler.visibility = View.GONE
                binding.printerListText.text = getWarningMessage(arrayOf(getString(PrinterSearchError.USBPermissionNotGrant.getResId())))
            }
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_printer_list, container, false)
        binding.lifecycleOwner = this.viewLifecycleOwner

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = ViewModelProvider(this)[PrinterListViewModel::class.java]
        setupViews()

        arguments?.getString(KeyPrinterInterface)?.let {
            val context = context ?: return@let
            binding.printerListMessage.text = it
            viewModel.setPrinterType(it, context)
        }

        if (viewModel.printerType == Channel.ChannelType.USB) {
            activity?.apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    registerReceiver(usbReceiver, IntentFilter(ActionUSBPermission), Context.RECEIVER_EXPORTED)
                } else {
                    registerReceiver(usbReceiver, IntentFilter(ActionUSBPermission))
                }
            }
        }

        startSearch()
    }

    override fun onDestroy() {
        super.onDestroy()
        viewModel.stopSearch()
        if (viewModel.printerType == Channel.ChannelType.USB) {
            activity?.apply {
                unregisterReceiver(usbReceiver)
            }
        }
    }

    private fun setupViews() {
        val context = this.context ?: return

        binding.toolbar.setNavigationOnClickListener {
            findNavController().popBackStack()
        }

        binding.printerListRecycler.layoutManager = LinearLayoutManager(context)
        binding.printerListRecycler.addItemDecoration(RecyclerViewDivider())
        binding.printerListRecycler.adapter = PrinterListRecyclerAdapter(
            context,
            viewModel.printerList,
            ::onItemSelected
        )

        binding.printerListRefreshLayout.setOnRefreshListener {
            startSearch()
            binding.printerListRefreshLayout.isRefreshing = false
        }

        binding.refreshImageButton.setOnClickListener {
            startSearch()
        }
    }

    private fun onItemSelected(info: DiscoveredPrinterInfo) {
        val controller = findNavController()
        with(controller) {
            val exam = {
                val dstFragmentId = arguments?.getInt(KeyDstFragmentId, -1) ?: -1
                if (dstFragmentId != -1) {
                    popBackStack(dstFragmentId, false)
                } else {
                    // back to previous fragment
                    popBackStack()
                }
                PrintDemoApp.instance.currentSelectedPrinter = info
                currentBackStackEntry?.savedStateHandle?.set(KeyPrinterInfo, info)
            }

            val candidateList = info.getListOfWhatPrinterModel()
            if (candidateList.size >= 2) {
                val defaultIndex = 0
                info.determinedModel = candidateList[defaultIndex]
                val selectTexts = candidateList.map {model -> model.name}
                android.app.AlertDialog.Builder(context)
                    .setTitle(context.getString(R.string.determine_model))
                    .setSingleChoiceItems(selectTexts.toTypedArray(), defaultIndex) { _, index ->
                        info.determinedModel = candidateList[index]
                    }.setPositiveButton(context.getString(R.string.button_ok)) { _, _ ->
                        exam()
                    }.show()
            }
            else {
                info.determinedModel = candidateList.firstOrNull()
                exam()
            }
        }
    }

    private fun startSearch() {

        if (waitingDialog?.isShowing == true || cancelDialog?.isShowing == true) {
            return
        }

        val result = checkPermission()
        if (!result.first) {
            binding.printerListRecycler.visibility = View.GONE
            binding.printerListText.text = getWarningMessage(result.second)
            return
        }

        context?.apply {
            waitingDialog = CommonDialog.waitingDialog(this, this.getString(R.string.waiting)) {
                cancelDialog = CommonDialog.cancelingDialog(this)
                cancelDialog?.show()
                viewModel.cancelSearching()
            }
            waitingDialog?.show()
            binding.printerListRecycler.visibility = View.VISIBLE

            viewModel.search(this) { error, sdkError ->
                error?.let {
                    if (it != PrinterSearchError.None || viewModel.printerList.isEmpty()) {
                        waitingDialog?.dismiss()
                        cancelDialog?.dismiss()
                        binding.printerListRecycler.visibility = View.GONE
                        binding.printerListText.text = this.getString(it.getResId())
                    } else {
                        binding.printerListRecycler.visibility = View.VISIBLE
                        binding.printerListRecycler.adapter?.notifyDataSetChanged()
                    }
                }

                sdkError?.let {
                    waitingDialog?.dismiss()
                    cancelDialog?.dismiss()
                    if (it != com.brother.sdk.lmprinter.PrinterSearchError.ErrorCode.NoError) {
                        Toast.makeText(this, it.name, Toast.LENGTH_LONG).show()
                    }
                }
            }

            binding.printerListRecycler.adapter?.notifyDataSetChanged()
        }
    }

    private fun checkPermission(): Pair<Boolean, Array<String>> {
        val context = this.context ?: return Pair(false, arrayOf())
        if (viewModel.printerType == Channel.ChannelType.Bluetooth) {
            return checkBluetoothPermission(context)
        }

        if (viewModel.printerType == Channel.ChannelType.BluetoothLowEnergy) {
            return checkBLEPermission(context)
        }

        return Pair(true, arrayOf())
    }

    private fun checkBluetoothPermission(context: Context): Pair<Boolean, Array<String>> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return requestPermission(
                context,
                Manifest.permission.BLUETOOTH_CONNECT,
                arrayOf(Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN)
            )
        }

        return Pair(true, arrayOf())
    }

    private fun checkBLEPermission(context: Context): Pair<Boolean, Array<String>> {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return requestPermission(
                context,
                Manifest.permission.BLUETOOTH_CONNECT,
                arrayOf(Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN)
            )
        }

        // Location Service must be enabled before request permission: ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION
        if (!LocationUtils.isEnabledLocationService(context)) {
            return Pair(false, arrayOf("Location Service is not enabled"))
        }

        val result = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            requestPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
            )
        } else {
            requestPermission(
                context,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION)
            )
        }

        if (!result.first) {
            return result
        }

        return Pair(true, arrayOf())
    }

    private fun requestPermission(
        context: Context,
        checkPermission: String,
        requestPermissions: Array<String>
    ): Pair<Boolean, Array<String>> {
        return when {
            ContextCompat.checkSelfPermission(context, checkPermission) == PackageManager.PERMISSION_GRANTED -> {
                Pair(true, arrayOf())
            }
            shouldShowRequestPermissionRationale(checkPermission) -> {
                Pair(false, requestPermissions)
            }
            else -> {
                requestPermissionLauncher.launch(requestPermissions)
                Pair(false, requestPermissions)
            }
        }
    }

    private fun getWarningMessage(permissions: Array<String>): String {
        var str = this.getString(R.string.no_permission)
        permissions.forEach {
            str += "\n$it"
        }

        return str
    }
}

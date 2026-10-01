package com.brother.ptouch.sdk.printdemo.ui

import android.content.Context
import android.os.Bundle
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
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo
import com.brother.ptouch.sdk.printdemo.model.PrinterConnectUtil
import com.brother.ptouch.sdk.printdemo.model.TransitionUtils
import com.brother.ptouch.sdk.printdemo.ui.adapters.SimpleData
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorFragment
import com.brother.ptouch.sdk.printdemo.ui.components.SelectorWithSearchFragment
import com.brother.sdk.lmprinter.OpenChannelError
import com.brother.sdk.lmprinter.PrinterDriverGenerator
import com.brother.sdk.lmprinter.RequestPrinterInfoResult
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class PrinterInfoFragment : Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_container, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupView()
        setupEvents()
    }

    private suspend fun startRequestPrinterInfo(buttonCaption: String, context: Context, currentPrinter: DiscoveredPrinterInfo) {
        when (buttonCaption) {
            context.getString(R.string.request_firm_version) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestMainFirmVersion()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_serial_number) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestSerialNumber()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.get_status) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val driverResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (driverResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(driverResult.error.code.toString())
                    return
                }
                val driver = driverResult.driver
                val error = driver.printerStatus
                driver.closeChannel()
                showResult(getStatusDetail(error.printerStatus))

            }
            context.getString(R.string.request_system_report) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestSystemReport()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_media_version) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestMediaVersion()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_battery) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestBatteryInfo()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_template_info_list) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestTemplateInfoList()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_bluetooth_firm_version) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestBluetoothFirmVersion()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_internal_model_flag) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestInternalModelFlag()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
            context.getString(R.string.request_is_boot_mode) -> {
                val channel = PrinterConnectUtil.getCurrentChannel(context, currentPrinter)
                val channelCredential = PrinterConnectUtil.getCurrentChannelCredential( currentPrinter)
                val generateResult = PrinterConnectUtil.generatePrinterDriver(channel, channelCredential)
                if (generateResult.error.code != OpenChannelError.ErrorCode.NoError) {
                    showResult(generateResult.error.toString())
                    return
                }
                val driver = generateResult.driver
                val result = driver.requestIsBootMode()
                driver.closeChannel()
                showResult(getResultString(context, result))

            }
        }
    }

    private fun setupView() {
        val context = context ?: return

        val bundle = Bundle().apply {
            putInt(SelectorFragment.KeyTitleId, R.string.printer_info)
            putParcelableArrayList(
                SelectorFragment.KeyButtonMenuList,
                ArrayList(mutableListOf(
                    SimpleData(true, context.getString(R.string.official_api)),
                    SimpleData(false, context.getString(R.string.request_firm_version)),
                    SimpleData(false, context.getString(R.string.request_serial_number)),
                    SimpleData(false, context.getString(R.string.get_status)),
                    SimpleData(false, context.getString(R.string.request_system_report)),
                    SimpleData(false, context.getString(R.string.request_media_version)),
                    SimpleData(false, context.getString(R.string.request_battery)),
                    SimpleData(false, context.getString(R.string.request_template_info_list)),
                    SimpleData(true, context.getString(R.string.brother_api)),
                    SimpleData(false, context.getString(R.string.request_bluetooth_firm_version)),
                    SimpleData(false, context.getString(R.string.request_internal_model_flag)),
                    SimpleData(false, context.getString(R.string.request_is_boot_mode)),
                ))
            )
        }

        val fragment = SelectorWithSearchFragment().apply {
            arguments = bundle
        }

        childFragmentManager.beginTransaction().replace(R.id.container, fragment).commit()
    }

    private fun setupEvents() {
        val handle = findNavController().currentBackStackEntry?.savedStateHandle
        handle?.remove<SimpleData>(SelectorFragment.KeySelectedButtonMenu)
        handle?.getLiveData<SimpleData>(SelectorFragment.KeySelectedButtonMenu)?.observe(viewLifecycleOwner) {
            val context = context ?: return@observe

            val currentPrinter = PrintDemoApp.instance.currentSelectedPrinter
            if (currentPrinter == null) {
                Toast.makeText(context, R.string.select_printer_message, Toast.LENGTH_SHORT).show()
                return@observe
            }

            val waitingDialog = TransitionUtils.showWaitingDialog(context)

            lifecycleScope.launch(Dispatchers.Default) {
                startRequestPrinterInfo(it.info, context, currentPrinter)
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

    private fun <T> getResultString(context: Context, ret : RequestPrinterInfoResult<T>) : String {
        return context.getString((R.string.result)) + " : " + ret.error.code.toString() + "\r\n" + context.getString((R.string.value)) + " : " + ret.printerInfo.toString() + "\r\n" + "\r\n" + ret.error.allLogs.joinToString("\r\n")
    }
    private fun getStatusDetail(status: com.brother.sdk.lmprinter.PrinterStatus): String {
        val error = "Error: " + status.errorCode.name + "\n"
        val model = "Model: " + status.model.name + "\n"
        val mediaType = "MediaInfo.MediaType: " + (status.mediaInfo?.mediaType?.name ?: "none") + "\n"
        val mediaBackgroundColor = "MediaInfo.BackgroundColor: " + (status.mediaInfo?.backgroundColor?.name ?: "none") + "\n"
        val mediaInkColor = "MediaInfo.InkColor: " + (status.mediaInfo?.inkColor?.name ?: "none") + "\n"
        val mediaWidth = "MediaInfo.Width: " + (status.mediaInfo?.width_mm?.toString() ?: "none") + "\n"
        val mediaHeight = "MediaInfo.Height: " + (status.mediaInfo?.height_mm?.toString() ?: "none") + "\n"
        val mediaIsHeightInfinite = "MediaInfo.IsHeightInfinite: " + (status.mediaInfo?.isHeightInfinite?.toString() ?: "none") + "\n"
        val mediaQLLabelSize = "MediaInfo.QLLabelSize: " + (status.mediaInfo?.qlLabelSize?.toString() ?: "none") + "\n"
        val mediaPTLabelSize = "MediaInfo.PTLabelSize: " + (status.mediaInfo?.ptLabelSize?.toString() ?: "none") + "\n"
        val mediaInfo = if (status.mediaInfo == null) {
            "MediaInfo: none\n"
        } else {
            mediaType + mediaBackgroundColor + mediaInkColor + mediaWidth +
                    mediaHeight + mediaIsHeightInfinite + mediaQLLabelSize + mediaPTLabelSize
        }
        val batteryInfo = "BatteryMounted: " + (status.batteryStatus?.batteryMounted?.name ?: "") + "\n" +
                "Charging: " + (status.batteryStatus?.charging?.name ?: "") + "\n" +
                "ChargingLevel(current/max): " + (status.batteryStatus?.chargeLevel?.current ?: "") + "/" +
                (status.batteryStatus?.chargeLevel?.max ?: "")
        return model + error + mediaInfo + batteryInfo

    }
}

package com.brother.ptouch.sdk.printdemo.model.printersearch

import com.brother.ptouch.sdk.printdemo.R

enum class PrinterSearchError {
    None,
    WiFiOff,
    WiFiNotConnect,
    BluetoothOff,
    USBPermissionNotGrant;

    fun getResId(): Int {
        return when (this) {
            None -> R.string.not_find_data
            WiFiOff -> R.string.wifi_off
            WiFiNotConnect -> R.string.wifi_not_connect
            BluetoothOff -> R.string.bluetooth_off
            USBPermissionNotGrant -> R.string.usb_permission
        }
    }
}

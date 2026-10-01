package com.brother.ptouch.sdk.printdemo

import android.app.Application
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo

class PrintDemoApp : Application() {
    companion object {
        lateinit var instance: PrintDemoApp
            private set
    }

    var currentSelectedPrinter: DiscoveredPrinterInfo? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
    }
}

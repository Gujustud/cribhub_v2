package com.brother.ptouch.sdk.printdemo.model

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager

object NetworkUtils {
    fun isWiFiOn(context: Context): Boolean {
        // require permission：ACCESS_WIFI_STATE
        val manger = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
        return manger.wifiState == WifiManager.WIFI_STATE_ENABLED
    }

    fun isWiFiConnected(context: Context): Boolean {
        // require permission：ACCESS_NETWORK_STATE
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)?.run {
            return this.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
        }

        return false
    }
}

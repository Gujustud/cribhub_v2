package com.brother.ptouch.sdk.printdemo.model

import android.content.Context
import android.location.LocationManager
import android.os.Build

object LocationUtils {
    fun isEnabledLocationService(context: Context): Boolean {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            locationManager.isLocationEnabled
        } else {
            locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||  locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        }
    }
}

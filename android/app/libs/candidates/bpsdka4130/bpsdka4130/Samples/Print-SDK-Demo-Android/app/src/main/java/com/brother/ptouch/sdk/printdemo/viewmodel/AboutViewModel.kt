package com.brother.ptouch.sdk.printdemo.viewmodel

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.lifecycle.ViewModel
import com.brother.ptouch.sdk.printdemo.R

class AboutViewModel : ViewModel() {
    @Suppress("DEPRECATION")
    fun getVersionCode(context: Context): String {
        val packageManager = context.packageManager
        val packageInfo = kotlin.runCatching {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                packageManager.getPackageInfo(context.packageName, PackageManager.PackageInfoFlags.of(0))
            } else {
                packageManager.getPackageInfo(context.packageName, 0)
            }
        }.getOrNull() ?: return ""
        val sdkVersion = "4.13.0(589)"
        val longVersionCode = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            packageInfo.versionCode.toString()
        } else {
            packageInfo.longVersionCode.toString()
        }
        return context.getString(R.string.app_version) + packageInfo.versionName + "(" + longVersionCode +
                ")\n" + context.getString(R.string.sdk_version) + sdkVersion
    }
}

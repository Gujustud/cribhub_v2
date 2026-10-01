package com.brother.ptouch.sdk.printdemo.model

object StringUtils {
    fun String.safeToInt(): Int {
        try {
            return this.toInt()
        }
        catch (e: Throwable) {
            return 0
        }
    }

    fun String.safeToFloat(): Float {
        try {
            return this.toFloat()
        }
        catch (e: Throwable) {
            return 0.0f
        }
    }
}

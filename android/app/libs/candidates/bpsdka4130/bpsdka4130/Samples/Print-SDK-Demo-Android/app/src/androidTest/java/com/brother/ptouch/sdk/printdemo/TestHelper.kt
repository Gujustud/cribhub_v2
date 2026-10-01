package com.brother.ptouch.sdk.printdemo

import androidx.test.platform.app.InstrumentationRegistry
import java.io.File
import java.lang.reflect.Field
import java.lang.reflect.Method

object TestHelper {
    fun getDeclaredMethod(reflectClass: Class<*>, declaredMethodName: String, typeClass: Class<*>): Method {
        val declaredMethod = reflectClass.getDeclaredMethod(declaredMethodName, typeClass)
        declaredMethod.isAccessible = true
        return declaredMethod
    }

    fun getDeclaredField(reflectClass: Class<*>, declaredFileName: String): Field {
        val declaredField = reflectClass.getDeclaredField(declaredFileName)
        declaredField.isAccessible = true
        return declaredField
    }

    fun copyAssetFile(
        srcFileName: String,
        destPath: String
    ): String {
        val applicationContext = InstrumentationRegistry.getInstrumentation().context
        val tempFile = File(destPath)
        tempFile.parentFile?.mkdirs()
        tempFile.outputStream().use { fos ->
            applicationContext.assets.open(srcFileName).use {
                it.copyTo(fos)
            }
        }
        return destPath
    }
}

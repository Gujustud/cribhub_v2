package com.brother.ptouch.sdk.printdemo.model

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.util.Date

@Parcelize
class TemplateData(
        val key: Int,
        val name: String,
        val fileSize: Int,
        val modifiedDate: Date,
) : Parcelable

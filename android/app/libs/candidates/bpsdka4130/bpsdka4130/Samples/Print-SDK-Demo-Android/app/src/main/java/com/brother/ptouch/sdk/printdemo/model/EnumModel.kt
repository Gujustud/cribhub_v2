package com.brother.ptouch.sdk.printdemo.model

import android.os.Parcelable
import kotlinx.parcelize.IgnoredOnParcel
import kotlinx.parcelize.Parcelize

interface EnumDesc : Parcelable {
    var desc: String
}

@Parcelize
enum class TemplateEncoding(val stringValue: String?) : EnumDesc {
    UTF_8(null), JPN_SHIFT_JIS("SJIS"), CHN_GB_18030_2000("GB18030");


    @IgnoredOnParcel
    override var desc: String = this.name
}

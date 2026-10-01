package com.brother.ptouch.sdk.printdemo.model

import android.os.Parcelable
import com.brother.sdk.lmprinter.TemplateObjectReplacer
import kotlinx.parcelize.Parcelize

interface IPrintData {
    // TODO
}

@Parcelize
class ImagePrintData(
    var dataType: ImagePrnType,
    var imagePrnData: ArrayList<String>
) : IPrintData, Parcelable

@Parcelize
class PdfPrintData(
    val type: PDFPrintType,
    var pages: ArrayList<Int>,
    var pdfData: ArrayList<String>
) : IPrintData, Parcelable

@Parcelize
class TemplatePrintData(
        var key: Int?,
        var encoding: TemplateEncoding = TemplateEncoding.UTF_8,
        var type: TemplateEditType,
        var itemList: ArrayList<HashMap<String, String>>,
        var replacer: ArrayList<TemplateObjectReplacer>,
        var modelName: String?,
        var copies: Int,
        var peel: Boolean
) : IPrintData, Parcelable

enum class ImagePrnType {
    ImageFile, ImageFiles, BitmapData, Closures
}

enum class PDFPrintType {
    File, Files, Pages
}

enum class TemplateEditType {
    Index,
    ObjectName,
    NoText
}

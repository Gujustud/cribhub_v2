package com.brother.ptouch.sdk.printdemo.ui.dialog

import android.content.Context
import android.content.DialogInterface
import android.text.InputFilter
import android.text.InputType
import android.view.LayoutInflater
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import com.brother.ptouch.sdk.printdemo.R
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.textfield.TextInputEditText
import kotlin.reflect.KClass
import kotlin.reflect.full.isSubclassOf

object CommonDialog {
    fun waitingDialog(context: Context, title: String, callBack: () -> Unit): AlertDialog {
        val progressView = ProgressBar(context)
        return MaterialAlertDialogBuilder(context)
            .setMessage(title)
            .setView(progressView)
            .setCancelable(false)
            .setNegativeButton(android.R.string.cancel) { _, _ ->
                callBack()
            }.create()
    }

    fun cancelingDialog(context: Context): AlertDialog {
        val progressView = ProgressBar(context)
        return MaterialAlertDialogBuilder(context)
            .setMessage(context.getString(R.string.canceling))
            .setView(progressView)
            .setCancelable(false)
            .create()
    }

    fun showNumberEditDialog(context: Context, title: String, message: String, positiveDidTap: (String) -> Unit) {
        val inflater = LayoutInflater.from(context)
        val editTextView = inflater.inflate(R.layout.input_dialog_number, null)
        val editText = editTextView.findViewById<TextInputEditText>(R.id.text_input_view)
        editText.setText(message)
        MaterialAlertDialogBuilder(context)
            .setTitle(title)
            .setView(editTextView)
            .setPositiveButton(android.R.string.ok) { _, _ ->
                positiveDidTap(editText.text.toString())
            }
            .show()
    }

    fun showEditDialog(context: Context, title: String, message: String, maxLength: Int?, positiveDidTap: (String) -> Unit) {
        val inflater = LayoutInflater.from(context)
        val editTextView = inflater.inflate(R.layout.input_dialog_number, null)
        val editText = editTextView.findViewById<TextInputEditText>(R.id.text_input_view)
        editText.inputType = InputType.TYPE_CLASS_TEXT
        maxLength?.let {
            editText.filters = arrayOf(InputFilter.LengthFilter(it))
        }
        editText.setText(message)
        MaterialAlertDialogBuilder(context)
            .setTitle(title)
            .setView(editTextView)
            .setPositiveButton(android.R.string.ok) { _, _ ->
                positiveDidTap(editText.text.toString())
            }
            .show()
    }

    fun showSingleSelectDialog(context: Context, title: String, itemList: Array<String>, positiveDidTap: (String) -> Unit) {
        MaterialAlertDialogBuilder(context)
            .setTitle(title)
            .setItems(itemList) { _: DialogInterface?, which: Int ->
                positiveDidTap(itemList[which])
            }
            .show()
    }

    fun showErrorDialog(context: Context, title: String, message: String) {
        MaterialAlertDialogBuilder(context)
            .setTitle(title)
            .setMessage(message)
            .setNegativeButton(android.R.string.ok) { _, _ ->
            }
            .create()
            .show()
    }

    fun showEnumSelectDialog(context: Context, title: String, clazz: KClass<*>, positiveDidTap: (Enum<*>) -> Unit) {
        val enumList = clazz.java.enumConstants as Array<*>
        val array = enumList.map{it.toString()}.toTypedArray()
        showSingleSelectDialog(context, title, array) { selectedString ->
            positiveDidTap(enumList[array.indexOf(selectedString)] as Enum<*>)
        }
    }

    fun showAnyEditDialog(context: Context, title: String, clazz: KClass<*>, value: Any?, positiveDidTap: (Any?) -> Unit) {
        when {
            clazz.isSubclassOf(Enum::class) -> {
                showEnumSelectDialog(context, title, clazz) {
                    positiveDidTap(it)
                }
            }
            clazz == String::class -> {
                showEditDialog(context, title, value.toString(), null) {
                    positiveDidTap(it)
                }
            }
            clazz.isSubclassOf(Number::class) -> {
                showNumberEditDialog(context, title, value.toString()) {
                    positiveDidTap(it)
                }
            }
            clazz == Boolean::class -> {
                showSingleSelectDialog(context, title, arrayOf(true.toString(),false.toString())) { selectedString ->
                    positiveDidTap((selectedString == true.toString()))
                }
            }
            else -> {
                showErrorDialog(context, "Not Implemented", title)
            }
        }
    }

    fun progressDialog(context: Context, title: String): Triple<AlertDialog, ProgressBar, TextView> {
        val inflater = LayoutInflater.from(context)
        val dialogView = inflater.inflate(R.layout.dialog_progress_bar, null)
        val progressBar = dialogView.findViewById<ProgressBar>(R.id.progressBar)
        val progressText = dialogView.findViewById<TextView>(R.id.progressText)
        progressText.text = title
        progressBar.max = 100
        return Triple(MaterialAlertDialogBuilder(context)
            .setView(dialogView)
            .setCancelable(false)
            .create(), progressBar, progressText)
    }
}

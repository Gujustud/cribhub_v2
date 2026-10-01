package com.brother.ptouch.sdk.printdemo.ui.adapters

import android.content.Context
import android.view.Gravity
import android.view.LayoutInflater
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams
import android.widget.LinearLayout
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.ItemTitleWithMessageBinding
import com.brother.ptouch.sdk.printdemo.model.printsettings.PrintSettingsItemType
import com.brother.sdk.lmprinter.setting.CustomPaperSize
import com.brother.sdk.lmprinter.setting.PJPaperSize

class TitleWithMessageRecyclerAdapter(
    val context: Context,
    private var data: MutableMap<PrintSettingsItemType, Any>,
    private val onItemSelected: (PrintSettingsItemType, Any) -> Unit,
    private val gravity: Int = Gravity.START
) : RecyclerView.Adapter<TitleWithMessageRecyclerAdapter.TitleWithMessageViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TitleWithMessageViewHolder {
        val binding: ItemTitleWithMessageBinding =
            DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.item_title_with_message, parent, false)

        // set layout_gravity of textview
        val params = LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        params.gravity = gravity
        binding.titleTextView.layoutParams = params
        binding.messageTextView.layoutParams = params

        return TitleWithMessageViewHolder(binding)
    }

    override fun onBindViewHolder(holder: TitleWithMessageViewHolder, position: Int) {
        val key = data.keys.toMutableList().getOrNull(position) ?: return
        val message = data.values.toMutableList().getOrNull(position) ?: return
        when (message) {
            is CustomPaperSize -> {
                holder.binding.messageTextView.text = message.paperKind.name
            }
            is PJPaperSize -> {
                holder.binding.messageTextView.text = message.paperSize.name
            }
            else -> {
                holder.binding.messageTextView.text = message.toString()
            }
        }
        holder.binding.titleTextView.text = context.getString(key.stringId)
        holder.binding.itemRoot.setOnClickListener {
            when (message) {
                is CustomPaperSize -> {
                    onItemSelected(key, message.paperKind.name)
                }
                is PJPaperSize -> {
                    onItemSelected(key, message.paperSize.name)
                }
                else -> {
                    onItemSelected(key, message)
                }
            }
        }
    }

    override fun getItemCount(): Int {
        return data.size
    }

    class TitleWithMessageViewHolder(val binding: ItemTitleWithMessageBinding) : RecyclerView.ViewHolder(binding.root)
}

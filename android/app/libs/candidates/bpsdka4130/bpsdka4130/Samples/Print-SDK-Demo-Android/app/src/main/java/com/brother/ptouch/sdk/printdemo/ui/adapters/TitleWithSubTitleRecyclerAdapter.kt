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

class TitleWithSubTitleRecyclerAdapter(
    val context: Context,
    private var dataSource: MutableMap<String, Any?>,
    private val onItemSelected: (String, Any?) -> Unit,
    private val gravity: Int = Gravity.START
) : RecyclerView.Adapter<TitleWithSubTitleRecyclerAdapter.TitleWithSubTitleViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TitleWithSubTitleViewHolder {
        val binding: ItemTitleWithMessageBinding =
            DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.item_title_with_message, parent, false)

        // set layout_gravity of textview
        val params = LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        params.gravity = gravity
        binding.titleTextView.layoutParams = params
        binding.messageTextView.layoutParams = params

        return TitleWithSubTitleViewHolder(binding)
    }

    override fun onBindViewHolder(holder: TitleWithSubTitleViewHolder, position: Int) {
        val key = dataSource.keys.toMutableList().getOrNull(position) ?: return
        val value = dataSource.values.toMutableList().getOrNull(position)
        holder.binding.messageTextView.text = value.toString()
        holder.binding.titleTextView.text = key
        holder.binding.itemRoot.setOnClickListener {
            onItemSelected(key, value)
        }
    }

    override fun getItemCount(): Int {
        return dataSource.size
    }

    class TitleWithSubTitleViewHolder(val binding: ItemTitleWithMessageBinding) : RecyclerView.ViewHolder(binding.root)
}

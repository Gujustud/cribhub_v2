package com.brother.ptouch.sdk.printdemo.ui.adapters

import android.content.Context
import android.view.Gravity
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.LinearLayout
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.ItemTitleWithMessageBinding

class KeyAndValueRecyclerAdapter(
    val context: Context,
    private var key: List<String>,
    private var value: List<String>,
    private val gravity: Int = Gravity.START
) : RecyclerView.Adapter<KeyAndValueRecyclerAdapter.KeyAndValueViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): KeyAndValueViewHolder {
        val binding: ItemTitleWithMessageBinding =
            DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.item_title_with_message, parent, false)

        // set layout_gravity of textview
        val params = LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
        params.gravity = gravity
        binding.titleTextView.layoutParams = params
        binding.messageTextView.layoutParams = params

        return KeyAndValueViewHolder(binding)
    }

    override fun onBindViewHolder(holder: KeyAndValueViewHolder, position: Int) {
        val keyData = key.getOrNull(position) ?: return
        val message = value.getOrNull(position) ?: return
        holder.binding.messageTextView.text = message
        holder.binding.titleTextView.text = keyData
    }

    override fun getItemCount(): Int {
        return key.size
    }

    class KeyAndValueViewHolder(val binding: ItemTitleWithMessageBinding) : RecyclerView.ViewHolder(binding.root)
}

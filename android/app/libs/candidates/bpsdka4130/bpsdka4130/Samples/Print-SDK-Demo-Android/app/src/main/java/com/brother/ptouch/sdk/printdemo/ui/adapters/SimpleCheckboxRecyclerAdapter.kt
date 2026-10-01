package com.brother.ptouch.sdk.printdemo.ui.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.ItemRecyclerConfigItemBinding

data class SimpleCheckboxData(var isChecked: Boolean, val info: String)

class SimpleCheckboxRecyclerAdapter(
    private val context: Context,
    private val data: List<SimpleCheckboxData>
) : RecyclerView.Adapter<SimpleCheckboxRecyclerAdapter.SimpleCheckboxViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SimpleCheckboxViewHolder {
        val binding: ItemRecyclerConfigItemBinding =
            DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.item_recycler_config_item, parent, false)

        return SimpleCheckboxViewHolder(binding)
    }

    override fun onBindViewHolder(holder: SimpleCheckboxViewHolder, position: Int) {
        val info = data.getOrNull(position) ?: return
        holder.binding.simpleTextView.text = info.info
        holder.binding.simpleCheckbox.isChecked = info.isChecked

        holder.binding.printerConfigItemRoot.setOnClickListener {
            holder.binding.simpleCheckbox.isChecked = !holder.binding.simpleCheckbox.isChecked
            info.isChecked = holder.binding.simpleCheckbox.isChecked
        }

        return
    }

    override fun getItemCount(): Int {
        return data.size
    }

    class SimpleCheckboxViewHolder(val binding: ItemRecyclerConfigItemBinding) : RecyclerView.ViewHolder(binding.root)
}

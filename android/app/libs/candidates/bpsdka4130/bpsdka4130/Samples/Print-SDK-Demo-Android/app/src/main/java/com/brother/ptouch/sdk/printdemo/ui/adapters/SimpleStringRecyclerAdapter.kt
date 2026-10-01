package com.brother.ptouch.sdk.printdemo.ui.adapters

import android.content.Context
import android.view.Gravity
import android.view.LayoutInflater
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams
import android.widget.FrameLayout
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.ItemSimpleStringBinding

class SimpleStringRecyclerAdapter(
    val context: Context,
    private var data: List<String>,
    private val onItemSelected: (String) -> Unit,
    private val gravity: Int = Gravity.START
) : RecyclerView.Adapter<SimpleStringRecyclerAdapter.SimpleStringViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SimpleStringViewHolder {
        val binding: ItemSimpleStringBinding =
            DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.item_simple_string, parent, false)

        // set layout_gravity of textview
        val params = FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        params.gravity = gravity
        binding.simpleTextView.layoutParams = params

        return SimpleStringViewHolder(binding)
    }

    override fun onBindViewHolder(holder: SimpleStringViewHolder, position: Int) {
        val info = data.getOrNull(position) ?: return
        holder.binding.simpleTextView.text = info
        holder.binding.simpleRoot.setOnClickListener {
            onItemSelected(info)
        }
    }

    override fun getItemCount(): Int {
        return data.size
    }

    class SimpleStringViewHolder(val binding: ItemSimpleStringBinding) : RecyclerView.ViewHolder(binding.root)
}

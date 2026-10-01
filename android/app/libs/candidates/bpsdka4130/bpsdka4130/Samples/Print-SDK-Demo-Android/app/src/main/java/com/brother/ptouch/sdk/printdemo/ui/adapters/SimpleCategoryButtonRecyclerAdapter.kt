package com.brother.ptouch.sdk.printdemo.ui.adapters

import android.content.Context
import android.os.Parcelable
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.ItemRecyclerCategoryBinding
import com.brother.ptouch.sdk.printdemo.databinding.ItemRecyclerItemBinding
import kotlinx.parcelize.Parcelize

@Parcelize
data class SimpleData(val isCategory: Boolean, val info: String) : Parcelable

class SimpleCategoryButtonRecyclerAdapter(
    private val context: Context,
    private val data: List<SimpleData>,
    private val onItemSelected: (SimpleData) -> Unit
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    companion object {
        private const val TypeCategory = 0
        private const val TypeItem = 1
    }

    override fun getItemViewType(position: Int): Int {
        val info = data.getOrNull(position)
        return if (info?.isCategory == true) TypeCategory else TypeItem
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val inflater = LayoutInflater.from(context)

        return if (viewType == TypeCategory) {
            CategoryViewHolder(DataBindingUtil.inflate(inflater, R.layout.item_recycler_category, parent, false))
        } else {
            ItemViewHolder(DataBindingUtil.inflate(inflater, R.layout.item_recycler_item, parent, false))
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val info = data.getOrNull(position) ?: return
        if (holder is CategoryViewHolder) {
            holder.binding.menuCategoryTitle.text = info.info
            return
        }

        if (holder is ItemViewHolder) {
            holder.binding.menuItemButton.text = info.info
            holder.binding.menuItemButton.setOnClickListener {
                onItemSelected(info)
            }
        }
    }

    override fun getItemCount(): Int {
        return data.size
    }

    class CategoryViewHolder(val binding: ItemRecyclerCategoryBinding) : RecyclerView.ViewHolder(binding.root)
    class ItemViewHolder(val binding: ItemRecyclerItemBinding) : RecyclerView.ViewHolder(binding.root)
}

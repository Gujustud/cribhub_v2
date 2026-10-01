package com.brother.ptouch.sdk.printdemo.ui.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.databinding.ItemPrinterListBinding
import com.brother.ptouch.sdk.printdemo.model.DiscoveredPrinterInfo

class PrinterListRecyclerAdapter(
        val context: Context,
        private var data: List<DiscoveredPrinterInfo>,
        private val onItemSelected: (DiscoveredPrinterInfo) -> Unit
) : RecyclerView.Adapter<PrinterListRecyclerAdapter.PrinterListRecyclerViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PrinterListRecyclerViewHolder {
        val binding: ItemPrinterListBinding =
            DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.item_printer_list, parent, false)

        return PrinterListRecyclerViewHolder(binding)
    }

    override fun onBindViewHolder(holder: PrinterListRecyclerViewHolder, position: Int) {
        val info = data.getOrNull(position) ?: return
        holder.binding.printerItemRoot.setOnClickListener {
            onItemSelected.invoke(info)
        }
        holder.binding.printerItemMain.text = info.modelName

        holder.binding.printerItemSub.text = "channelInfo: " + info.channelInfo + "\n" + info.extraInfo.entries.joinToString (separator = "\n") { "${it.key.name}: ${it.value}" }

    }

    override fun getItemCount(): Int {
        return data.size
    }

    class PrinterListRecyclerViewHolder(var binding: ItemPrinterListBinding) : RecyclerView.ViewHolder(binding.root)
}

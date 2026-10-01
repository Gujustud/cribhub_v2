package com.brother.ptouch.sdk.printdemo.ui.components

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class RecyclerViewDivider : RecyclerView.ItemDecoration() {
    private val dividerHeight = 1
    private val dividerColor = Color.LTGRAY
    private val paint: Paint = Paint().apply {
        color = dividerColor
        strokeWidth = dividerHeight.toFloat()
        style = Paint.Style.STROKE
        isAntiAlias = true
    }

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        super.getItemOffsets(outRect, view, parent, state)

        val position: Int = parent.getChildAdapterPosition(view)
        view.tag = position

        val manager = parent.layoutManager
        // only for vertical linearLayout
        if (manager is LinearLayoutManager && position != 0 && manager.orientation == LinearLayoutManager.VERTICAL) {
            outRect.top = dividerHeight
        }
    }

    override fun onDraw(c: Canvas, parent: RecyclerView, state: RecyclerView.State) {
        super.onDraw(c, parent, state)
        val count: Int = parent.childCount
        val left: Int = parent.paddingLeft
        val right: Int = parent.measuredWidth - parent.paddingRight

        val manager = parent.layoutManager
        if (manager is LinearLayoutManager && manager.orientation == LinearLayoutManager.VERTICAL) {
            for (index in 0 until count) {
                val view: View = parent.getChildAt(index)
                val layoutParams = view.layoutParams as RecyclerView.LayoutParams
                val top = view.bottom + layoutParams.bottomMargin
                val bottom: Int = top + dividerHeight
                c.drawLine(left.toFloat(), top.toFloat(), right.toFloat(), bottom.toFloat(), paint)
            }
        }
    }
}

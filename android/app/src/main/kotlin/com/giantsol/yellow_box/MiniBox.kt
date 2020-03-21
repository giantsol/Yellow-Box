package com.giantsol.yellow_box

import android.content.Context
import android.graphics.PixelFormat
import android.graphics.Point
import android.os.Build
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager

class MiniBox(private val context: Context) {

    private val wm: WindowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val miniBoxView: View = LayoutInflater.from(context).inflate(R.layout.view_mini_box, null)
    private val windowSize = Point().apply { wm.defaultDisplay.getSize(this) }

    init {
        val miniBoxViewSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 48f, context.resources.displayMetrics).toInt()
        val rightInset = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 4f, context.resources.displayMetrics).toInt()
        val lp = getWindowParams(miniBoxViewSize, miniBoxViewSize)
        lp.x = windowSize.x - miniBoxViewSize + rightInset
        lp.y = (windowSize.y - miniBoxViewSize) / 2
        wm.addView(miniBoxView, lp)
    }

    private fun getWindowParams(width: Int, height: Int): WindowManager.LayoutParams {
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            WindowManager.LayoutParams.TYPE_PHONE

        return WindowManager.LayoutParams(
            width, height, type,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
        }
    }

    fun destroy() {
        wm.removeView(miniBoxView)
    }
}
package com.giantsol.yellow_box

import android.content.Context
import android.util.AttributeSet
import android.view.KeyEvent
import android.widget.FrameLayout
import android.widget.RelativeLayout

class KeyInterceptRelativeLayout : RelativeLayout {
    private var listener: OnKeyListener? = null

    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr)

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        if (listener?.onKey(this, event.keyCode, event) == true)
            return true
        return super.dispatchKeyEvent(event)
    }

    fun setKeyInterceptListener(listener: OnKeyListener) {
        this.listener = listener
    }
}
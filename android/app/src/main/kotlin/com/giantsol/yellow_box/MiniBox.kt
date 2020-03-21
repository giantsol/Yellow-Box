package com.giantsol.yellow_box

import android.content.Context
import android.graphics.PixelFormat
import android.graphics.Point
import android.os.Build
import android.util.TypedValue
import android.view.*
import kotlin.math.abs

class MiniBox(private val context: Context) {

    private val wm: WindowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

    private val bgView = LayoutInflater.from(context).inflate(R.layout.view_mini_box_bg, null)
    private val draggingView = bgView.findViewById<View>(R.id.dragging_box)
    private val closeView = bgView.findViewById<View>(R.id.close)

    private val miniBoxView = LayoutInflater.from(context).inflate(R.layout.view_mini_box, null)
    private lateinit var miniBoxViewLp: WindowManager.LayoutParams
    private val miniBoxViewSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 48f, context.resources.displayMetrics).toInt()
    private val rightInset = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 4f, context.resources.displayMetrics).toInt()

    private val windowSize = Point().apply { wm.defaultDisplay.getSize(this) }

    init {
        initBgView()
        initMiniBoxView()
    }

    private fun initBgView() {
        val lp = getWindowParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        lp.flags = lp.flags or WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        wm.addView(bgView, lp)

        draggingView.visibility = View.GONE
        closeView.visibility = View.GONE
    }

    private fun initMiniBoxView() {
        miniBoxViewLp = getWindowParams(miniBoxViewSize, miniBoxViewSize)
        miniBoxViewLp.x = windowSize.x - miniBoxViewSize + rightInset
        miniBoxViewLp.y = (windowSize.y - miniBoxViewSize) / 2
        wm.addView(miniBoxView, miniBoxViewLp)

        miniBoxView.setOnTouchListener(object: View.OnTouchListener {
            private val touchSlop = ViewConfiguration.get(context).scaledTouchSlop
            private val touchDownPoint = Point()
            private var startedDragging = false

            override fun onTouch(v: View, event: MotionEvent): Boolean {
                val eventX = event.x.toInt()
                val eventY = event.y.toInt()

                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        touchDownPoint.set(eventX, eventY)
                        startedDragging = false
                    }
                    MotionEvent.ACTION_MOVE -> {
                        val moveDiffX = eventX - touchDownPoint.x
                        val moveDiffY = eventY - touchDownPoint.y
                        if (abs(moveDiffX) + abs(moveDiffY) > touchSlop && !startedDragging) {
                            startedDragging = true
                        } else if (startedDragging) {
                            miniBoxView.visibility = View.GONE
                            draggingView.visibility = View.VISIBLE
                            closeView.visibility = View.VISIBLE
                            draggingView.x = miniBoxViewLp.x + eventX.toFloat() - touchDownPoint.x
                            draggingView.y = miniBoxViewLp.y + eventY.toFloat() - touchDownPoint.y
                        }
                    }
                    MotionEvent.ACTION_UP,
                    MotionEvent.ACTION_CANCEL -> {
                        miniBoxView.visibility = View.VISIBLE
                        draggingView.visibility = View.GONE
                        closeView.visibility = View.GONE
                    }
                }
                return false
            }
        })

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
        wm.removeView(bgView)
    }
}
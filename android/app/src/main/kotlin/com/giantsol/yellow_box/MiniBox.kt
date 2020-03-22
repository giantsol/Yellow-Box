package com.giantsol.yellow_box

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ObjectAnimator
import android.animation.PropertyValuesHolder
import android.content.Context
import android.graphics.PixelFormat
import android.graphics.Point
import android.graphics.PointF
import android.graphics.Rect
import android.os.Build
import android.util.TypedValue
import android.view.*
import android.view.animation.OvershootInterpolator
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min

class MiniBox(private val context: Context,
              private val callback: Callback) {

    interface Callback {
        fun stopMiniBox()
    }

    private val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

    private val bgView = LayoutInflater.from(context).inflate(R.layout.view_mini_box_bg, null)

    private val draggingView = bgView.findViewById<View>(R.id.dragging_box)
    private val draggingViewRect = Rect()

    private val closeView = bgView.findViewById<View>(R.id.close)
    private val closeViewRect = Rect()

    private val miniBoxView = LayoutInflater.from(context).inflate(R.layout.view_mini_box, null)
    private lateinit var miniBoxViewLp: WindowManager.LayoutParams
    private val miniBoxViewSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 48f, context.resources.displayMetrics).toInt()
    private val miniBoxViewInset = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 4f, context.resources.displayMetrics).toInt()

    private val windowSize = Point().apply { wm.defaultDisplay.getSize(this) }

    private val pvhX = PropertyValuesHolder.ofFloat("x", 0f)
    private val pvhY = PropertyValuesHolder.ofFloat("y", 0f)
    private val springBackAnimator = ObjectAnimator.ofPropertyValuesHolder(draggingView, pvhX, pvhY).apply {
        duration = 400
        interpolator = OvershootInterpolator()
    }

    private val statusBarHeight: Int

    init {
        initBgView()
        initMiniBoxView()
        initSpringBackAnimator()

        val statusResourceId = context.resources.getIdentifier("status_bar_height", "dimen", "android")
        statusBarHeight = if (statusResourceId > 0) {
            context.resources.getDimensionPixelSize(statusResourceId)
        } else {
            0
        }
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
        miniBoxViewLp.x = windowSize.x - miniBoxViewSize + miniBoxViewInset
        miniBoxViewLp.y = (windowSize.y - miniBoxViewSize - statusBarHeight) / 2
        wm.addView(miniBoxView, miniBoxViewLp)

        miniBoxView.setOnTouchListener(object: View.OnTouchListener {
            private val touchSlop = ViewConfiguration.get(context).scaledTouchSlop
            private val touchDownPoint = PointF()
            private var isDragging = false

            override fun onTouch(v: View, event: MotionEvent): Boolean {
                val eventX = event.x
                val eventY = event.y

                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        touchDownPoint.set(eventX, eventY)
                        isDragging = false
                    }
                    MotionEvent.ACTION_MOVE -> {
                        val moveDiffX = eventX - touchDownPoint.x
                        val moveDiffY = eventY - touchDownPoint.y
                        if (abs(moveDiffX) + abs(moveDiffY) > touchSlop && !isDragging) {
                            isDragging = true
                            onStartDragging()
                        } else if (isDragging) {
                            onDragging(miniBoxViewLp.x + eventX - touchDownPoint.x,
                                miniBoxViewLp.y + eventY - touchDownPoint.y)
                        }
                    }
                    MotionEvent.ACTION_UP,
                    MotionEvent.ACTION_CANCEL -> {
                        isDragging = false
                        onStopDragging()
                    }
                }
                return false
            }
        })
    }

    private fun initSpringBackAnimator() {
        springBackAnimator.addListener(object: AnimatorListenerAdapter() {
            override fun onAnimationStart(animation: Animator, isReverse: Boolean) {
                draggingView.scaleX = 1f
                draggingView.scaleY = 1f
                closeView.isActivated = false
                closeView.visibility = View.GONE
            }

            override fun onAnimationEnd(animation: Animator) {
                miniBoxView.visibility = View.VISIBLE
                miniBoxViewLp.x = draggingView.x.toInt()
                miniBoxViewLp.y = draggingView.y.toInt()
                wm.updateViewLayout(miniBoxView, miniBoxViewLp)
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
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
                or WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
        }
    }

    private fun onStartDragging() {
        draggingView.scaleX = 1.2f
        draggingView.scaleY = 1.2f
        closeView.visibility = View.VISIBLE
    }

    private fun onDragging(x: Float, y: Float) {
        miniBoxView.visibility = View.GONE
        draggingView.visibility = View.VISIBLE
        draggingView.x = x
        draggingView.y = y

        if (closeViewRect.isEmpty) {
            closeView.getGlobalVisibleRect(closeViewRect)
        }
        draggingView.getGlobalVisibleRect(draggingViewRect)

        closeView.isActivated = draggingViewRect.intersect(closeViewRect)
    }

    private fun onStopDragging() {
        if (closeView.isActivated) {
            callback.stopMiniBox()
        } else {
            springBackToWall()
        }
    }

    private fun springBackToWall() {
        val finalX: Float = if (draggingView.x >= windowSize.x / 2) {
            windowSize.x - miniBoxViewSize + miniBoxViewInset
        } else {
            -miniBoxViewInset
        }.toFloat()

        val finalY: Float = max(0f, min(draggingView.y, (windowSize.y - miniBoxViewSize - statusBarHeight).toFloat()))

        pvhX.setFloatValues(draggingView.x, finalX)
        pvhY.setFloatValues(draggingView.y, finalY)
        springBackAnimator.apply {
            cancel()
            start()
        }
    }

    fun destroy() {
        wm.removeView(miniBoxView)
        wm.removeView(bgView)
    }
}
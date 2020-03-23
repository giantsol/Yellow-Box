package com.giantsol.yellow_box

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.PropertyValuesHolder
import android.animation.ValueAnimator
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

    private val closeView = bgView.findViewById<View>(R.id.close)
    private val closeViewRect = Rect()

    private val wordEditorView = bgView.findViewById<View>(R.id.word_editor)

    private val miniBoxView = LayoutInflater.from(context).inflate(R.layout.view_mini_box, null)
    private lateinit var miniBoxViewLp: WindowManager.LayoutParams
    private val miniBoxViewSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 48f, context.resources.displayMetrics).toInt()
    private val miniBoxViewInset = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 4f, context.resources.displayMetrics).toInt()

    private val windowSize = Point().apply { wm.defaultDisplay.getSize(this) }

    private val pvhX = PropertyValuesHolder.ofInt("x", 0)
    private val pvhY = PropertyValuesHolder.ofInt("y", 0)
    private val springBackAnimator = ValueAnimator.ofPropertyValuesHolder(pvhX, pvhY).apply {
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
        val lp = getWindowParams(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT)
        lp.flags = lp.flags and WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE.inv()
        wm.addView(bgView, lp)

        bgView.visibility = View.GONE
        closeView.visibility = View.GONE
        wordEditorView.visibility = View.GONE
    }

    private fun initMiniBoxView() {
        miniBoxViewLp = getWindowParams(miniBoxViewSize, miniBoxViewSize)
        miniBoxViewLp.x = windowSize.x - miniBoxViewSize + miniBoxViewInset
        miniBoxViewLp.y = (windowSize.y - miniBoxViewSize - statusBarHeight) / 2
        wm.addView(miniBoxView, miniBoxViewLp)

        miniBoxView.setOnTouchListener(object: View.OnTouchListener {
            private val touchSlop = ViewConfiguration.get(context).scaledTouchSlop
            private val touchDownPoint = PointF()
            private val touchDownRawPoint = PointF()
            private var isDragging = false

            override fun onTouch(v: View, event: MotionEvent): Boolean {
                val x = event.x
                val y = event.y
                val rawX = event.rawX
                val rawY = event.rawY

                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        touchDownPoint.set(x, y)
                        touchDownRawPoint.set(rawX, rawY)
                        isDragging = false
                    }
                    MotionEvent.ACTION_MOVE -> {
                        val moveDiffX = rawX - touchDownRawPoint.x
                        val moveDiffY = rawY - touchDownRawPoint.y
                        if (abs(moveDiffX) + abs(moveDiffY) > touchSlop && !isDragging) {
                            isDragging = true
                        }

                        if (isDragging) {
                            onDragging(rawX - touchDownPoint.x, rawY - touchDownPoint.y)
                        }
                    }
                    MotionEvent.ACTION_UP,
                    MotionEvent.ACTION_CANCEL -> {
                        if (isDragging) {
                            onStopDragging()
                        } else if (event.action == MotionEvent.ACTION_UP) {
                            v.performClick()
                        }
                        isDragging = false
                    }
                }
                return true
            }
        })

        miniBoxView.setOnClickListener {
            toggleWordEditor()
        }
    }

    private fun initSpringBackAnimator() {
        springBackAnimator.addUpdateListener {
            val x: Int = it.getAnimatedValue("x") as Int
            val y: Int = it.getAnimatedValue("y") as Int
            miniBoxViewLp.x = x
            miniBoxViewLp.y = y
            wm.updateViewLayout(miniBoxView, miniBoxViewLp)
        }

        springBackAnimator.addListener(object: AnimatorListenerAdapter() {
            override fun onAnimationStart(animation: Animator, isReverse: Boolean) {
                miniBoxView.scaleX = 1f
                miniBoxView.scaleY = 1f
                closeView.isActivated = false
                closeView.visibility = View.GONE
            }

            override fun onAnimationEnd(animation: Animator) {
                bgView.visibility = View.GONE
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

    private fun onDragging(x: Float, y: Float) {
        bgView.visibility = View.VISIBLE
        closeView.visibility = View.VISIBLE
        wordEditorView.visibility = View.GONE

        miniBoxView.scaleX = 1.2f
        miniBoxView.scaleY = 1.2f
        miniBoxViewLp.x = x.toInt()
        miniBoxViewLp.y = y.toInt()
        wm.updateViewLayout(miniBoxView, miniBoxViewLp)

        if (closeViewRect.isEmpty) {
            closeView.getGlobalVisibleRect(closeViewRect)
        }

        closeView.isActivated = closeViewRect.intersect(miniBoxViewLp.x, miniBoxViewLp.y,
            miniBoxViewLp.x + miniBoxViewSize, miniBoxViewLp.y + miniBoxViewSize)
    }

    private fun onStopDragging() {
        if (closeView.isActivated) {
            callback.stopMiniBox()
        } else {
            springBackToWall()
        }
    }

    private fun springBackToWall() {
        val finalX: Int = if (miniBoxViewLp.x >= windowSize.x / 2) {
            windowSize.x - miniBoxViewSize + miniBoxViewInset
        } else {
            -miniBoxViewInset
        }

        val finalY: Int = max(0, min(miniBoxViewLp.y, windowSize.y - miniBoxViewSize - statusBarHeight))

        pvhX.setIntValues(miniBoxViewLp.x, finalX)
        pvhY.setIntValues(miniBoxViewLp.y, finalY)
        springBackAnimator.apply {
            cancel()
            start()
        }
    }

    private fun toggleWordEditor() {
        if (wordEditorView.visibility == View.VISIBLE) {
            bgView.visibility = View.GONE
            wordEditorView.visibility = View.GONE
        } else {
            bgView.visibility = View.VISIBLE
            wordEditorView.visibility = View.VISIBLE
        }
    }

    fun destroy() {
        wm.removeView(miniBoxView)
        wm.removeView(bgView)
    }
}
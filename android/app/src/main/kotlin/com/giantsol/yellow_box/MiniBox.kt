package com.giantsol.yellow_box

import android.animation.*
import android.content.Context
import android.graphics.PixelFormat
import android.graphics.Point
import android.graphics.PointF
import android.graphics.Rect
import android.os.Build
import android.util.TypedValue
import android.view.*
import android.view.animation.OvershootInterpolator
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min

class MiniBox(private val context: Context,
              private val callback: Callback): View.OnKeyListener {

    interface Callback {
        fun stopMiniBox()
        fun addWord(word: String)
    }

    private val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager

    private val bgView = LayoutInflater.from(context).inflate(R.layout.view_mini_box_bg, null) as KeyInterceptRelativeLayout

    private val closeView = bgView.findViewById<View>(R.id.close)
    private val closeViewRect = Rect()

    private val wordEditorView = bgView.findViewById<View>(R.id.word_editor)
    private val editorView = wordEditorView.findViewById<EditText>(R.id.editor)
    private val addButton = wordEditorView.findViewById<View>(R.id.add)

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

    private val showWordEditorAnimator = ObjectAnimator.ofFloat(wordEditorView, "x", 0f).apply {
        duration = 400
        interpolator = OvershootInterpolator()
    }

    private val hideWordEditorAnimator = ObjectAnimator.ofFloat(wordEditorView, "x", 0f).apply {
        duration = 400
        interpolator = OvershootInterpolator()
    }

    private val statusBarHeight: Int

    val isDestroyed get() = !miniBoxView.isAttachedToWindow

    init {
        initBgView()
        initMiniBoxView()
        initAnimators()

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

        bgView.setKeyInterceptListener(this)
        bgView.setOnClickListener {
            hideWordEditor()
        }

        addButton.setOnClickListener {
            addWordIfPossible()
        }

        editorView.setOnFocusChangeListener { v, hasFocus ->
            if (hasFocus) {
                pullUpWordEditorForInputIfNeeded()
            }
        }
        editorView.setOnEditorActionListener { v, actionId, event ->
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                addButton.performClick()
                true
            } else {
                false
            }
        }

        bgView.visibility = View.GONE
        closeView.visibility = View.GONE
        wordEditorView.visibility = View.INVISIBLE
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

    private fun initAnimators() {
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

        showWordEditorAnimator.addListener(object: AnimatorListenerAdapter() {
            private var isCancelled = false

            override fun onAnimationStart(animation: Animator) {
                bgView.visibility = View.VISIBLE
                wordEditorView.visibility = View.VISIBLE
                closeView.visibility = View.GONE
            }

            override fun onAnimationCancel(animation: Animator?) {
                isCancelled = true
            }

            override fun onAnimationEnd(animation: Animator?, isReverse: Boolean) {
                if (!isCancelled) {
                    editorView.requestFocus()
                    imm.showSoftInput(editorView, InputMethodManager.SHOW_IMPLICIT)
                }
                isCancelled = false
            }
        })

        hideWordEditorAnimator.addListener(object: AnimatorListenerAdapter() {
            private var isCancelled = false

            override fun onAnimationStart(animation: Animator, isReverse: Boolean) {
                editorView.clearFocus()
                imm.hideSoftInputFromWindow(editorView.windowToken, InputMethodManager.HIDE_IMPLICIT_ONLY)
            }

            override fun onAnimationCancel(animation: Animator) {
                isCancelled = true
            }

            override fun onAnimationEnd(animation: Animator) {
                if (!isCancelled) {
                    bgView.visibility = View.GONE
                    wordEditorView.visibility = View.INVISIBLE
                    editorView.text = null
                }
                isCancelled = false
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
        hideWordEditor()

        miniBoxView.scaleX = 1.2f
        miniBoxView.scaleY = 1.2f
        miniBoxViewLp.x = x.toInt()
        miniBoxViewLp.y = y.toInt()
        wm.updateViewLayout(miniBoxView, miniBoxViewLp)

        if (closeViewRect.isEmpty) {
            closeView.getGlobalVisibleRect(closeViewRect)
        }

        closeView.isActivated = closeViewRect.intersects(miniBoxViewLp.x, miniBoxViewLp.y,
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
        if (isWordEditorShown()) {
            hideWordEditor()
        } else {
            showWordEditor()
        }
    }

    private fun isWordEditorShown() = wordEditorView.visibility == View.VISIBLE

    private fun hideWordEditor() {
        if (!isWordEditorShown() || hideWordEditorAnimator.isRunning) {
            return
        }

        showWordEditorAnimator.cancel()
        hideWordEditorAnimator.apply {
            if (miniBoxViewLp.x > windowSize.x / 2) {
                setFloatValues((wordEditorView.layoutParams as ViewGroup.MarginLayoutParams).marginStart - miniBoxViewSize.toFloat(), windowSize.x.toFloat())
            } else {
                setFloatValues((wordEditorView.layoutParams as ViewGroup.MarginLayoutParams).marginStart.toFloat(), -wordEditorView.width.toFloat())
            }
            start()
        }
    }

    private fun showWordEditor() {
        if (isWordEditorShown() || showWordEditorAnimator.isRunning) {
            return
        }

        hideWordEditorAnimator.cancel()
        showWordEditorAnimator.apply {
            if (miniBoxViewLp.x > windowSize.x / 2) {
                setFloatValues(windowSize.x.toFloat(), (wordEditorView.layoutParams as ViewGroup.MarginLayoutParams).marginStart - miniBoxViewSize.toFloat())
            } else {
                setFloatValues(-wordEditorView.width.toFloat(), (wordEditorView.layoutParams as ViewGroup.MarginLayoutParams).marginStart.toFloat())
            }
            start()
        }
        wordEditorView.y = miniBoxViewLp.y.toFloat()
    }

    private fun addWordIfPossible() {
        val word = editorView.text.toString()
        if (word.isNotEmpty()) {
            callback.addWord(word)
            hideWordEditor()
        }
    }

    private fun pullUpWordEditorForInputIfNeeded() {
        if (wordEditorView.y > windowSize.y / 4) {
            val animator = ValueAnimator.ofFloat(wordEditorView.y, windowSize.y / 4f).apply {
                duration = 400
                interpolator = OvershootInterpolator()
            }
            animator.addUpdateListener {
                val value = it.animatedValue as Float
                wordEditorView.y = value
                miniBoxViewLp.y = value.toInt()
                wm.updateViewLayout(miniBoxView, miniBoxViewLp)
            }
            animator.start()
        }
    }

    override fun onKey(v: View, keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.action == KeyEvent.ACTION_UP && isWordEditorShown()) {
            hideWordEditor()
            return true
        }

        return false
    }

    fun destroy() {
        springBackAnimator.removeAllListeners()
        showWordEditorAnimator.removeAllListeners()
        hideWordEditorAnimator.removeAllListeners()

        if (miniBoxView.isAttachedToWindow) {
            wm.removeView(miniBoxView)
            wm.removeView(bgView)
        }
    }
}
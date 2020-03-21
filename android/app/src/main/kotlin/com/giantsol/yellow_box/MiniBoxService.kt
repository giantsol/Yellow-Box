package com.giantsol.yellow_box

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.view.View
import android.view.WindowManager


class MiniBoxService : Service() {

    companion object {
        const val ACTION_SHOW_MINI_BOX = "action.show.mini.box"
    }

    private var miniBox: MiniBox? = null

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()

        if (requestOverlayPermissionIfNeeded()) {
            terminate()
            return
        }
    }

    private fun terminate() {
        stopSelf()
        miniBox?.destroy() // should remove views from window
        miniBox = null
    }

    private fun requestOverlayPermissionIfNeeded(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !canDrawOverlays(applicationContext)) {
            try {
                val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${applicationContext.packageName}")).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                }
                applicationContext.startActivity(intent)
                return true
            } catch (ignored: Exception) { }
            terminate()
        }
        return false
    }

    private fun canDrawOverlays(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            true
        } else if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
            // with Android 8.1 (API 27) was released that it should contain the fix
            Settings.canDrawOverlays(context)
        } else {
            // this case version is between 6.0 (API 23) and 8.0 (API 26)
            if (Settings.canDrawOverlays(context)) {
                true
            } else {
                // In Android 8.0 (API 26), when user successfully grant permission and return to the app by pressing back button,
                // method canDrawOverlays() still return false, until user don't close the app and open it again or just choose it in recent apps dialog.
                canDrawOverlaysWorkAround(context)
            }
        }
    }

    /**
     * Android O에서 다른 앱 위에 그리기를 on으로 하고 onActivityResult()에서 권한 체크를 할 때
     * 타이밍 이슈로 Settings.canDrawOverlays()가 false를 리턴한다.
     * 그에 대한 해결책으로 TYPE_APPLICATION_OVERLAY param을 갖는 transparent view를 add/remove하여
     * 권한이 있는 경우에는 true, 권한이 없는 경우에는 false를 리턴하도록 하여 Overlay 권한을 체크한다.
     * 참고: https://stackoverflow.com/questions/46173460
     */
    private fun canDrawOverlaysWorkAround(context: Context): Boolean {
        try {
            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val viewToAdd = View(context)
            val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
            }
            val params = WindowManager.LayoutParams(0, 0, type,
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSPARENT)
            viewToAdd.layoutParams = params
            windowManager.addView(viewToAdd, params)
            windowManager.removeView(viewToAdd)
            return true
        } catch (e: Exception) {
            return false
        }
    }

    override fun onTaskRemoved(rootIntent: Intent) {
        super.onTaskRemoved(rootIntent)
        terminate()
    }

    override fun onDestroy() {
        super.onDestroy()
        terminate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == null) {
            return START_NOT_STICKY
        }

        when (intent.action!!) {
            ACTION_SHOW_MINI_BOX -> showMiniBox()
        }

        return START_NOT_STICKY
    }

    private fun showMiniBox() {
        if (miniBox == null) {
            miniBox = MiniBox(applicationContext)
        }
    }
}
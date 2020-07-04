package com.giantsol.yellow_box

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.PixelFormat
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.view.View
import android.view.WindowManager
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat


class MiniBoxService : Service(), MiniBox.Callback {

    companion object {
        const val ACTION_START_MINI_BOX = "action.start.mini.box"
        const val ACTION_PAUSE_MINI_BOX = "action.pause.mini.box"
        const val ACTION_RESUME_MINI_BOX = "action.resume.mini.box"
        const val ACTION_STOP_MINI_BOX = "action.stop.mini.box"

        private const val NOTIFICATION_ID = 1001
        private const val NOTIFICATION_CHANNEL_ID = "minibox.notification.channel"

        private const val REQUEST_CODE_PAUSE_BUTTON = 0
        private const val REQUEST_CODE_STOP_BUTTON = 1
        private const val REQUEST_CODE_RESUME_BUTTON = 2
    }

    private var miniBox: MiniBox? = null

    private lateinit var notificationManager: NotificationManager
    private val notificationBuilder by lazy {
        NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification_mini_box)
            .setColor(ContextCompat.getColor(this, R.color.defaultThemeLightColor))
            .setContentIntent(PendingIntent.getActivity(this, 0,
                Intent(this, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }, 0))
            .setColorized(true)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setOngoing(true)
    }

    private var isTerminating = false

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()

        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        createNotificationChannel()

        if (requestOverlayPermissionIfNeeded()) {
            terminate()
            return
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.mini_box_notification_channel_name)
            val descriptionText = getString(R.string.mini_box_notification_channel_description)
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, name, importance).apply { description = descriptionText }
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun terminate() {
        stopForeground(true)
        stopSelf()
        miniBox?.destroy() // should remove views from window
        miniBox = null
        isTerminating = true
    }

    private fun requestOverlayPermissionIfNeeded(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !canDrawOverlays(this)) {
            try {
                val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${packageName}")).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                }
                startActivity(intent)
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
        if (intent?.action == null || isTerminating) {
            return START_NOT_STICKY
        }

        when (intent.action!!) {
            ACTION_START_MINI_BOX -> startMiniBox()
            ACTION_PAUSE_MINI_BOX -> pauseMiniBox()
            ACTION_RESUME_MINI_BOX -> startMiniBox()
            ACTION_STOP_MINI_BOX -> terminate()
        }

        return START_NOT_STICKY
    }

    private fun startMiniBox() {
        miniBox?.destroy()

        startForeground(NOTIFICATION_ID, createStartedNotification())
        miniBox = MiniBox(this, this)
    }

    private fun pauseMiniBox() {
        miniBox?.destroy()
        notificationManager.notify(NOTIFICATION_ID, createPausedNotification())
    }

    private fun createStartedNotification(): Notification {
        val view = RemoteViews(packageName, R.layout.mini_box_notification)
        val pausePendingIntent = PendingIntent.getService(
            this, REQUEST_CODE_PAUSE_BUTTON,
            Intent(this, MiniBoxService::class.java).apply { action = ACTION_PAUSE_MINI_BOX },
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        view.setOnClickPendingIntent(R.id.pause_or_resume_button, pausePendingIntent)

        val stopPendingIntent = PendingIntent.getService(
            this, REQUEST_CODE_STOP_BUTTON,
            Intent(this, MiniBoxService::class.java).apply { action = ACTION_STOP_MINI_BOX },
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        view.setOnClickPendingIntent(R.id.stop_button, stopPendingIntent)

        view.setTextViewText(R.id.title, getText(R.string.notification_title_started))
        view.setTextViewText(R.id.pause_or_resume_button, getText(R.string.notification_pause))

        return notificationBuilder.setCustomContentView(view).build()
    }

    private fun createPausedNotification(): Notification {
        val view = RemoteViews(packageName, R.layout.mini_box_notification)
        val resumePendingIntent = PendingIntent.getService(
            this, REQUEST_CODE_RESUME_BUTTON,
            Intent(this, MiniBoxService::class.java).apply { action = ACTION_RESUME_MINI_BOX },
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        view.setOnClickPendingIntent(R.id.pause_or_resume_button, resumePendingIntent)

        val stopPendingIntent = PendingIntent.getService(
            this, REQUEST_CODE_STOP_BUTTON,
            Intent(this, MiniBoxService::class.java).apply { action = ACTION_STOP_MINI_BOX },
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        view.setOnClickPendingIntent(R.id.stop_button, stopPendingIntent)

        view.setTextViewText(R.id.title, getText(R.string.notification_title_paused))
        view.setTextViewText(R.id.pause_or_resume_button, getText(R.string.notification_resume))

        return notificationBuilder.setCustomContentView(view).build()
    }

    override fun onConfigurationChanged(newConfig: Configuration?) {
        if (miniBox?.isDestroyed == false) {
            miniBox?.destroy()
            miniBox = MiniBox(this, this)
        }
    }

    override fun stopMiniBox() {
        terminate()
    }

    override fun addWord(word: String) {
        AppMethodCallHandler.deliverMiniBoxWord(this, word)
    }
}
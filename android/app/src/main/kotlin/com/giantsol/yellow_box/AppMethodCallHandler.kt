package com.giantsol.yellow_box

import android.app.Activity
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object AppMethodCallHandler: MethodChannel.MethodCallHandler {

    private const val CHANNEL_PATH = "com.giantsol.yellow_box"
    private const val METHOD_CHANNEL_NAME = "$CHANNEL_PATH/methods"

    private const val METHOD_SHOW_MINI_BOX = "showMiniBox"
    private const val METHOD_INITIALIZED = "initialized"
    private const val METHOD_DELIVER_MINI_BOX_WORDS = "deliverMiniBoxWords"
    private const val METHOD_DELIVER_REMAINING_MINI_BOX_WORDS = "deliverRemainingMiniBoxWords"

    private const val PREF_BACKGROUND_MINI_BOX_WORDS = "background.mini.box.words"

    private var activity: Activity? = null
    private var methodChannel: MethodChannel? = null
    private var isMethodChannelConnected = false

    fun onAttachedToEngine(activity: Activity, messenger: BinaryMessenger) {
        this.activity = activity
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME).apply { setMethodCallHandler(this@AppMethodCallHandler) }
    }

    fun onDetachedFromEngine() {
        activity = null
        methodChannel = null
        isMethodChannelConnected = false
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_INITIALIZED -> {
                isMethodChannelConnected = true
                deliverSavedMiniBoxWords()
                result.success(true)
            }
            METHOD_SHOW_MINI_BOX -> {
                showMiniBox()
                result.success(true)
            }
            METHOD_DELIVER_REMAINING_MINI_BOX_WORDS -> {
                val map = call.arguments as Map<String, Long>
                saveMiniBoxWords(activity, map)
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun deliverSavedMiniBoxWords() {
        val prefs = activity?.getSharedPreferences(PREF_BACKGROUND_MINI_BOX_WORDS, Context.MODE_PRIVATE) ?: return
        val allSavedWords = prefs.all

        if (allSavedWords.isNotEmpty()) {
            methodChannel?.invokeMethod(METHOD_DELIVER_MINI_BOX_WORDS, allSavedWords)
            prefs.edit().clear().apply()
        }
    }

    private fun showMiniBox() {
        val activity = activity ?: return
        val intent = Intent(activity, MiniBoxService::class.java)
        intent.action = MiniBoxService.ACTION_START_MINI_BOX
        activity.startService(intent)
    }

    fun deliverMiniBoxWord(context: Context, word: String) {
        val wordMap = hashMapOf(Pair(word, System.currentTimeMillis()))
        if (isMethodChannelConnected) {
            methodChannel?.invokeMethod(METHOD_DELIVER_MINI_BOX_WORDS, wordMap)
        } else {
            saveMiniBoxWords(context, wordMap)
        }
    }

    private fun saveMiniBoxWords(context: Context?, wordsMap: Map<String, Long>) {
        val prefs = context?.getSharedPreferences(PREF_BACKGROUND_MINI_BOX_WORDS, Context.MODE_PRIVATE) ?: return
        val editor = prefs.edit()
        for (entry in wordsMap.entries) {
            editor.putLong(entry.key, entry.value)
        }
        editor.apply()
    }

}
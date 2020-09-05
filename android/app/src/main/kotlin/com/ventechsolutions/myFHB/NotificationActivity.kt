package com.ventechsolutions.myFHB

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager.LayoutParams.*
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat

class NotificationActivity : AppCompatActivity() {
    private val TAG = "NotificationActivity"
    private lateinit var channelName:String
    private lateinit var username:String
    private lateinit var docId:String
    private lateinit var docPic:String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification)
        setupActivity()
        val tv = findViewById<TextView>(R.id.recipient_name_tv)
        tv.text = "${intent.getStringExtra(UNAME)}"
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val nsID:Int=intent.getIntExtra(NS_ID,0)
        nsManager.cancel(nsID)
        channelName=intent.getStringExtra(MID)
        username=intent.getStringExtra(getString(R.string.username))
        docId=intent.getStringExtra(getString(R.string.docId))
        docPic=intent.getStringExtra(getString(R.string.docPic))

    }


    private fun setupActivity() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        } else {
            window.addFlags(FLAG_SHOW_WHEN_LOCKED or FLAG_TURN_SCREEN_ON or FLAG_KEEP_SCREEN_ON)
        }
    }

    fun decline(v: View?) {
        MyApp.isMissedNSShown=false
        finish()
    }

    fun accept(v: View?) {
        MyApp.isMissedNSShown=false
        val pm: PackageManager = packageManager
        val launchIntent = pm.getLaunchIntentForPackage(packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type="text/plain"
        launchIntent?.putExtra(Intent.EXTRA_TEXT,channelName)
        launchIntent?.putExtra(getString(R.string.username),username)
        launchIntent?.putExtra(getString(R.string.docId),docId)
        launchIntent?.putExtra(getString(R.string.docPic),docPic)
        startActivity(launchIntent)
        finish()
    }

    companion object {
        const val UNAME = "username"
        const val MID = "meeting_id"
        const val NS_ID = "notificationId"
    }

}

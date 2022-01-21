package com.ventechsolutions.myFHB

import android.app.*
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.view.WindowManager.LayoutParams.*
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.firestore.FirebaseFirestore
import com.ventechsolutions.myFHB.constants.Constants
import com.ventechsolutions.myFHB.services.AcceptReceiver
import com.ventechsolutions.myFHB.services.AutoDismissNotification
import com.ventechsolutions.myFHB.services.DeclineReciver
import com.ventechsolutions.myFHB.services.MyFirebaseInstanceService
import java.lang.Exception
import android.R.string.no
import android.media.MediaPlayer
import android.media.Ringtone
import android.provider.Settings


class NotificationActivity : AppCompatActivity() {
    private val TAG = "NotificationActivity"
    private lateinit var channelName: String
    private lateinit var username: String
    private lateinit var docId: String
    private lateinit var docPic: String
    private lateinit var patId: String
    private lateinit var patName: String
    private lateinit var patPic: String
    private lateinit var callType: String
    private lateinit var isWeb: String


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification)
//        setupActivity()
        turnScreenOnAndKeyguardOff()
        val tv = findViewById<TextView>(R.id.recipient_name_tv)
        val tv_callType = findViewById<TextView>(R.id.calling_tv)
        val profile_pic = findViewById<TextView>(R.id.profile_dp)
        val callerName = "${intent.getStringExtra(UNAME)}"
        tv.text = callerName
        profile_pic.text = callerName[0].toString()

        channelName = intent.getStringExtra(MID)!!
        username = intent.getStringExtra(getString(R.string.username))!!
        docId = intent.getStringExtra(getString(R.string.docId))!!
        docPic = intent.getStringExtra(getString(R.string.docPic))!!
        patId = intent.getStringExtra(getString(R.string.pat_id))!!
        patName = intent.getStringExtra(getString(R.string.pat_name))!!
        patPic = intent.getStringExtra(getString(R.string.pat_pic))!!
        callType = intent.getStringExtra(getString(R.string.callType))!!
        isWeb = intent.getStringExtra(getString(R.string.web))!!
        tv_callType.text = intent.getStringExtra(getString(R.string.pro_ns_body))
        listenEvent(id = channelName)
        val handler = Handler()
        val r = object : Runnable {
            public override fun run() {
                val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this@NotificationActivity)
                val nsID: Int = intent.getIntExtra(NS_ID, 0)
                nsManager.cancel(nsID)
                finish()
            }
        }
        handler.postDelayed(r, 30000)

    }

    fun turnScreenOnAndKeyguardOff() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                            or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
            )
        }

        with(getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                requestDismissKeyguard(this@NotificationActivity, null)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
//        turnScreenOffAndKeyguardOn()
    }

    private fun turnScreenOffAndKeyguardOn() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(false)
            setTurnScreenOn(false)
        } else {
            window.clearFlags(
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                            or WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
            )
        }
    }


    private fun listenEvent(id: String) {
        try {
            val docRef = FirebaseFirestore.getInstance().collection("call_log").document(id)
            docRef.addSnapshotListener { snapshot, e ->
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e)
                    return@addSnapshotListener
                }

                if (snapshot != null && snapshot.exists()) {
                    Log.d(TAG, "Current data: ${snapshot.data}")
                    if (snapshot.data?.get("call_status") == "call_ended_by_user") {
                        finish()
                    }
                } else {
                    Log.d(TAG, "Current data: null")
                }
            }
        } catch (e: Exception) {
            print("${e.message} was thrown")
        }
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
        MyApp.isMissedNSShown = false
        MyApp().updateStatus(false)
        MyApp.recordId = ""
        finish()
    }

    fun accept(v: View?) {
        MyApp.isMissedNSShown = false
        MyApp().updateStatus(true)
        MyApp.recordId = ""
        val pm: PackageManager = packageManager
        val launchIntent = pm.getLaunchIntentForPackage(packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type = Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT, channelName)
        launchIntent?.putExtra(getString(R.string.username), username)
        launchIntent?.putExtra(getString(R.string.docId), docId)
        launchIntent?.putExtra(getString(R.string.docPic), docPic)
        launchIntent?.putExtra(getString(R.string.pat_id), patId)
        launchIntent?.putExtra(getString(R.string.pat_name), patName)
        launchIntent?.putExtra(getString(R.string.pat_pic), patPic)
        launchIntent?.putExtra(getString(R.string.pat_pic), patPic)
        launchIntent?.putExtra(getString(R.string.callType), callType)
        launchIntent?.putExtra(getString(R.string.web), isWeb)
        startActivity(launchIntent)
        finish()
    }

    companion object {
        const val UNAME = "username"
        const val MID = "meeting_id"
        const val NS_ID = "notificationId"
    }

}

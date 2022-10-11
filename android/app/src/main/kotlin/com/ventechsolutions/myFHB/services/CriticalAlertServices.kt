package com.ventechsolutions.myFHB.services

import android.app.*
import android.content.ContentResolver
import android.content.Intent
import android.graphics.BitmapFactory
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.MainActivity
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class CriticalAlertServices : Service() {
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        try {
            Log.d("onStartCommand", "")
            openBackgroundAppFromNotification()
        } catch (e: Exception) {
            Log.e("onStartCommandCrash", e.message.toString())
        }
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d("onTaskRemoved", "")
        super.onTaskRemoved(rootIntent)
    }

    private fun openBackgroundAppFromNotification() {
        try {
            val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
            System.currentTimeMillis().toInt()
            val ack_sound: Uri =
                Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw./*msg_tone*/beep_beep)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val manager = getSystemService(NotificationManager::class.java)
                val channelCancelApps = NotificationChannel(
                    "backgroundapp_v1",
                    getString(R.string.channel_cancel_apps),
                    NotificationManager.IMPORTANCE_HIGH
                )
                channelCancelApps.description = getString(R.string.channel_cancel_apps_desc)
                val attributes =
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
                channelCancelApps.setSound(ack_sound, attributes)
                manager.createNotificationChannel(channelCancelApps)
            }
//        val onTapNS = Intent(applicationContext, OnTapNotificationBackground::class.java)
//        val onTapPendingIntent = PendingIntent.getBroadcast(
//            applicationContext,
//            2022,
//            onTapNS,
//            PendingIntent.FLAG_CANCEL_CURRENT
//        )

            val notificationIntent = Intent(this, MainActivity::class.java)

            notificationIntent.flags = (Intent.FLAG_ACTIVITY_CLEAR_TOP
                    or Intent.FLAG_ACTIVITY_SINGLE_TOP)

            val onTapPendingIntent = PendingIntent.getActivity(
                this, 0,
                notificationIntent, 0
            )

            //val colorRes = android.R.color.holo_red_dark

            val notification = NotificationCompat.Builder(this, "backgroundapp_v1")
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setLargeIcon(
                    BitmapFactory.decodeResource(
                        applicationContext.resources,
                        R.mipmap.ic_launcher
                    )
                )
                .setContentTitle(Constants.CRITICAL_APP_STOPPED)
                //.setContentTitle(HtmlCompat.fromHtml("<font color=\"" + colorRes + "\">" + Constants.CRITICAL_APP_STOPPED + "</font>", HtmlCompat.FROM_HTML_MODE_LEGACY))
                .setContentText(Constants.CRITICAL_APP_STOPPED_DESCRIPTION)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_SYSTEM)
                .setStyle(
                    NotificationCompat.BigTextStyle()
                        .bigText(Constants.CRITICAL_APP_STOPPED_DESCRIPTION)
                )
                .setSound(ack_sound)
                .setVibrate(longArrayOf(1000, 1000))
                //.setOngoing(true)
                .setContentIntent(onTapPendingIntent)
                .build()
            notification.flags = Notification.FLAG_NO_CLEAR
            nsManager.notify(2022, notification)
        } catch (e: Exception) {
            Log.d("Catch", "" + e.toString())
        }


    }

}

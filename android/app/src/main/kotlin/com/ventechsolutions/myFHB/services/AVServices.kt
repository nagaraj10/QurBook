package com.ventechsolutions.myFHB.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ContentResolver
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ventechsolutions.myFHB.MainActivity
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants

class AVServices : Service() {
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val CHANNEL_AV = "AVServicesChannel"
        val input = intent.getStringExtra(getString(R.string.arg_name))
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, PendingIntent.FLAG_ONE_SHOT)
        val _sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val manager = getSystemService(NotificationManager::class.java)
            val isChannelExists = manager.getNotificationChannel(CHANNEL_AV)
            if(isChannelExists != null){
                manager.deleteNotificationChannel(CHANNEL_AV)
            }
            val serviceChannel = NotificationChannel(
                    CHANNEL_AV,
                    getString(R.string.avs_cha_name),
                    NotificationManager.IMPORTANCE_DEFAULT
            )
            val attributes = AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            serviceChannel.setSound(_sound,attributes)
            manager.createNotificationChannel(serviceChannel)
        }
        val notification = NotificationCompat.Builder(this, applicationContext.getString(R.string.avs_cha_id))
                .setContentTitle(getString(R.string.on_going_call_msg))
                .setContentText(input)
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setContentIntent(pendingIntent)
                .setSound(_sound)
                .setTicker(Constants.TICKER)
                .setUsesChronometer(true)
                .build()
        startForeground(1, notification)
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

}

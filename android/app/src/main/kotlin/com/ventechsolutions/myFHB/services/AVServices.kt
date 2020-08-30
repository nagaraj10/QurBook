package com.ventechsolutions.myFHB.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ventechsolutions.myFHB.MainActivity
import com.ventechsolutions.myFHB.R

class AVServices : Service() {
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val input = intent.getStringExtra("name")
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, PendingIntent.FLAG_ONE_SHOT)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    applicationContext.getString(R.string.avs_cha_id),
                    getString(R.string.avs_cha_name),
                    NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
        val notification = NotificationCompat.Builder(this, applicationContext.getString(R.string.avs_cha_id))
                .setContentTitle(getString(R.string.on_going_call_msg))
                .setContentText(input)
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setContentIntent(pendingIntent)
                .setTicker("Ticker values")
                .setUsesChronometer(true)
                .build()
        startForeground(1, notification)
        //stopSelf();
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

}

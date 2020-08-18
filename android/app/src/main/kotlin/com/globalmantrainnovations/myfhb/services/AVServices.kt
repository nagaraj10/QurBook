package com.globalmantrainnovations.myfhb.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.globalmantrainnovations.myfhb.MainActivity
import com.globalmantrainnovations.myfhb.R

class AVServices : Service() {
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val input = intent.getStringExtra("name")
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, PendingIntent.FLAG_ONE_SHOT)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    CHANNEL_ID,
                    "AV Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("on going call with")
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

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "onCreate")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "onDestroy")
    }

    companion object {
        const val TAG = "AVServices"
        const val CHANNEL_ID = "AVServicesChannel"
    }
}

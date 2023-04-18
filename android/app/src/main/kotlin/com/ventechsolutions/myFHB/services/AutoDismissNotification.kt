package com.ventechsolutions.myFHB.services;
import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build
import com.ventechsolutions.myFHB.R


class AutoDismissNotification : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(intent.getIntExtra(context.getString(R.string.nsid), 0))
    }


    fun setAlarm(context: Context, notificationId: Int, time: Long) {
        val alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val alarmIntent = Intent(context, AutoDismissNotification::class.java)
        alarmIntent.putExtra(context.getString(R.string.nsid), notificationId)
        var alarmPendingIntent: PendingIntent? = null
        alarmPendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getBroadcast(context, notificationId, alarmIntent, PendingIntent.FLAG_IMMUTABLE)
        } else {
            PendingIntent.getBroadcast(context, notificationId, alarmIntent, PendingIntent.FLAG_ONE_SHOT)
        }
        alarmMgr.set(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + time, alarmPendingIntent)
    }
}

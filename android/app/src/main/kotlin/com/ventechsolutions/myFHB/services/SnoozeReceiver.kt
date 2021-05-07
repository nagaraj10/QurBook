package com.ventechsolutions.myFHB.services

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.R
import java.util.*

class SnoozeReceiver : BroadcastReceiver() {
    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val currentMillis = p1?.getLongExtra(p0?.getString(R.string.currentMillis), 0)
        val title = p1?.getStringExtra(p0?.getString(R.string.title))
        val body = p1?.getStringExtra(p0?.getString(R.string.body))
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        val nsTimeThreshold = 300000
        MyApp.snoozeTapCountTime = MyApp.snoozeTapCountTime + 1
        if (MyApp.snoozeTapCountTime <= 1) {
            //currentMillis?.let { snoozeForSometime(p0, title, body, notificationId, it + nsTimeThreshold) }
            snoozeForSometime(p0, title, body, notificationId, Calendar.getInstance().timeInMillis + nsTimeThreshold)
            nsManager.cancel(notificationId!! as Int)
        } else {
            Handler().postDelayed({
                val CHANNEL_REMINDER = "ch_reminder"
                val _sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + p0.packageName + "/" + R.raw.msg_tone)
                val dismissIntent = Intent(p0, DismissReceiver::class.java)
                dismissIntent.putExtra(p0.getString(R.string.nsid), notificationId)
                val dismissIntentPendingIntent = PendingIntent.getBroadcast(p0, 0, dismissIntent, PendingIntent.FLAG_UPDATE_CURRENT)
                var notification = NotificationCompat.Builder(p0, CHANNEL_REMINDER)
                        .setSmallIcon(R.drawable.ic_alarm_new)
                        .setLargeIcon(BitmapFactory.decodeResource(p0.resources, R.mipmap.ic_launcher))
                        .setContentTitle(title)
                        .setContentText(body)
                        .setPriority(NotificationCompat.PRIORITY_MAX)
                        .setCategory(NotificationCompat.CATEGORY_ALARM)
                        .addAction(R.drawable.ic_close, "Dismiss", dismissIntentPendingIntent)
                        .setAutoCancel(true)
                        .setSound(_sound)
                        //.setOngoing(true)
                        .setOnlyAlertOnce(false)
                        .build()

                nsManager.notify(notificationId!!, notification)
            }, currentMillis!! + nsTimeThreshold)
            nsManager.cancel(notificationId!! as Int)

        }
    }

    private fun snoozeForSometime(p0: Context?, title: String?, body: String?, notificationId: Int?, currentMillis: Long) {
        val reminderBroadcaster = Intent(p0, ReminderBroadcaster::class.java)
        reminderBroadcaster.putExtra(p0?.getString(R.string.title), title)
        reminderBroadcaster.putExtra(p0?.getString(R.string.body), body)
        reminderBroadcaster.putExtra(p0?.getString(R.string.nsid), notificationId)
        reminderBroadcaster.putExtra("isCancel", false)

        val alarmMgr = p0?.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = PendingIntent.getBroadcast(p0, 1, reminderBroadcaster, PendingIntent.FLAG_ONE_SHOT)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            currentMillis.let { alarmMgr.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            currentMillis.let { alarmMgr.setExact(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
        } else {
            currentMillis.let { alarmMgr.set(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
        }
    }

}
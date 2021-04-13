package com.ventechsolutions.myFHB.services

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.R

class SnoozeReceiver : BroadcastReceiver() {
    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val currentMillis = p1?.getLongExtra(p0?.getString(R.string.currentMillis), 0)
        val title = p1?.getStringExtra(p0?.getString(R.string.title))
        val body = p1?.getStringExtra(p0?.getString(R.string.body))
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
        if (MyApp.snoozeTapCountTime in 0..2) {
            currentMillis?.let { snoozeForSometime(p0, title, body, notificationId, it + 10000) }
        } else {
            /*val reminderService = Intent(p0, RemiderService::class.java)
            p0.stopService(reminderService)*/
            //MyApp.snoozeTapCountTime = 0
        }
    }

    private fun snoozeForSometime(p0: Context?, title: String?, body: String?, notificationId: Int?, currentMillis: Long) {
        val reminderBroadcaster = Intent(p0, ReminderBroadcaster::class.java)
        reminderBroadcaster.putExtra(p0?.getString(R.string.title), title)
        reminderBroadcaster.putExtra(p0?.getString(R.string.body), body)
        reminderBroadcaster.putExtra(p0?.getString(R.string.nsid), notificationId)

        val alarmMgr = p0?.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = PendingIntent.getBroadcast(p0, 1, reminderBroadcaster, PendingIntent.FLAG_ONE_SHOT)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            currentMillis.let { alarmMgr.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            currentMillis.let { alarmMgr.setExact(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
        } else {
            currentMillis.let { alarmMgr.set(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
        }
        MyApp.snoozeTapCountTime++
    }

}
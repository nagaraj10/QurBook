package com.ventechsolutions.myFHB.services

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.SharedPrefUtils
import com.ventechsolutions.myFHB.constants.Constants
import java.util.*

class SnoozeReceiver : BroadcastReceiver() {
    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(ReminderBroadcaster.NOTIFICATION_ID, 0)
        val currentMillis = p1?.getLongExtra(p0?.getString(R.string.currentMillis), 0)
        val title = p1?.getStringExtra(p0?.getString(R.string.title))
        val eventId = p1?.getStringExtra(p0?.getString(R.string.eventId))
        val body = p1?.getStringExtra(p0?.getString(R.string.body))
        val channelId = p1?.getStringExtra(Constants.CHANNEL_ID)
        val estart = p1?.getStringExtra(Constants.PROP_ESTART)
        val dosemeal = p1?.getStringExtra(Constants.PROP_DOSEMEAL)
        val eid = p1?.getStringExtra(Constants.EID_SNOOZE)

        val nsManager = p0?.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val nsTimeThreshold = 100000
        MyApp.snoozeTapCountTime = MyApp.snoozeTapCountTime + 1
        Log.d("----faisal1",notificationId.toString())
        if (MyApp.snoozeTapCountTime <= 1) {
            //currentMillis?.let { snoozeForSometime(p0, title, body, notificationId, it + nsTimeThreshold) }
            var notification = createNotifiationBuilderSnooze(
                p0,
                title.toString(),
                body.toString(),
                eid.toString(),
                notificationId!!.toInt()+1,
                currentMillis!!.toLong(),
                false,
                true,
                channelId.toString(),
                eventId.toString(),
                estart.toString(),
                dosemeal.toString()
            )
            snoozeForSometime(p0, title, body, notificationId, Calendar.getInstance().timeInMillis + nsTimeThreshold,eventId.toString(),notification,eid)
            //notificationId?.let { nsManager.cancel(it) }
            //notificationId?.let { SharedPrefUtils().deleteNotificationObject(p0, it) }

        } else {
            Log.d("----faisal2",notificationId.toString())
            /*Handler().postDelayed({
                val CHANNEL_REMINDER = "ch_reminder"
                val _sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + p0.packageName + "/" + R.raw.msg_tone)
                val dismissIntent = Intent(p0, DismissReceiver::class.java)
                dismissIntent.putExtra(p0.getString(R.string.nsid), notificationId)
                val dismissIntentPendingIntent =  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    PendingIntent.getBroadcast(p0, notificationId!!, dismissIntent, PendingIntent.FLAG_IMMUTABLE)

                } else {
                    PendingIntent.getBroadcast(p0, notificationId!!, dismissIntent, PendingIntent.FLAG_UPDATE_CURRENT)

                }


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
            }, currentMillis!! + nsTimeThreshold)*/
            //nsManager.cancel(notificationId!! as Int)

        }

        notificationId?.let { nsManager.cancel(it) }
        notificationId?.let { SharedPrefUtils().deleteNotificationObject(p0, it) }
    }

    private fun snoozeForSometime(p0: Context?, title: String?, body: String?, notificationId: Int?, currentMillis: Long,eventId: String, notification: Notification?,eid:String?) {
        try {
            val reminderBroadcaster = Intent(p0, ReminderBroadcaster::class.java)
            reminderBroadcaster.putExtra(p0?.getString(R.string.title), title)
            reminderBroadcaster.putExtra(p0?.getString(R.string.body), body)
            reminderBroadcaster.putExtra(p0?.getString(R.string.nsid), notificationId)
            reminderBroadcaster.putExtra(p0?.getString(R.string.eventId), eventId)
            reminderBroadcaster.putExtra("isCancel", false)
            reminderBroadcaster.putExtra(ReminderBroadcaster.EID, eid)
            reminderBroadcaster.putExtra(ReminderBroadcaster.NOTIFICATION, notification)

            /*val alarmMgr = p0?.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            var pendingIntent: PendingIntent? = null
            pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getBroadcast(p0, 1, reminderBroadcaster, PendingIntent.FLAG_IMMUTABLE)
            } else {
                PendingIntent.getBroadcast(p0, 1, reminderBroadcaster, PendingIntent.FLAG_ONE_SHOT)

            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                currentMillis.let { alarmMgr.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                currentMillis.let { alarmMgr.setExact(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
            } else {
                currentMillis.let { alarmMgr.set(AlarmManager.RTC_WAKEUP, it, pendingIntent) }
            }*/

            val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getBroadcast(
                    p0,
                    notificationId!!,
                    reminderBroadcaster,
                    PendingIntent.FLAG_IMMUTABLE
                )
            } else {
                PendingIntent.getBroadcast(
                    p0,
                    notificationId!!,
                    reminderBroadcaster,
                    PendingIntent.FLAG_CANCEL_CURRENT
                )
            }


            val alarmManager = p0?.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    currentMillis,
                    pendingIntent
                )
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, currentMillis, pendingIntent)
            }



        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }
    }


    private fun createNotifiationBuilderSnooze(
        p0: Context?,
        title: String,
        body: String,
        eId: String,
        nsId: Int,
        currentMillis: Long,
        isCancel: Boolean,
        isButtonShown: Boolean,
        channelId: String,
        eventId: String,
        eStart: String,
        dosemeal: String
    ): Notification? {
        try {
            val _sound: Uri =
                Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + p0?.packageName + "/" + R.raw.msg_tone)

            val dismissIntent = Intent(p0!!, DismissReceiver::class.java)
            dismissIntent.putExtra(ReminderBroadcaster.NOTIFICATION_ID, nsId)
            val dismissPendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getBroadcast(
                    p0,
                    nsId,
                    dismissIntent,
                    PendingIntent.FLAG_IMMUTABLE
                )
            } else {
                PendingIntent.getBroadcast(
                    p0,
                    nsId,
                    dismissIntent,
                    PendingIntent.FLAG_CANCEL_CURRENT
                )
            }


            val snoozeIntent = Intent(p0, SnoozeReceiver::class.java)
            snoozeIntent.putExtra(ReminderBroadcaster.NOTIFICATION_ID, nsId)
            snoozeIntent.putExtra(p0.getString(R.string.currentMillis), currentMillis)
            snoozeIntent.putExtra(p0.getString(R.string.title), title)
            snoozeIntent.putExtra(p0.getString(R.string.body), body)
            snoozeIntent.putExtra(Constants.PROP_EVEID, eventId)
            snoozeIntent.putExtra(Constants.PROP_ESTART, eStart)
            snoozeIntent.putExtra(Constants.PROP_DOSEMEAL, dosemeal)
            snoozeIntent.putExtra(Constants.CHANNEL_ID, channelId)
            snoozeIntent.putExtra(Constants.EID_SNOOZE, eId)
            val snoozePendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getBroadcast(
                    p0,
                    nsId,
                    snoozeIntent,
                    PendingIntent.FLAG_IMMUTABLE
                )
            } else {
                PendingIntent.getBroadcast(
                    p0,
                    nsId,
                    snoozeIntent,
                    PendingIntent.FLAG_CANCEL_CURRENT
                )
            }


            val onTapNS = Intent(p0, OnTapNotification::class.java)
            onTapNS.putExtra("nsid", nsId)
            onTapNS.putExtra("meeting_id", "")
            onTapNS.putExtra("username", "")
            //onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
            onTapNS.putExtra(Constants.PROP_DATA, "")
            onTapNS.putExtra(Constants.PROP_REDIRECT_TO, "regiment_screen")
            onTapNS.putExtra(Constants.PROP_HRMID, "")
            onTapNS.putExtra(Constants.PROP_EVEID, eventId)
            onTapNS.putExtra(Constants.PROP_ESTART, eStart)
            onTapNS.putExtra(Constants.PROP_DOSEMEAL, dosemeal)
            val onTapPendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getBroadcast(p0, nsId, onTapNS, PendingIntent.FLAG_IMMUTABLE)

            } else {
                PendingIntent.getBroadcast(p0, nsId, onTapNS, PendingIntent.FLAG_CANCEL_CURRENT)

            }
            val builder: NotificationCompat.Builder
            if (isButtonShown) {
                builder = NotificationCompat.Builder(p0.applicationContext, channelId)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setLargeIcon(
                        BitmapFactory.decodeResource(
                            p0.applicationContext.resources,
                            R.mipmap.ic_launcher
                        )
                    )
                    .setContentTitle(title)
                    .setContentText(body)
                    .setContentIntent(onTapPendingIntent)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .addAction(R.drawable.ic_close, "Dismiss", dismissPendingIntent)
                    .addAction(R.drawable.ic_snooze, "Snooze", snoozePendingIntent)
                    .setAutoCancel(true)
                    .setOnlyAlertOnce(false)
            } else {
                builder = NotificationCompat.Builder(p0.applicationContext, channelId)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setLargeIcon(
                        BitmapFactory.decodeResource(
                            p0.applicationContext.resources,
                            R.mipmap.ic_launcher
                        )
                    )
                    .setContentTitle(title)
                    .setContentText(body)
                    .setContentIntent(onTapPendingIntent)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .setAutoCancel(true)
                    .setOnlyAlertOnce(false)
            }
            val notification: Notification = builder.build()

            return notification;
        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }

     return  null
    }
}
package com.ventechsolutions.myFHB.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.pichillilorenzo.flutter_inappwebview.Shared.applicationContext
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants

class ReminderBroadcaster : BroadcastReceiver() {
    override fun onReceive(p0: Context?, p1: Intent?) {
        val CHANNEL_REMINDER = "ch_reminder"
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        val _sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + p0.packageName + "/" + R.raw.msg_tone)

        val dataTitle = p1?.getStringExtra(p0.getString(R.string.title))
        val dataBody = p1?.getStringExtra(p0.getString(R.string.body))
        val NS_ID = p1?.getIntExtra(p0.getString(R.string.nsid), 0)
        val currentMillis = p1?.getLongExtra(p0.getString(R.string.currentMillis), 0)
        val isCancel = p1?.getBooleanExtra("isCancel", false)

        if (isCancel == true) {
            NS_ID?.let { nsManager.cancel(it) }
        } else {
//        val declineIntent = Intent(p0, DeclineReciver::class.java)
//        declineIntent.putExtra(p0.getString(R.string.nsid), NS_ID)
//        val declinePendingIntent = PendingIntent.getBroadcast(p0, 0, declineIntent, PendingIntent.FLAG_CANCEL_CURRENT)

            val dismissIntent = Intent(p0, DismissReceiver::class.java)
            dismissIntent.putExtra(p0.getString(R.string.nsid), NS_ID)
            val dismissIntentPendingIntent = PendingIntent.getBroadcast(p0, 0, dismissIntent, PendingIntent.FLAG_CANCEL_CURRENT)

            val snoozeIntent = Intent(p0, SnoozeReceiver::class.java)
            snoozeIntent.putExtra(p0.getString(R.string.nsid), NS_ID)
            snoozeIntent.putExtra(p0.getString(R.string.currentMillis), currentMillis)
            snoozeIntent.putExtra(p0.getString(R.string.title), dataTitle)
            snoozeIntent.putExtra(p0.getString(R.string.body), dataBody)
            val snoozePendingIntent = PendingIntent.getBroadcast(p0, 0, snoozeIntent, PendingIntent.FLAG_CANCEL_CURRENT)


            val onTapNS = Intent(p0, OnTapNotification::class.java)
            onTapNS.putExtra("nsid", NS_ID)
            onTapNS.putExtra("meeting_id", "")
            onTapNS.putExtra("username", "")
            //onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
            onTapNS.putExtra(Constants.PROP_DATA, "")
            onTapNS.putExtra(Constants.PROP_REDIRECT_TO, "regiment_screen")
            onTapNS.putExtra(Constants.PROP_HRMID, "")
            val onTapPendingIntent = PendingIntent.getBroadcast(p0, NS_ID!!, onTapNS, PendingIntent.FLAG_CANCEL_CURRENT)


            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                //val manager = getSystemService(NotificationManager::class.java)
                val isChannelExists = nsManager.getNotificationChannel(CHANNEL_REMINDER)
                if (isChannelExists != null) {
                    nsManager.deleteNotificationChannel(CHANNEL_REMINDER)
                }
                val channelReminder = NotificationChannel(CHANNEL_REMINDER, "Reminder Channel", NotificationManager.IMPORTANCE_HIGH)
                channelReminder.description = "This channel is all about reminder"
                val attributes = AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
                channelReminder.setSound(_sound, attributes)
                nsManager.createNotificationChannel(channelReminder)
            }

            var notification = NotificationCompat.Builder(p0, CHANNEL_REMINDER)
                    .setSmallIcon(R.drawable.ic_alarm_new)
                    .setLargeIcon(BitmapFactory.decodeResource(p0.resources, R.mipmap.ic_launcher))
                    .setContentTitle(dataTitle)
                    .setContentText(dataBody)
                    .setContentIntent(onTapPendingIntent)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .addAction(R.drawable.ic_close, "Dismiss", dismissIntentPendingIntent)
                    .addAction(R.drawable.ic_snooze, "Snooze", snoozePendingIntent)
                    .setAutoCancel(true)
                    .setSound(_sound)
                    //.setOngoing(true)
                    .setOnlyAlertOnce(false)
                    .build()

            //notification.flags = Notification.FLAG_INSISTENT
            if (NS_ID != null) {
                nsManager.notify(NS_ID, notification)
            }

        }
    }
}
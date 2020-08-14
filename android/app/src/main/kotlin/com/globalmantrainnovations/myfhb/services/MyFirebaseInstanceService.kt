package com.globalmantrainnovations.myfhb.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentResolver
import android.content.Intent
import android.graphics.BitmapFactory
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.globalmantrainnovations.myfhb.NotificationActivity
import com.globalmantrainnovations.myfhb.R
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage


class MyFirebaseInstanceService : FirebaseMessagingService() {
    val CHANNEL_INCOMING = "incoming_call"
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(TAG, "Token: $token")
    }


    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d(TAG, "From: " + remoteMessage.from)
        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            createNotification(data = remoteMessage.data)
        }
        if (remoteMessage.notification != null) {
            val t = remoteMessage.notification!!.title
            val b = remoteMessage.notification!!.body
            if (t != null && b != null) {
                createNotification(title = t,body = b)
            }
        }

    }

    companion object {
        private const val TAG = "MyFirebaseInstanceIDSer"

    }

    private fun createNotification(title:String="", body:String="", data:Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = 9090
        val MEETING_ID = data[getString(R.string.meetid)]
        val USER_NAME = data[getString(R.string.username)]
        val NS_TIMEOUT = 30 * 1000L
        val _sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.helium)


        val declineIntent = Intent(applicationContext, DeclineReciver::class.java)
        declineIntent.putExtra(getString(R.string.nsid), NS_ID)
        val declinePendingIntent = PendingIntent.getBroadcast(applicationContext, 0, declineIntent, PendingIntent.FLAG_CANCEL_CURRENT)

        val acceptIntent = Intent(applicationContext, AcceptReceiver::class.java)
        acceptIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptIntent.putExtra(getString(R.string.meetid), "$MEETING_ID")
        acceptIntent.putExtra(getString(R.string.username), "$USER_NAME")
        val acceptPendingIntent = PendingIntent.getBroadcast(applicationContext, 0, acceptIntent, PendingIntent.FLAG_CANCEL_CURRENT)

        val fullScreenIntent = Intent(this, NotificationActivity::class.java)
                .putExtra(getString(R.string.username), USER_NAME)
                .putExtra(getString(R.string.meetid), MEETING_ID)
                .putExtra(getString(R.string.nsid), NS_ID)
        val fullScreenPendingIntent = PendingIntent.getActivity(this, 0,
                fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT)

        if (Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            val manager = getSystemService(NotificationManager::class.java)
            val channel1 = NotificationChannel(CHANNEL_INCOMING, getString(R.string.channel1), NotificationManager.IMPORTANCE_HIGH)
            channel1.description = getString(R.string.channel_incoming_desc)
            val attributes = AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channel1.setSound(_sound,attributes)
            manager.createNotificationChannel(channel1)
        }


        var notification = NotificationCompat.Builder(this, CHANNEL_INCOMING)
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setLargeIcon(BitmapFactory.decodeResource(applicationContext.resources,R.mipmap.ic_launcher))
                .setContentTitle(data["title"])
                .setContentText(data["body"])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_CALL)
                .setDefaults(Notification.DEFAULT_SOUND)
                .setContentIntent(fullScreenPendingIntent)
                .addAction(R.drawable.ic_call, getString(R.string.ns_act_accept), acceptPendingIntent)
                .addAction(R.drawable.ic_decline, getString(R.string.ns_act_decline), declinePendingIntent)
                .setAutoCancel(true)
                .setFullScreenIntent(fullScreenPendingIntent,true)
                .setSound(_sound)
                .setOngoing(true)
                .setTimeoutAfter(NS_TIMEOUT)
                .setOnlyAlertOnce(false)
                .build()

        notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID,notification)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O){
            AutoDismissNotification().setAlarm(this,NS_ID,NS_TIMEOUT)
        }
    }

}

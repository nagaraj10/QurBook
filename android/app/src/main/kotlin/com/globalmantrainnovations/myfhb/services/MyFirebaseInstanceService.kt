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
    val CHANNEL_INCOMING = "cha_call"
    val CHANNEL_ACK = "cha_ack"
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
        //todo segregate the NS according their type
        val NS_TYPE=data[getString(R.string.type).toLowerCase()]
        when(NS_TYPE){
            getString(R.string.ns_type_call)->createNotification4Call(data)
            getString(R.string.ns_type_ack)->createNotification4Ack(data)
        }
    }

    private fun createNotification4Call(data:Map<String, String> = HashMap()){
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = 9090
        val MEETING_ID = data[getString(R.string.meetid)]
        val USER_NAME = data[getString(R.string.username)]
        val DOC_ID = data[getString(R.string.docId)]
        val NS_TIMEOUT = 30 * 1000L
        val _sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.helium)


        val declineIntent = Intent(applicationContext, DeclineReciver::class.java)
        declineIntent.putExtra(getString(R.string.nsid), NS_ID)
        val declinePendingIntent = PendingIntent.getBroadcast(applicationContext, 0, declineIntent, PendingIntent.FLAG_CANCEL_CURRENT)

        val acceptIntent = Intent(applicationContext, AcceptReceiver::class.java)
        acceptIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptIntent.putExtra(getString(R.string.meetid), "$MEETING_ID")
        acceptIntent.putExtra(getString(R.string.username), "$USER_NAME")
        acceptIntent.putExtra(getString(R.string.docId), "$DOC_ID")
        val acceptPendingIntent = PendingIntent.getBroadcast(applicationContext, 0, acceptIntent, PendingIntent.FLAG_CANCEL_CURRENT)

        val fullScreenIntent = Intent(this, NotificationActivity::class.java)
                .putExtra(getString(R.string.username), USER_NAME)
                .putExtra(getString(R.string.docId), DOC_ID)
                .putExtra(getString(R.string.meetid), MEETING_ID)
                .putExtra(getString(R.string.nsid), NS_ID)
        val fullScreenPendingIntent = PendingIntent.getActivity(this, 0,
                fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT)

        if (Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            val manager = getSystemService(NotificationManager::class.java)
            val channelCall = NotificationChannel(CHANNEL_INCOMING, getString(R.string.channel_call), NotificationManager.IMPORTANCE_HIGH)
            channelCall.description = getString(R.string.channel_incoming_desc)
            val attributes = AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCall.setSound(_sound,attributes)
            manager.createNotificationChannel(channelCall)
        }


        var notification = NotificationCompat.Builder(this, CHANNEL_INCOMING)
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setLargeIcon(BitmapFactory.decodeResource(applicationContext.resources,R.mipmap.ic_launcher))
                .setContentTitle(data[getString(R.string.pro_ns_title)])
                .setContentText(data[getString(R.string.pro_ns_body)])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_CALL)
                .setDefaults(Notification.DEFAULT_ALL)
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

    private fun createNotification4Ack(data:Map<String, String> = HashMap()){
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = 9091
        val MEETING_ID = data[getString(R.string.meetid)]
        val USER_NAME = data[getString(R.string.username)]
        val NS_TIMEOUT = 30 * 1000L
        val ack_sound: Uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

        if (Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(CHANNEL_ACK, getString(R.string.channel_ack), NotificationManager.IMPORTANCE_DEFAULT)
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes = AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound,attributes)
            manager.createNotificationChannel(channelAck)
        }


        var notification = NotificationCompat.Builder(this, CHANNEL_INCOMING)
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setLargeIcon(BitmapFactory.decodeResource(applicationContext.resources,R.mipmap.ic_launcher))
                .setContentTitle(data[getString(R.string.pro_ns_title)])
                .setContentText(data[getString(R.string.pro_ns_body)])
                .setSound(ack_sound)
                .setAutoCancel(false)
                .setDefaults(NotificationCompat.DEFAULT_ALL)
                .build()
        nsManager.notify(NS_ID,notification)
    }
}

package com.ventechsolutions.myFHB.services

import android.annotation.SuppressLint
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
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.NotificationActivity
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class MyFirebaseInstanceService : FirebaseMessagingService() {
    val CHANNEL_INCOMING = "cha_call"
    val CHANNEL_ACK = "cha_ack"
    val CHANNEL_MISS_CALL = "cha_missed_call_ns"
    val CHANNEL_CANCEL_APP = "cha_cancel_app"
    val CHANNEL_ONBOARD = "cha_doc_onboard"
    val CHANNEL_RENEW = "cha_renew_plan"
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(TAG, "Token: $token")
    }


    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        //Log.d(TAG, "From: " + remoteMessage.from)
        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            createNotification(data = remoteMessage.data)
        }
        if (remoteMessage.notification != null) {
            val t = remoteMessage.notification!!.title
            val b = remoteMessage.notification!!.body
            if (t != null && b != null) {
                createNotification(title = t, body = b)
            }
        }

    }

    companion object {
        private const val TAG = "MyFirebaseInstanceIDSer"
    }

    private fun createNotification(
        title: String = "",
        body: String = "",
        data: Map<String, String> = HashMap()
    ) {
        //todo segregate the NS according their type
        val NS_TYPE = data[getString(R.string.type).toLowerCase()]
        var MEETING_ID = data[getString(R.string.meetid)]
        MyApp.recordId = MEETING_ID!!
        when (NS_TYPE) {
            getString(R.string.ns_type_call) -> createNotification4Call(data)
            getString(R.string.ns_type_ack) -> createNotification4Ack(data)
            getString(R.string.ns_type_applog) -> createNSForAppLogs(data)
        }
    }

    @SuppressLint("RestrictedApi")
    private fun createNotification4Call(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = 9090
        var MEETING_ID = data[getString(R.string.meetid)]
        val USER_NAME = data[getString(R.string.username)]
        val DOC_ID = data[getString(R.string.docId)]
        val DOC_PIC = data[getString(R.string.docPic)]
        val PAT_ID = data[getString(R.string.pat_id)]
        val PAT_NAME = data[getString(R.string.pat_name)]
        val PAT_PIC = data[getString(R.string.pat_pic)]
        val CallType = data[getString(R.string.callType)]
        val isWeb = data[getString(R.string.web)]
        val NS_TIMEOUT = 30 * 1000L
        val _sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.helium)

        //listen for doctor event
        listenEvent(id = MEETING_ID!!, nsId = NS_ID)

        val declineIntent = Intent(applicationContext, DeclineReciver::class.java)
        declineIntent.putExtra(getString(R.string.nsid), NS_ID)
        val declinePendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            0,
            declineIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )

        val acceptIntent = Intent(applicationContext, AcceptReceiver::class.java)
        acceptIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptIntent.putExtra(getString(R.string.meetid), "$MEETING_ID")
        acceptIntent.putExtra(getString(R.string.username), "$USER_NAME")
        acceptIntent.putExtra(getString(R.string.docId), "$DOC_ID")
        acceptIntent.putExtra(getString(R.string.docPic), "$DOC_PIC")
        acceptIntent.putExtra(getString(R.string.pat_id), "$PAT_ID")
        acceptIntent.putExtra(getString(R.string.pat_name), "$PAT_NAME")
        acceptIntent.putExtra(getString(R.string.pat_pic), "$PAT_PIC")
        acceptIntent.putExtra(getString(R.string.callType), "$CallType")
        acceptIntent.putExtra(getString(R.string.web), "$isWeb")
        val acceptPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            0,
            acceptIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )

        val fullScreenIntent = Intent(this, NotificationActivity::class.java)
            .putExtra(getString(R.string.username), USER_NAME)
            .putExtra(getString(R.string.docId), DOC_ID)
            .putExtra(getString(R.string.docPic), DOC_PIC)
            .putExtra(getString(R.string.meetid), MEETING_ID)
            .putExtra(getString(R.string.nsid), NS_ID)
            .putExtra(getString(R.string.pat_id), PAT_ID)
            .putExtra(getString(R.string.pat_name), PAT_NAME)
            .putExtra(getString(R.string.pat_pic), PAT_PIC)
            .putExtra(getString(R.string.callType), CallType)
            .putExtra(getString(R.string.web), "$isWeb")
        val fullScreenPendingIntent = PendingIntent.getActivity(
            this, 0,
            fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val isChannelExists = manager.getNotificationChannel(CHANNEL_INCOMING)
            if (isChannelExists != null) {
                manager.deleteNotificationChannel(CHANNEL_INCOMING)
            }
            val channelCall = NotificationChannel(
                CHANNEL_INCOMING,
                getString(R.string.channel_call),
                NotificationManager.IMPORTANCE_HIGH
            )
            channelCall.description = getString(R.string.channel_incoming_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCall.setSound(_sound, attributes)
            manager.createNotificationChannel(channelCall)
        }


        var notification = NotificationCompat.Builder(this, CHANNEL_INCOMING)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setContentIntent(fullScreenPendingIntent)
            .addAction(R.drawable.ic_call, getString(R.string.ns_act_accept), acceptPendingIntent)
            .addAction(
                R.drawable.ic_decline,
                getString(R.string.ns_act_decline),
                declinePendingIntent
            )
            .setAutoCancel(true)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setSound(_sound)
            .setOngoing(true)
            .setTimeoutAfter(NS_TIMEOUT)
            .setOnlyAlertOnce(false)
            .build()

        notification.flags = Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            AutoDismissNotification().setAlarm(this, NS_ID, NS_TIMEOUT)
        }

        /*
        Thread {
            Thread.sleep(NS_TIMEOUT)
            if(MyApp.isMissedNSShown){
                createNotification4MissedCall(USER_NAME!!)
            }else{
                MyApp.isMissedNSShown=true
            }
        }.start()*/
    }

    private fun listenEvent(id: String, nsId: Int) {
        try {
            val docRef = FirebaseFirestore.getInstance().collection("call_log").document(id)
            docRef.addSnapshotListener { snapshot, e ->
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e)
                    return@addSnapshotListener
                }

                if (snapshot != null && snapshot.exists()) {
                    Log.d(TAG, "Current data: ${snapshot.data}")
                    if (snapshot.data?.get("call_status") == "call_ended_by_user") {
                        val nsManager: NotificationManagerCompat =
                            NotificationManagerCompat.from(this)
                        nsManager.cancel(nsId)
                    }
                } else {
                    Log.d(TAG, "Current data: null")
                }
            }
        } catch (e: Exception) {
            print("${e.message} was thrown")
        }
    }

    private fun createNotification4Ack(data: Map<String, String> = HashMap()) {
        //createNotificationCancelAppointment(data)
        if (data[Constants.PROP_TEMP_NAME] == Constants.PROP_DOC_CANCELLATION || data[Constants.PROP_TEMP_NAME] == Constants.PROP_DOC_RESCHDULE) {
            createNotificationCancelAppointment(data)
        }
//        else if(data["templateName"]=="GoFHBPatientOnboardingByDoctor" || data["templateName"]=="GoFHBPatientOnboardingByHospital"){
//            docOnBoardNotification(data)
//        }
        else if (data["templateName"] == "MyFHBMissedCall") {
            createNotification4MissedCall(data)
        } else if (data["templateName"] == "chat") {
            createNotification4Chat(data)
        } else if ((data["templateName"] == "DoctorPatientAssociation") || (data["templateName"] == "QurplanCargiverPatientAssociation")) {
            createNotification4DocAndPatAssociation(data)
        } else if (data["templateName"] == "MissingActivitiesReminder") {
            createNotification4MissedEvents(data)
        } else if (data[Constants.PROB_EXTERNAL_LINK] != null && data[Constants.PROB_EXTERNAL_LINK] != "") {
            openURLFromNotification(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "mycartdetails") {
            renewNotification(data)
        } else {
            val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
            val NS_ID = System.currentTimeMillis().toInt()
            val MEETING_ID = data[getString(R.string.meetid)]
            val USER_NAME = data[getString(R.string.username)]
            //val PAT_NAME = data[getString(R.string.pat_name)]
            val ack_sound: Uri =
                Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val manager = getSystemService(NotificationManager::class.java)
                val channelAck = NotificationChannel(
                    CHANNEL_ACK,
                    getString(R.string.channel_ack),
                    NotificationManager.IMPORTANCE_DEFAULT
                )
                channelAck.description = getString(R.string.channel_ack_desc)
                val attributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
                channelAck.setSound(ack_sound, attributes)
                manager.createNotificationChannel(channelAck)
            }

            val onTapNS = Intent(applicationContext, OnTapNotification::class.java)
            onTapNS.putExtra(getString(R.string.nsid), NS_ID)
            onTapNS.putExtra(getString(R.string.meetid), "$MEETING_ID")
            onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
            //onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
            onTapNS.putExtra(Constants.PROP_DATA, data[Constants.PROP_DATA])
            onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
            onTapNS.putExtra(Constants.PROP_HRMID, data[Constants.PROP_HRMID])
            onTapNS.putExtra(Constants.PROP_RAWBODY, data[Constants.PROP_RAWBODY])
            onTapNS.putExtra(Constants.PROP_RAWTITLE, data[Constants.PROP_RAWTITLE])
//            onTapNS.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
//            onTapNS.putExtra(getString(R.string.pat_name), PAT_NAME)
            val onTapPendingIntent = PendingIntent.getBroadcast(
                applicationContext,
                NS_ID,
                onTapNS,
                PendingIntent.FLAG_CANCEL_CURRENT
            )


            var notification = NotificationCompat.Builder(this, CHANNEL_ACK)
                .setSmallIcon(R.mipmap.app_ns_icon)
                .setLargeIcon(
                    BitmapFactory.decodeResource(
                        applicationContext.resources,
                        R.mipmap.ic_launcher
                    )
                )
                .setContentTitle(data[getString(R.string.pro_ns_title)])
                .setContentText(data[getString(R.string.pro_ns_body)])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setContentIntent(onTapPendingIntent)
                .setStyle(
                    NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
                )
                .setSound(ack_sound)
                .setAutoCancel(true)
                .build()
            nsManager.notify(NS_ID, notification)
        }
    }

    private fun createNotification4MissedCall(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val _sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelCallAlert = NotificationChannel(
                CHANNEL_MISS_CALL,
                getString(R.string.channel_miss_ns),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channelCallAlert.description = getString(R.string.channel_call_alert_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCallAlert.setSound(_sound, attributes)
            manager.createNotificationChannel(channelCallAlert)
        }


        var notification = NotificationCompat.Builder(this, CHANNEL_MISS_CALL)
            .setSmallIcon(android.R.drawable.stat_notify_missed_call)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(_sound)
            .setAutoCancel(false)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .build()
        nsManager.notify(NS_ID, notification)
    }

    private fun createNotificationCancelAppointment(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val MEETING_ID = data[getString(R.string.meetid)]
        val DOC_ID = data[getString(R.string.docId)]
        val TEMP_NAME = data[Constants.PROP_TEMP_NAME]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelCancelApps = NotificationChannel(
                CHANNEL_CANCEL_APP,
                getString(R.string.channel_cancel_apps),
                NotificationManager.IMPORTANCE_HIGH
            )
            channelCancelApps.description = getString(R.string.channel_cancel_apps_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCancelApps.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelCancelApps)
        }

        val cancelAppointmentIntent = Intent(applicationContext, CancelAppointment::class.java)
        cancelAppointmentIntent.putExtra(getString(R.string.nsid), NS_ID)
        cancelAppointmentIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_DOC_CANCELLATION)
        cancelAppointmentIntent.putExtra(Constants.PROP_BookingId, data[Constants.PROP_BookingId])
        cancelAppointmentIntent.putExtra(
            Constants.PROP_PlannedStartTime,
            data[Constants.PROP_PlannedStartTime]
        )
        cancelAppointmentIntent.putExtra(Constants.PROP_TEMP_NAME, TEMP_NAME)
        val cancelAppointmentPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            cancelAppointmentIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        val rescheduleIntent = Intent(applicationContext, RescheduleAppointment::class.java)
        rescheduleIntent.putExtra(getString(R.string.nsid), NS_ID)
        rescheduleIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_DOC_RESCHDULE)
        rescheduleIntent.putExtra(Constants.PROP_docSessionId, data[Constants.PROP_docSessionId])
        rescheduleIntent.putExtra(Constants.PROP_BookingId, data[Constants.PROP_BookingId])
        rescheduleIntent.putExtra(Constants.PROP_healthOrgId, data[Constants.PROP_healthOrgId])
        rescheduleIntent.putExtra(Constants.PROP_docId, data[Constants.PROP_docId])
        rescheduleIntent.putExtra(Constants.PROP_TEMP_NAME, TEMP_NAME)
        val reschedulePendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            rescheduleIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_CANCEL_APP)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setWhen(0)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .addAction(
                R.drawable.ic_cancel_app,
                getString(R.string.ns_act_cancel),
                cancelAppointmentPendingIntent
            )
            .addAction(
                R.drawable.ic_reschedule,
                getString(R.string.ns_act_reschedule),
                reschedulePendingIntent
            )
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
    }

    private fun docOnBoardNotification(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelCancelApps = NotificationChannel(
                CHANNEL_ONBOARD,
                getString(R.string.channel_onboard),
                NotificationManager.IMPORTANCE_HIGH
            )
            channelCancelApps.description = getString(R.string.channel_onboard_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCancelApps.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelCancelApps)
        }

        val acceptIntent = Intent(applicationContext, Accept::class.java)
        acceptIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_ACCEPT)
        acceptIntent.putExtra(Constants.PROP_PROVIDER_REQID, data[Constants.PROP_PROVIDER_REQID])
        val acceptPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            acceptIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        val declineIntent = Intent(applicationContext, Decline::class.java)
        declineIntent.putExtra(getString(R.string.nsid), NS_ID)
        declineIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_DECLINE)
        declineIntent.putExtra(Constants.PROP_PROVIDER_REQID, data[Constants.PROP_PROVIDER_REQID])
        val declinePendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            declineIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_ONBOARD)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setWhen(0)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .addAction(R.drawable.ic_decline_doc, Constants.PROP_DECLINE, declinePendingIntent)
            .addAction(R.drawable.ic_add_doc, Constants.PROP_ACCEPT, acceptPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
    }

    private fun createNotification4Chat(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val MEETING_ID = data[getString(R.string.meetid)]
        val USER_NAME = data[getString(R.string.username)]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(
                CHANNEL_ACK,
                getString(R.string.channel_ack),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelAck)
        }

        val onTapNS = Intent(applicationContext, OnTapNotification::class.java)
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(getString(R.string.meetid), "chat")
        onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
        val onTapPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_ACK)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setContentIntent(onTapPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        nsManager.notify(NS_ID, notification)
    }

    private fun createNotification4DocAndPatAssociation(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val template = data[getString(R.string.pro_templateName)]
        val _docId = data[getString(R.string.docId)]
        val _docName = data[getString(R.string.docName)]
        val _docPic = data[getString(R.string.docPic)]
        val _patId = data[getString(R.string.pat_id)]
        val _patName = data[getString(R.string.pat_name)]
        val _patPic = data[getString(R.string.pat_pic)]
        val _message = data[getString(R.string.message)]
        val _redirectTo = data[Constants.PROP_REDIRECT_TO]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(
                CHANNEL_ACK,
                getString(R.string.channel_ack),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelAck)
        }

        val onTapNS = Intent(applicationContext, OnTapNotification::class.java)
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(getString(R.string.docId), _docId)
        onTapNS.putExtra(getString(R.string.docPic), _docPic)
        onTapNS.putExtra(getString(R.string.docName), _docName)
        onTapNS.putExtra(getString(R.string.pat_id), _patId)
        onTapNS.putExtra(getString(R.string.pat_pic), _patPic)
        onTapNS.putExtra(getString(R.string.pat_name), _patName)
        onTapNS.putExtra(getString(R.string.message), _message)
        onTapNS.putExtra(Constants.PROP_DATA, template)
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, _redirectTo)
        val onTapPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_ACK)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setContentIntent(onTapPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        nsManager.notify(NS_ID, notification)
    }

    private fun createNotification4MissedEvents(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val template = data[getString(R.string.pro_templateName)]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(
                CHANNEL_ACK,
                getString(R.string.channel_ack),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelAck)
        }

        val onTapNS = Intent(applicationContext, OnTapNotification::class.java)
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Constants.PROP_DATA, template)
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.PROP_EVEID, data[Constants.PROP_EVEID])
        val onTapPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_ACK)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setContentIntent(onTapPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        nsManager.notify(NS_ID, notification)
    }


    private fun renewNotification(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val PAT_NAME = data[getString(R.string.pat_name)]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelCancelApps = NotificationChannel(
                CHANNEL_RENEW,
                getString(R.string.channel_renew),
                NotificationManager.IMPORTANCE_HIGH
            )
            channelCancelApps.description = getString(R.string.channel_renew_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCancelApps.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelCancelApps)
        }

        val renewIntent = Intent(applicationContext, Renew::class.java)
        renewIntent.putExtra(getString(R.string.nsid), NS_ID)
        renewIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_RENEW)
        renewIntent.putExtra(Constants.PROP_PLANID, data[Constants.PROP_PLANID])
        renewIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])
        renewIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        renewIntent.putExtra(getString(R.string.pat_name), PAT_NAME)
        val renewPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            renewIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )

        val callBackIntent = Intent(applicationContext, Callback::class.java)
        callBackIntent.putExtra(getString(R.string.nsid), NS_ID)
        callBackIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_CALLBACK)
        callBackIntent.putExtra(Constants.PROP_PLANID, data[Constants.PROP_PLANID])
        callBackIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])
        callBackIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        callBackIntent.putExtra(getString(R.string.pat_name), PAT_NAME)
        val callBackPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            callBackIntent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_RENEW)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setWhen(0)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .addAction(android.R.drawable.ic_menu_rotate, Constants.PROP_RENEW, renewPendingIntent)
            .addAction(android.R.drawable.ic_menu_help, Constants.PROP_CALLBACK, callBackPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
    }


    private fun openURLFromNotification(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val template = data[getString(R.string.pro_templateName)]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(
                CHANNEL_ACK,
                getString(R.string.channel_ack),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelAck)
        }

        val onTapNS = Intent(applicationContext, OnTapNotification::class.java)
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Constants.PROB_EXTERNAL_LINK, data[Constants.PROB_EXTERNAL_LINK])
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        val onTapPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_CANCEL_CURRENT
        )
        var notification = NotificationCompat.Builder(this, CHANNEL_ACK)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setContentIntent(onTapPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        nsManager.notify(NS_ID, notification)
    }

    private fun createNSForAppLogs(data: Map<String, String> = HashMap()){
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(
                CHANNEL_ACK,
                getString(R.string.channel_ack),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelAck)
        }

        val onTapNS = Intent(applicationContext, OnTapNotification::class.java)
        onTapNS.putExtra(getString(R.string.ns_type_applog), getString(R.string.ns_type_applog))
        val onTapPendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_CANCEL_CURRENT
        )


        var notification = NotificationCompat.Builder(this, CHANNEL_ACK)
            .setSmallIcon(R.mipmap.app_ns_icon)
            .setLargeIcon(
                BitmapFactory.decodeResource(
                    applicationContext.resources,
                    R.mipmap.ic_launcher
                )
            )
            .setContentTitle(data[getString(R.string.pro_ns_title)])
            .setContentText(data[getString(R.string.pro_ns_body)])
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setContentIntent(onTapPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        nsManager.notify(NS_ID, notification)
    }

}

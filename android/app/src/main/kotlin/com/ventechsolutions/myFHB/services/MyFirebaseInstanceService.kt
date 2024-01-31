package com.ventechsolutions.myFHB.services

import android.annotation.SuppressLint
import android.app.*
import android.app.ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.ventechsolutions.myFHB.MainActivity
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.NotificationActivity
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants
import com.ventechsolutions.myFHB.constants.Constants.PROP_TEMP_NAME


class MyFirebaseInstanceService : FirebaseMessagingService() {
    val CHANNEL_INCOMING = "cha_call"
    val CHANNEL_ACK = "cha_ack"
    val CareGiverTransportRequestReminder = "CareGiverTransportRequestReminder"
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
        Log.d(TAG, "Data: " + remoteMessage.data)
        Log.d(TAG, "Notification: " + remoteMessage.notification)
        Log.d(TAG, "Notification: " + remoteMessage.rawData)
        // Check if message contains a data payload.
       /* if (remoteMessage.data.isNotEmpty()) {
            createNotification(data = remoteMessage.data)
        }
        if (remoteMessage.notification != null) {
            val t = remoteMessage.notification!!.title
            val b = remoteMessage.notification!!.body
            if (t != null && b != null) {
                createNotification(title = t, body = b)
            }
        }*/

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
        if (MEETING_ID != null) {
            MyApp.recordId = MEETING_ID
        }
        when (NS_TYPE) {
            getString(R.string.ns_type_call) -> createNotification4Call(data)
            getString(R.string.ns_type_ack) -> createNotification4Ack(data)
            getString(R.string.ns_type_applog) -> createNSForAppLogs(data)
        }
    }


    @SuppressLint("RestrictedApi")
    private fun createNotification4Call(data: Map<String, String> = HashMap()) {
        Log.e("Notification", "createNotification4Call")
//        val nsManager: NotificationManager = NotificationManager.from(this)
        val nsManager: NotificationManager = this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        try {
            val _sound: Uri =
                    Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.helium)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val importance = NotificationManager.IMPORTANCE_HIGH
                val notificationChannel = NotificationChannel(
                        "call",
                        "NOTIFICATION_CALL",
                        NotificationManager.IMPORTANCE_HIGH
                )
                notificationChannel.enableLights(true)
                notificationChannel.lightColor = Color.RED
                notificationChannel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                notificationChannel.enableVibration(true)
                notificationChannel.vibrationPattern = longArrayOf(100, 200, 300, 400, 500, 400, 300, 200, 400)
                if (_sound != null) {
                    val audioAttributes = AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)

                            .build()
                    notificationChannel.setSound(_sound, audioAttributes)
                } else {
                    Log.e("Notification", "createNotification4Call: error sound")
                }
                nsManager.createNotificationChannel(notificationChannel)
            }

            val NS_ID = 9090
            var MEETING_ID = data[getString(R.string.meetid)]
            var USER_NAME = data["userName"]
            if(USER_NAME==null||USER_NAME=="null"){
                USER_NAME = data[getString(R.string.username)]
            }
            val DOC_ID = data[getString(R.string.docId)]
            val DOC_PIC = data[getString(R.string.docPic)]
            val PAT_ID = data[getString(R.string.pat_id)]
            val PAT_NAME = data[getString(R.string.pat_name)]
            val PAT_PIC = data[getString(R.string.pat_pic)]?:""
            val CallType = data[getString(R.string.callType)]
            val isWeb = data[getString(R.string.web)]
            val NS_TIMEOUT = 30 * 1000L

            //listen for doctor event
            listenEvent(id = MEETING_ID!!, nsId = NS_ID)

            val declineIntent = Intent(applicationContext, DeclineReciver::class.java)
            declineIntent.putExtra(getString(R.string.nsid), NS_ID)

            val declinePendingIntent = PendingIntent.getBroadcast(
                applicationContext,
                NS_ID,
                declineIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val acceptIntent = Intent(applicationContext, MainActivity::class.java)
            acceptIntent.action = Intent.ACTION_SEND
            acceptIntent.type=Constants.TXT_PLAIN
            acceptIntent.putExtra(getString(R.string.nsid), NS_ID)
            acceptIntent.putExtra(Intent.EXTRA_TEXT, "$MEETING_ID")
            acceptIntent.putExtra(getString(R.string.username), "$USER_NAME")
            acceptIntent.putExtra(getString(R.string.docId), "$DOC_ID")
            acceptIntent.putExtra(getString(R.string.docPic), "$DOC_PIC")
            acceptIntent.putExtra(getString(R.string.pat_id), "$PAT_ID")
            acceptIntent.putExtra(getString(R.string.pat_name), "$PAT_NAME")
            acceptIntent.putExtra(getString(R.string.pat_pic), "$PAT_PIC")
            acceptIntent.putExtra(getString(R.string.callType), "$CallType")
            acceptIntent.putExtra(getString(R.string.web), "$isWeb")

            val acceptPendingIntent = PendingIntent.getActivity(
                this,
                NS_ID,
                acceptIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                    .putExtra(getString(R.string.pro_ns_body), data[getString(R.string.pro_ns_body)])


            val fullScreenPendingIntent = PendingIntent.getActivity(
                this,
                NS_ID,
                fullScreenIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                channelCall.enableVibration(true)
                channelCall.setSound(_sound, attributes)
                manager.createNotificationChannel(channelCall)
            }


            var notification = NotificationCompat.Builder(this, "call")
                    .setSmallIcon(android.R.drawable.ic_menu_call)
                    .setLargeIcon(
                            BitmapFactory.decodeResource(
                                    applicationContext.resources,
                                    R.mipmap.ic_launcher
                            )
                    )
                    .setContentTitle(data[getString(R.string.pro_ns_title)])
                    .setContentText(data[getString(R.string.pro_ns_body)])
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .setContentIntent(fullScreenPendingIntent)
                    .addAction(R.drawable.ic_call, getString(R.string.ns_act_accept), acceptPendingIntent)
                    .addAction(
                            R.drawable.ic_decline,
                            getString(R.string.ns_act_decline),
                            declinePendingIntent
                    )
                    .setAutoCancel(true)
                    .setDefaults(Notification.DEFAULT_SOUND)
                    .setFullScreenIntent(fullScreenPendingIntent, true)
                    .setOngoing(true)
                    .setVisibility(Notification.VISIBILITY_PUBLIC)
                    .setTimeoutAfter(NS_TIMEOUT)
                    .setSound(_sound)
                    .setOnlyAlertOnce(false)
                    .build()

           // notification.flags = Notification.FLAG_INSISTENT
            nsManager.notify(NS_ID, notification)
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                AutoDismissNotification().setAlarm(this, NS_ID, NS_TIMEOUT)
            }

        } catch (e: Exception) {
            Log.e("Notification", "createNotification4Call error")

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
                    } else if (snapshot.data?.get("call_status") == "accept") {
                        val nsManager: NotificationManagerCompat =
                                NotificationManagerCompat.from(this)
                        nsManager.cancel(nsId)
                    } else if (snapshot.data?.get("call_status") == "decline") {
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
        Log.e("notification data", data.toString())
        //createNotificationCancelAppointment(data)
        print(data[Constants.PROP_REDIRECT_TO])

        if (data["isSheela"] != null && data["isSheela"] == "true") {
            createNotificationForSheela(data)
        }
        else if (data[Constants.PROP_TEMP_NAME] == Constants.PROP_DOC_CANCELLATION || data[Constants.PROP_TEMP_NAME] == Constants.PROP_DOC_RESCHDULE) {
            createNotificationCancelAppointment(data)
        }
//        else if(data["templateName"]=="GoFHBPatientOnboardingByDoctor" || data["templateName"]=="GoFHBPatientOnboardingByHospital"){
//            docOnBoardNotification(data)
//        }
        else if (data["templateName"] == "MyFHBMissedCall") {
            createNotification4MissedCall(data)
        } else if (data["templateName"] == "acceptandreject") {
            createNotification4MissedCall(data)
        } else if (data["templateName"] == "familyMemberCaregiverRequest") {
            createNotificationAcceptAndReject(data)
        } else if (data["templateName"] == "chat") {
            createNotification4Chat(data)
        } else if (data["templateName"]?.contains("associationNotificationToCaregiver") == true) {
            showViewMemberAndCommunicationButtonNotification(data)
        } else if ((data["templateName"] == "DoctorPatientAssociation") || (data["templateName"] == "QurplanCargiverPatientAssociation")) {
            createNotification4DocAndPatAssociation(data)
        } else if (data["templateName"] == "MissingActivitiesReminder") {
            createNotification4MissedEvents(data)
        } else if (data["templateName"] == "notifyCaregiverForMedicalRecord") {
            createNotificationCaregiverForMedicalRecord(data)
            //<-Test Notification->
        } else if ((data["templateName"] == "careGiverTransportRequestReminder") || (data[Constants.PROP_TEMP_NAME] == getString(R.string.voice_clone_patient_assignment))) {
            // Handle the case when the templateName is "careGiverTransportRequestReminder"
            // OR when PROP_TEMP_NAME is equal to the string resource "voice_clone_patient_assignment"

            careGiverTransportRequestReminder(data)
        }else if (data[Constants.PROB_EXTERNAL_LINK] != null && data[Constants.PROB_EXTERNAL_LINK] != "") {
            openURLFromNotification(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "mycartdetails") {
            renewNotification(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "myplandetails") {
            myPlanDetailsNotification(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "claimList") {
            claimDetailsNotification(data)
        } else if (data[Constants.PROP_REDIRECT_TO]?.contains("myRecords") == true) {
            myRecordsNotification(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "chat") {
            createNotification4Chat(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "escalateToCareCoordinatorToRegimen") {
            createNotificationEscalate(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "appointmentPayment") {
            createNotificationForAppointmentPayment(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "mycart") {
            createNotificationForPlanPayment(data)
        } else if (data[Constants.PROP_REDIRECT_TO] == "familyProfile") {
            createNotificationForFamilyAddition(data)
        } else if (data[Constants.PROP_TEMP_NAME] == "qurbookServiceRequestStatusUpdate") {
            createNotificationForPartnerServiceTicketDetail(data)
        }else if (data[Constants.PROP_TEMP_NAME] == "notifyPatientServiceTicketByCC") {
            createNotificationForPartnerServiceTicketDetail(data)
        }else if (data[Constants.PROP_TEMP_NAME] == "patientReferralAcceptToPatient") {
            createNotificationForPatientAccept(data)
        }
         else {
             getRegularNotification(data)
        }
    }

    private fun createNotificationForSheela(data: Map<String, String>) {

        if (!Constants.foregroundActivityRef) {
            getRegularNotification(data)
        }
        else {
            getRegularNotification(data)
            val intent = Intent("remainderSheelaInvokeEvent")
            if (data[Constants.EVENT_TYPE] != null && data[Constants.EVENT_TYPE] == Constants.WRAPPERCALL) {
                intent.putExtra(Constants.PROP_REDIRECT_TO, "sheela")
                intent.putExtra(Constants.EVENT_TYPE, data[Constants.EVENT_TYPE])
                intent.putExtra(Constants.OTHERS, data[Constants.OTHERS])
                intent.putExtra(Constants.PROP_RAWTITLE, data[Constants.PROP_RAWTITLE])
                intent.putExtra(Constants.PROP_RAWBODY, data[Constants.PROP_RAWBODY])
                intent.putExtra(Constants.NOTIFICATIONLISTID, data[Constants.NOTIFICATIONLISTID])
            }else {
                intent.putExtra(Constants.PROP_REDIRECT_TO, "isSheelaFollowup")
                intent.putExtra("message", data[getString(R.string.pro_ns_body)])
                // template name is for appointment reminder 5 mins before from api
                intent.putExtra("templateName", data[PROP_TEMP_NAME])
                intent.putExtra(Constants.APPOINTMENTID, data[Constants.APPOINTMENTID])
                intent.putExtra(Constants.eidSheela, data[Constants.eidSheela])
                intent.putExtra("rawMessage", data[getString(R.string.pro_ns_raw)])
                intent.putExtra("sheelaAudioMsgUrl", data[getString(R.string.pro_ns_audioURL)])
                // event id for sheela queue appointment reminder
                intent.putExtra("eventId", data[getString(R.string.eventId)])
            }
            this.sendBroadcast(intent)
        }
    }

    private  fun getRegularNotification(data: Map<String, String> = HashMap()){
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
//            if (nsManager != null) {
//                val channelList: List<NotificationChannel> =
//                    nsManager.getNotificationChannels()
//                var i = 0
//                while (channelList != null && i < channelList.size) {
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                        nsManager.deleteNotificationChannel(channelList[i].id)
//                    }
//                    i++
//                }
//            }
        val NS_ID = System.currentTimeMillis().toInt()
        val MEETING_ID = data[getString(R.string.meetid)]
        val USER_NAME = data[getString(R.string.username)]
        val notificationListId = data[getString(R.string.notificationListId)]
        //val PAT_NAME = data[getString(R.string.pat_name)]
        var ack_sound: Uri
        var channelId = "";
        var channelName = "";
//            if(data[Constants.ACTIVITY_NAME]!=null&&data[Constants.ACTIVITY_NAME].equals("Mandatory",ignoreCase = true)){
////                ack_sound=Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.beep_beep)
//                ack_sound=Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/raw/beep_beep")
//                channelId="mandatory_a_"+CHANNEL_ACK
//                channelName=getString(R.string.mandatory_channel_ack)
//            }else{
        ack_sound = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        channelId = CHANNEL_ACK
        channelName = getString(R.string.channel_ack)
//            }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelAck = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_HIGH
            )
            channelAck.description = getString(R.string.channel_ack_desc)
            val attributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelAck.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelAck)
        }

        val onTapNS = Intent(applicationContext, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(getString(R.string.meetid), "$MEETING_ID")
        onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
        onTapNS.putExtra(getString(R.string.notificationListId), "$notificationListId")
        //onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
        onTapNS.putExtra(Constants.PROP_DATA, data[Constants.PROP_DATA])
        //onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])

        onTapNS.putExtra(Constants.PROP_HRMID, data[Constants.PROP_HRMID])
        onTapNS.putExtra(Constants.PROP_RAWBODY, data[Constants.PROP_RAWBODY])
        onTapNS.putExtra(Constants.PROP_RAWTITLE, data[Constants.PROP_RAWTITLE])
        onTapNS.putExtra(getString(R.string.message), data[getString(R.string.pro_ns_body)].toString())
        onTapNS.putExtra(Constants.PROP_sheelaAudioMsgUrl, data[Constants.PROP_sheelaAudioMsgUrl])
        onTapNS.putExtra(Constants.PROP_ISSHEELA, data[Constants.PROP_ISSHEELA])
        onTapNS.putExtra(Constants.OTHERS, data[Constants.OTHERS])
        onTapNS.putExtra(Constants.EVENT_TYPE, data[Constants.EVENT_TYPE])

        // apppointmnetid and eid for sheela queue feature to flutter(appointmnet reminder from api)
        onTapNS.putExtra(Constants.APPOINTMENTID, data[Constants.APPOINTMENTID])
        onTapNS.putExtra(Constants.eidSheela, data[Constants.eidSheela])

//            onTapNS.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
//            onTapNS.putExtra(getString(R.string.pat_name), PAT_NAME)

        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )





        var notification = NotificationCompat.Builder(this, channelId)
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

    private fun showViewMemberAndCommunicationButtonNotification(data: Map<String, String> = HashMap()) {
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

        val viewMemberIntent = Intent(applicationContext, MainActivity::class.java)
        viewMemberIntent.action = Intent.ACTION_SEND
        viewMemberIntent.type=Constants.TXT_PLAIN
        viewMemberIntent.putExtra(getString(R.string.nsid), NS_ID)
        viewMemberIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        viewMemberIntent.putExtra(Constants.PROP_REDIRECT_TO, "careGiverMemberProfile")
        viewMemberIntent.putExtra(Constants.PROP_CAREGIVER_REQUESTOR, data[Constants.PROP_CAREGIVER_REQUESTOR])
        viewMemberIntent.putExtra("type", "careGiverMemberProfile")

        val viewMemberPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            viewMemberIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )


        val communicationSettingIntent = Intent(applicationContext, MainActivity::class.java)
        communicationSettingIntent.action = Intent.ACTION_SEND
        communicationSettingIntent.type=Constants.TXT_PLAIN
        communicationSettingIntent.putExtra(getString(R.string.nsid), NS_ID)
        communicationSettingIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        communicationSettingIntent.putExtra(Constants.PROP_REDIRECT_TO, "communicationSetting")
        communicationSettingIntent.putExtra("type", "communicationSetting")

        val communicationSettingPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            communicationSettingIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_yes,
                        getString(R.string.ns_act_viewmember),
                        viewMemberPendingIntent
                )
                .addAction(
                        R.drawable.ic_yes,
                        getString(R.string.ns_act_communication_settings),
                        communicationSettingPendingIntent
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

    private fun createNotificationAcceptAndReject(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type= Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra("type", "accept")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data["templateName"])
        acceptCareGiverIntent.putExtra(Constants.PATIENT_PHONE_NUMBER, data[Constants.PATIENT_PHONE_NUMBER])
        acceptCareGiverIntent.putExtra(Constants.VERIFICATION_CODE, data[Constants.VERIFICATION_CODE])
        val acceptCareGiverPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            acceptCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        val rejectCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type= Constants.TXT_PLAIN
        rejectCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        rejectCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        rejectCareGiverIntent.putExtra("type", "reject")
        rejectCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data["templateName"])
        rejectCareGiverIntent.putExtra(Constants.PATIENT_PHONE_NUMBER, data[Constants.PATIENT_PHONE_NUMBER])
        rejectCareGiverIntent.putExtra(Constants.VERIFICATION_CODE, data[Constants.VERIFICATION_CODE])
        rejectCareGiverIntent.putExtra(Constants.CAREGIVER_RECEIVER, data[Constants.CAREGIVER_RECEIVER])
        rejectCareGiverIntent.putExtra(Constants.CAREGIVER_REQUESTER, data[Constants.CAREGIVER_REQUESTER])
        val rejectCareGiverPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            rejectCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_act_accept),
                        acceptCareGiverPendingIntent
                )
                .addAction(
                        R.drawable.ic_cancel_app,
                        getString(R.string.ns_act_reject),
                        rejectCareGiverPendingIntent
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

    private fun createNotificationEscalate(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type= Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        acceptCareGiverIntent.putExtra(Constants.CARE_COORDINATOR_USER_ID, data[Constants.CARE_COORDINATOR_USER_ID])
        acceptCareGiverIntent.putExtra(Constants.PATIENT_NAME, data[Constants.PATIENT_NAME])
        acceptCareGiverIntent.putExtra(Constants.CARE_GIVER_NAME, data[Constants.CARE_GIVER_NAME])
        acceptCareGiverIntent.putExtra(Constants.ACTIVITY_TIME, data[Constants.ACTIVITY_TIME])
        acceptCareGiverIntent.putExtra(Constants.ACTIVITY_NAME, data[Constants.ACTIVITY_NAME])
        acceptCareGiverIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        acceptCareGiverIntent.putExtra(Constants.PATIENT_PHONE_NUMBER, data[Constants.PATIENT_PHONE_NUMBER])
        acceptCareGiverIntent.putExtra(Constants.UID, data[Constants.UID])

        val acceptCareGiverPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            acceptCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_escalate),
                        acceptCareGiverPendingIntent
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

    private fun createNotificationCaregiverForMedicalRecord(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val chatWithCcIntent = Intent(applicationContext, MainActivity::class.java)
        chatWithCcIntent.action = Intent.ACTION_SEND
        chatWithCcIntent.type= Constants.TXT_PLAIN
        chatWithCcIntent.putExtra(getString(R.string.nsid), NS_ID)
        chatWithCcIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        chatWithCcIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_TEMP_NAME])
        chatWithCcIntent.putExtra(Constants.CARE_COORDINATOR_USER_ID, data[Constants.CARE_COORDINATOR_USER_ID])
        chatWithCcIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        chatWithCcIntent.putExtra(Constants.PATIENT_NAME, data[Constants.PATIENT_NAME])
        chatWithCcIntent.putExtra(Constants.IS_CARE_GIVER, data[Constants.IS_CARE_GIVER])
        chatWithCcIntent.putExtra(Constants.DELIVERED_DATE_TIME, data[Constants.DELIVERED_DATE_TIME])
        chatWithCcIntent.putExtra(Constants.IS_FROM_CARE_COORDINATOR, data[Constants.IS_FROM_CARE_COORDINATOR])
        chatWithCcIntent.putExtra(Constants.SENDER_PROFILE_PIC, data[Constants.SENDER_PROFILE_PIC])


        val onTapNS = Intent(this, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Intent.EXTRA_TEXT, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.PROP_PRESCRIPTION_ID, data[Constants.PROP_REDIRECT_TO]?.split("|")?.get(2))
        onTapNS.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        onTapNS.putExtra(Constants.PROB_PATIENT_NAME, data[Constants.PROB_PATIENT_NAME])
        val onTapPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        val chatWithCcPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            chatWithCcIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_chat_with_cc),
                        chatWithCcPendingIntent
                )
                .addAction(
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_view_record),
                        onTapPendingIntent
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

    private fun createNotificationForAppointmentPayment(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type= Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        acceptCareGiverIntent.putExtra(Constants.APPOINTMENT_DATE, data[Constants.APPOINTMENT_DATE])
        acceptCareGiverIntent.putExtra(Constants.BOOKINGID, data[Constants.BOOKINGID])
        acceptCareGiverIntent.putExtra(Constants.MEETINGID, data[Constants.MEETINGID])
        acceptCareGiverIntent.putExtra(Constants.APPOINTMENTID, data[Constants.APPOINTMENTID])

        val acceptCareGiverPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            acceptCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_pay),
                        acceptCareGiverPendingIntent
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

    private fun createNotificationForPlanPayment(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type= Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        acceptCareGiverIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        acceptCareGiverIntent.putExtra(Constants.BOOKINGID, data[Constants.BOOKINGID])
        acceptCareGiverIntent.putExtra(Constants.CREATEDBY, data[Constants.CREATEDBY])
        acceptCareGiverIntent.putExtra(Constants.PAYMENTLINKVIAPUSH, data[Constants.PAYMENTLINKVIAPUSH])
        acceptCareGiverIntent.putExtra(Constants.CARTID, data[Constants.BOOKINGID])
        acceptCareGiverIntent.putExtra(Constants.PROB_PATIENT_NAME, data[Constants.PROB_PATIENT_NAME])
        val acceptCareGiverPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            acceptCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_pay),
                        acceptCareGiverPendingIntent
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

    private fun createNotificationForFamilyAddition(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type=Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        acceptCareGiverIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])

        val acceptCareGiverPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            acceptCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                        R.drawable.ic_reschedule,
                        getString(R.string.ns_viewdetails),
                        acceptCareGiverPendingIntent
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

        val cancelAppointmentIntent = Intent(applicationContext, MainActivity::class.java)
        cancelAppointmentIntent.action = Intent.ACTION_SEND
        cancelAppointmentIntent.type=Constants.TXT_PLAIN
        cancelAppointmentIntent.putExtra(getString(R.string.nsid), NS_ID)
        cancelAppointmentIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_DOC_CANCELLATION)
        cancelAppointmentIntent.putExtra(Constants.PROP_BookingId, data[Constants.PROP_BookingId])
        cancelAppointmentIntent.putExtra(
                Constants.PROP_PlannedStartTime,
                data[Constants.PROP_PlannedStartTime]
        )
        cancelAppointmentIntent.putExtra(Constants.PROP_TEMP_NAME, TEMP_NAME)

        val cancelAppointmentPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            cancelAppointmentIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )





        val rescheduleIntent = Intent(applicationContext, MainActivity::class.java)
        rescheduleIntent.action = Intent.ACTION_SEND
        rescheduleIntent.type=Constants.TXT_PLAIN
        rescheduleIntent.putExtra(getString(R.string.nsid), NS_ID)
        rescheduleIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_DOC_RESCHDULE)
        rescheduleIntent.putExtra(Constants.PROP_docSessionId, data[Constants.PROP_docSessionId])
        rescheduleIntent.putExtra(Constants.PROP_BookingId, data[Constants.PROP_BookingId])
        rescheduleIntent.putExtra(Constants.PROP_healthOrgId, data[Constants.PROP_healthOrgId])
        rescheduleIntent.putExtra(Constants.PROP_docId, data[Constants.PROP_docId])
        rescheduleIntent.putExtra(Constants.PROP_TEMP_NAME, TEMP_NAME)

        val reschedulePendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            rescheduleIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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

        val acceptIntent = Intent(applicationContext, MainActivity::class.java)
        acceptIntent.action = Intent.ACTION_SEND
        acceptIntent.type=Constants.TXT_PLAIN
        acceptIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_ACCEPT)
        acceptIntent.putExtra(Constants.PROP_PROVIDER_REQID, data[Constants.PROP_PROVIDER_REQID])
        val acceptPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            acceptIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )





        val declineIntent = Intent(applicationContext, MainActivity::class.java)
        declineIntent.action = Intent.ACTION_SEND
        declineIntent.type=Constants.TXT_PLAIN
        declineIntent.putExtra(getString(R.string.nsid), NS_ID)
        declineIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_DECLINE)
        declineIntent.putExtra(Constants.PROP_PROVIDER_REQID, data[Constants.PROP_PROVIDER_REQID])
        val declinePendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            declineIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
        val SENDER_ID = data[getString(R.string.senderId)]
        val SENDER_NAME = data[getString(R.string.senderName)]
        val SENDER_PROFILE = data[getString(R.string.senderProfilePic)]
        val GROUP_ID = data[getString(R.string.chatListId)]
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
        val onTapNS = Intent(this,MainActivity::class.java)
        onTapNS?.action = Intent.ACTION_SEND
        onTapNS?.type=Constants.TXT_PLAIN
        onTapNS?.putExtra(Intent.EXTRA_TEXT,"chat")
        onTapNS?.putExtra(getString(R.string.username),"$USER_NAME")
        onTapNS?.putExtra(getString(R.string.senderId),"$SENDER_ID")
        onTapNS?.putExtra(getString(R.string.senderName), "$SENDER_NAME")
        onTapNS?.putExtra(getString(R.string.senderProfilePic), "$SENDER_PROFILE")
        onTapNS?.putExtra(getString(R.string.chatListId), "$GROUP_ID")
        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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

        val onTapNS = Intent(applicationContext, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
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
        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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

        val onTapNS = Intent(applicationContext, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Constants.PROP_DATA, template)
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.PROP_EVEID, data[Constants.PROP_EVEID])
        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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

    private fun myRecordsNotification(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()

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

        val onTapNS = Intent(this, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
       // onTapNS.putExtra(Intent.EXTRA_TEXT, data[Constants.PROP_REDIRECT_TO])
       // onTapNS.putExtra(Constants.PROP_PRESCRIPTION_ID, data[Constants.PROP_REDIRECT_TO]?.split("|")?.get(2))
        onTapNS.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        onTapNS.putExtra(Constants.PROB_PATIENT_NAME, data[Constants.PROB_PATIENT_NAME])
        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                .setContentIntent(onTapPendingIntent)
                .setContentText(data[getString(R.string.pro_ns_body)])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setWhen(0)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setStyle(
                        NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
                )
                .setSound(ack_sound)
                .setAutoCancel(true)
                .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)

    }

    private fun claimDetailsNotification(data: Map<String, String> = HashMap()) {
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

        val onTapNS = Intent(this, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Intent.EXTRA_TEXT, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.PROP_CLAIM_ID, data[Constants.PROP_CLAIM_ID])
        onTapNS.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])

        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                .setContentIntent(onTapPendingIntent)
                .setContentText(data[getString(R.string.pro_ns_body)])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setWhen(0)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setStyle(
                        NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
                )
                .setSound(ack_sound)
                .setAutoCancel(true)
                .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
    }

    private fun myPlanDetailsNotification(data: Map<String, String> = HashMap()) {
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

        val onTapNS = Intent(this, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Intent.EXTRA_TEXT, Constants.MY_PLAN_DETAILS)
        onTapNS.putExtra(Constants.PROP_PLANID, data[Constants.PROP_PLANID])
        onTapNS.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])
        onTapNS.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        onTapNS.putExtra(getString(R.string.pat_name), PAT_NAME)

        val onTapPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                .setContentIntent(onTapPendingIntent)
                .setContentText(data[getString(R.string.pro_ns_body)])
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setWhen(0)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setStyle(
                        NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
                )
                .setSound(ack_sound)
                .setAutoCancel(true)
                .build()
        //notification.flags=Notification.FLAG_INSISTENT
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

        val renewIntent = Intent(applicationContext, MainActivity::class.java)
        renewIntent.action = Intent.ACTION_SEND
        renewIntent.type=Constants.TXT_PLAIN
        renewIntent.putExtra(getString(R.string.nsid), NS_ID)
        renewIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_RENEW)
        renewIntent.putExtra(Constants.PROP_PLANID, data[Constants.PROP_PLANID])
        renewIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])
        renewIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        renewIntent.putExtra(getString(R.string.pat_name), PAT_NAME)
        val renewPendingIntent = PendingIntent.getActivity(
            this,
            NS_ID,
            renewIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )




        val callBackIntent = Intent(applicationContext, MainActivity::class.java)
        callBackIntent.action = Intent.ACTION_SEND
        callBackIntent.type=Constants.TXT_PLAIN
        callBackIntent.putExtra(getString(R.string.nsid), NS_ID)
        callBackIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_CALLBACK)
        callBackIntent.putExtra(Constants.PROP_PLANID, data[Constants.PROP_PLANID])
        callBackIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])
        callBackIntent.putExtra(Constants.PROB_USER_ID, data[Constants.PROB_USER_ID])
        callBackIntent.putExtra(getString(R.string.pat_name), PAT_NAME)
        val callBackPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            callBackIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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

        val onTapNS = Intent(applicationContext, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Constants.PROB_EXTERNAL_LINK, data[Constants.PROB_EXTERNAL_LINK])
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        val onTapPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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

    private fun createNSForAppLogs(data: Map<String, String> = HashMap()) {
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

        val onTapNS = Intent(applicationContext, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type=Constants.TXT_PLAIN
        onTapNS.putExtra(getString(R.string.ns_type_applog), getString(R.string.ns_type_applog))
        val onTapPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            onTapNS,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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


    private fun createNotificationForPartnerServiceTicketDetail(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
        acceptCareGiverIntent.action = Intent.ACTION_SEND
        acceptCareGiverIntent.type=Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(getString(R.string.nsid), NS_ID)
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_TEMP_NAME])
        acceptCareGiverIntent.putExtra(Constants.PROP_UUID, data[Constants.PROB_USER_ID])
        acceptCareGiverIntent.putExtra(Constants.PROP_EVEID, data[Constants.PROP_EVEID])

        val acceptCareGiverPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            acceptCareGiverIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                .setStyle(
                        NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
                ).setContentIntent(acceptCareGiverPendingIntent)
                .setSound(ack_sound)
                .setAutoCancel(true)
                .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
    }

      private fun createNotificationForPatientAccept(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = System.currentTimeMillis().toInt()
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

        val acceptCareGiverIntent = Intent(applicationContext, MainActivity::class.java)
          acceptCareGiverIntent.action = Intent.ACTION_SEND
          acceptCareGiverIntent.type= Constants.TXT_PLAIN
        acceptCareGiverIntent.putExtra(Intent.EXTRA_TEXT, "ack")
        acceptCareGiverIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        acceptCareGiverIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])


          val acceptCareGiverPendingIntent = PendingIntent.getActivity(
              applicationContext,
              NS_ID,
              acceptCareGiverIntent,
              PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
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
                .setStyle(
                        NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
                ).setContentIntent(acceptCareGiverPendingIntent)
                .setSound(ack_sound)
                .setAutoCancel(true)
                .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)

    }

    private fun careGiverTransportRequestReminder(data: Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)

        // Determine the channelID based on the value of PROP_TEMP_NAME in data
        val channelID = when (data[Constants.PROP_TEMP_NAME]) {
            getString(R.string.voice_clone_patient_assignment) -> getString(R.string.voice_clone_patient_assignment)
            else -> CareGiverTransportRequestReminder
        }

        // Determine the channelName based on the value of PROP_TEMP_NAME in data
        val channelName = when (data[Constants.PROP_TEMP_NAME]) {
            getString(R.string.voice_clone_patient_assignment) -> getString(R.string.voice_clone_patient_assignment)
            else -> getString(R.string.transportation_appointment)
        }

        val NS_ID = System.currentTimeMillis().toInt()
        val PAT_NAME = data[getString(R.string.pat_name)]
        val ack_sound: Uri =
            Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            val channelCancelApps = NotificationChannel(
                channelID,
                channelName,
                NotificationManager.IMPORTANCE_HIGH
            )
            channelCancelApps.description = getString(R.string.channel_renew_desc)
            val attributes =
                AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channelCancelApps.setSound(ack_sound, attributes)
            manager.createNotificationChannel(channelCancelApps)
        }

        val renewIntent = Intent(applicationContext, MainActivity::class.java)
        // Set the action of the renewIntent to ACTION_CHOOSER for the accept status
        renewIntent.action = Intent.ACTION_CHOOSER
        renewIntent.type= Constants.TXT_PLAIN
        renewIntent.putExtra(getString(R.string.nsid), NS_ID)
        renewIntent.putExtra(Intent.EXTRA_TEXT, Constants.PROP_RENEW)
        renewIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        renewIntent.putExtra(Constants.PATIENT_ID, data[Constants.PATIENT_ID])
        renewIntent.putExtra(Constants.APPOINTMENTID, data[Constants.APPOINTMENTID])
        renewIntent.putExtra(Constants.STATUS,"accept")

        // Set the value of PROP_TEMP_NAME from data as an extra in the renewIntent
        renewIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])

        // Set the value of VOICECLONEID from data as an extra in the renewIntent
        renewIntent.putExtra(Constants.VOICECLONEID, data[Constants.VOICECLONEID])

        val renewPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            renewIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )





        val callBackIntent = Intent(applicationContext, MainActivity::class.java)
        // Set the action of the callBackIntent to ACTION_DELETE for the decline status
        callBackIntent.action = Intent.ACTION_DELETE
        callBackIntent.type= Constants.TXT_PLAIN
        callBackIntent.putExtra(getString(R.string.nsid), NS_ID)
        callBackIntent.putExtra(Intent.EXTRA_TEXT, Constants.APPOINTMENT_DETAIL)
        callBackIntent.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        callBackIntent.putExtra(Constants.PATIENT_ID, data[Constants.PATIENT_ID])
        callBackIntent.putExtra(Constants.APPOINTMENTID, data[Constants.APPOINTMENTID])
        callBackIntent.putExtra(Constants.STATUS,"decline")

        // Add PROP_TEMP_NAME as an extra to callBackIntent with the corresponding value from data
        callBackIntent.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])

        // Add VOICECLONEID as an extra to callBackIntent with the corresponding value from data
        callBackIntent.putExtra(Constants.VOICECLONEID, data[Constants.VOICECLONEID])

        val callBackPendingIntent = PendingIntent.getActivity(
            applicationContext,
            NS_ID,
            callBackIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )



        val onTapNS = Intent(applicationContext, MainActivity::class.java)
        onTapNS.action = Intent.ACTION_SEND
        onTapNS.type= Constants.TXT_PLAIN
        onTapNS.putExtra(getString(R.string.nsid), NS_ID)
        onTapNS.putExtra(Constants.PROP_DATA, data[Constants.PROP_DATA])
        onTapNS.putExtra(Constants.PROP_REDIRECT_TO, data[Constants.PROP_REDIRECT_TO])
        onTapNS.putExtra(Constants.APPOINTMENTID, data[Constants.APPOINTMENTID])
        // Add PROP_TEMP_NAME as an extra to onTapNS with the corresponding value from data
        onTapNS.putExtra(Constants.PROP_TEMP_NAME, data[Constants.PROP_TEMP_NAME])

        // Add VOICECLONEID as an extra to onTapNS with the corresponding value from data
        onTapNS.putExtra(Constants.VOICECLONEID, data[Constants.VOICECLONEID])



        // Create a PendingIntent based on the value of PROP_TEMP_NAME in data
        val onTapPendingIntent = when (data[Constants.PROP_TEMP_NAME]) {
            getString(R.string.voice_clone_patient_assignment) -> null // Set onTapPendingIntent to null when PROP_TEMP_NAME is a specific value
            else -> PendingIntent.getActivity(
                applicationContext,
                NS_ID,
                onTapNS,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
        }


        var notification = NotificationCompat.Builder(this, channelID)
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
            .setContentIntent(onTapPendingIntent)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .addAction(R.drawable.ic_add_doc, "Accept", renewPendingIntent)
            .addAction(R.drawable.ic_decline_doc, "Decline", callBackPendingIntent)
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(data[getString(R.string.pro_ns_body)])
            )
            .setSound(ack_sound)
            .setAutoCancel(true)
            .build()
        //notification.flags=Notification.FLAG_INSISTENT
        nsManager.notify(NS_ID, notification)
    }




}

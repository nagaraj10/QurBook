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
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(TAG, "Token: $token")
    }


    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d(TAG, "Data: " + remoteMessage.data)
        Log.d(TAG, "Notification: " + remoteMessage.notification)
        Log.d(TAG, "Notification: " + remoteMessage.rawData)
    }

    companion object {
        private const val TAG = "MyFirebaseInstanceIDSer"
    }
}

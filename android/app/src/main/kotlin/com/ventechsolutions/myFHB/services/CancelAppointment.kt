package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.firestore.FirebaseFirestore
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class CancelAppointment:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val bookingId = p1?.getStringExtra(Constants.PROP_CANCEL_KEY)
//        val username = p1?.getStringExtra(p0?.getString(R.string.username))
//        val docId = p1?.getStringExtra(p0?.getString(R.string.docId))
//        val docPic = p1?.getStringExtra(p0?.getString(R.string.docPic))
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type=Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,value)
        launchIntent?.putExtra(Constants.PROP_CANCEL_KEY,bookingId)
//        launchIntent?.putExtra(p0.getString(R.string.username),username)
//        launchIntent?.putExtra(p0.getString(R.string.docId),docId)
//        launchIntent?.putExtra(p0.getString(R.string.docPic),docPic)
        p0.startActivity(launchIntent)
    }
}

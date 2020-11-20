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


class RescheduleAppointment:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val docId = p1?.getStringExtra(Constants.PROP_docId)
        val docSessionId = p1?.getStringExtra(Constants.PROP_docSessionId)
        val healthOrgId = p1?.getStringExtra(Constants.PROP_healthOrgId)
        val bookingId = p1?.getStringExtra(Constants.PROP_BookingId)
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type=Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,value)
        launchIntent?.putExtra(Constants.PROP_docId,docId)
        launchIntent?.putExtra(Constants.PROP_docSessionId,docSessionId)
        launchIntent?.putExtra(Constants.PROP_healthOrgId,healthOrgId)
        launchIntent?.putExtra(Constants.PROP_BookingId,bookingId)
        p0.startActivity(launchIntent)
    }
}

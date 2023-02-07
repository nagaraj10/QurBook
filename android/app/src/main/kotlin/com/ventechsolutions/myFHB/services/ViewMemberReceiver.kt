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


class ViewMemberReceiver:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val redirectTo = p1?.getStringExtra(Constants.PROP_REDIRECT_TO)
        val careGiverRequestor = p1?.getStringExtra(Constants.PROP_CAREGIVER_REQUESTOR)
        val type = p1?.getStringExtra("type")
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type=Constants.TXT_PLAIN
        launchIntent?.putExtra(Constants.PROP_REDIRECT_TO,redirectTo)
        launchIntent?.putExtra(Constants.PROP_CAREGIVER_REQUESTOR,careGiverRequestor)
        launchIntent?.putExtra("type",type)
        launchIntent?.putExtra(Intent.EXTRA_TEXT,value)
        p0.startActivity(launchIntent)
    }
}

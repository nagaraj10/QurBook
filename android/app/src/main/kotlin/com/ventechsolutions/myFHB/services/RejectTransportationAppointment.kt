package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class RejectTransportationAppointment:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val redirectTo = p1?.getStringExtra(Constants.PROP_REDIRECT_TO)
        val patientId = p1?.getStringExtra(Constants.PATIENT_ID)
        val appointmentId = p1?.getStringExtra(Constants.APPOINTMENTID)
        val status = p1?.getStringExtra(Constants.STATUS)
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
//        p0.sendBroadcast(Intent(p0.getString(R.string.intaction_accept_call))
//                .putExtra(p0.getString(R.string.meetid),meeting_id)
//                .putExtra(p0.getString(R.string.username),username)
//        )
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type= Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,value)
        launchIntent?.putExtra(Constants.PROP_REDIRECT_TO,redirectTo)
        launchIntent?.putExtra(Constants.PATIENT_ID,patientId)
        launchIntent?.putExtra(Constants.APPOINTMENTID,appointmentId)
        launchIntent?.putExtra(Constants.STATUS,status)
        p0.startActivity(launchIntent)
    }
}
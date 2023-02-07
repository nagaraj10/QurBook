package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class AppointmentPaymentNotification:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val redirectTo = p1?.getStringExtra(Constants.PROP_REDIRECT_TO)
        val type = p1?.getStringExtra("type")
        val appointmentDate = p1?.getStringExtra(Constants.APPOINTMENT_DATE)
        val meetingID = p1?.getStringExtra(Constants.MEETINGID)
        val bookingId = p1?.getStringExtra(Constants.BOOKINGID)
        val appointmentId = p1?.getStringExtra(Constants.APPOINTMENTID)
       
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
        p0.sendBroadcast(Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS));


//        p0.sendBroadcast(Intent(p0.getString(R.string.ns_pay))
//                .putExtra(p0.getString(R.string.meetid),meeting_id)
//                .putExtra(p0.getString(R.string.username),username)
//        )
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type= Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,value)
        launchIntent?.putExtra(Constants.PROP_REDIRECT_TO,redirectTo)
        launchIntent?.putExtra(Constants.APPOINTMENT_DATE,appointmentDate)
        launchIntent?.putExtra(Constants.MEETINGID,meetingID)
        launchIntent?.putExtra(Constants.BOOKINGID,bookingId)
        launchIntent?.putExtra(Constants.APPOINTMENTID,appointmentId)
        launchIntent?.putExtra("type", type)
        p0.startActivity(launchIntent)
    }
}

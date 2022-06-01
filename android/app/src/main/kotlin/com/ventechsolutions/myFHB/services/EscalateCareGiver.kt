package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class EscalateCareGiver:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val redirectTo = p1?.getStringExtra(Constants.PROP_REDIRECT_TO)
        val type = p1?.getStringExtra("type")
        val careCoordinatorUserId = p1?.getStringExtra(Constants.CARE_COORDINATOR_USER_ID)
        val patientName = p1?.getStringExtra(Constants.PATIENT_NAME)
        val careGiverName = p1?.getStringExtra(Constants.CARE_GIVER_NAME)
        val activityTime = p1?.getStringExtra(Constants.ACTIVITY_TIME)
        val activityName = p1?.getStringExtra(Constants.ACTIVITY_NAME)
        val userId = p1?.getStringExtra(Constants.PROB_USER_ID)

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
        launchIntent?.putExtra(Constants.CARE_COORDINATOR_USER_ID,careCoordinatorUserId)
        launchIntent?.putExtra(Constants.PATIENT_NAME,patientName)
        launchIntent?.putExtra(Constants.CARE_GIVER_NAME,careGiverName)
        launchIntent?.putExtra(Constants.ACTIVITY_TIME,activityTime)
        launchIntent?.putExtra(Constants.ACTIVITY_NAME,activityName)
        launchIntent?.putExtra(Constants.PROB_USER_ID,userId)
        launchIntent?.putExtra("type", type)
        p0.startActivity(launchIntent)
    }
}

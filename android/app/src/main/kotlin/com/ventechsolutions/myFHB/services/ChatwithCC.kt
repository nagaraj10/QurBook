package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class ChatwithCC:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val value = p1?.getStringExtra(Intent.EXTRA_TEXT)
        val redirectTo = p1?.getStringExtra(Constants.PROP_REDIRECT_TO)
        val type = p1?.getStringExtra("type")
        val careCoordinatorUserId = p1?.getStringExtra(Constants.CARE_COORDINATOR_USER_ID)
        val userId = p1?.getStringExtra(Constants.PROB_USER_ID)
        val patientName = p1?.getStringExtra(Constants.PATIENT_NAME)
        val isCareGiver = p1?.getStringExtra(Constants.IS_CARE_GIVER)
        val deliveredDateTime = p1?.getStringExtra(Constants.DELIVERED_DATE_TIME)
        val isFromCareCoordinator = p1?.getStringExtra(Constants.IS_FROM_CARE_COORDINATOR)
        val senderProfilePic = p1?.getStringExtra(Constants.SENDER_PROFILE_PIC)

        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type= Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,value)
        launchIntent?.putExtra(Constants.PROP_REDIRECT_TO,redirectTo)
        launchIntent?.putExtra(Constants.CARE_COORDINATOR_USER_ID,careCoordinatorUserId)
        launchIntent?.putExtra(Constants.PATIENT_NAME,patientName)
        launchIntent?.putExtra(Constants.IS_CARE_GIVER,isCareGiver)
        launchIntent?.putExtra(Constants.PROB_USER_ID,userId)
        launchIntent?.putExtra(Constants.DELIVERED_DATE_TIME,deliveredDateTime)
        launchIntent?.putExtra(Constants.IS_FROM_CARE_COORDINATOR,isFromCareCoordinator)
        launchIntent?.putExtra(Constants.SENDER_PROFILE_PIC,senderProfilePic)
        launchIntent?.putExtra("type", type)
        p0.startActivity(launchIntent)
    }
}

package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class SheelaFollowReceiver:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        val type = p1?.getStringExtra("type")
        val eid = p1?.getStringExtra("eid")
        val task = p1?.getStringExtra("task")
        val action = p1?.getStringExtra("action")
        val activityName = p1?.getStringExtra("activityName")
        val isSheela = p1?.getStringExtra("isSheela")

        nsManager.cancel(notificationId!! as Int)


        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type=Constants.TXT_PLAIN
        launchIntent?.putExtra(Constants.PROP_REDIRECT_TO,"redirect")
        launchIntent?.putExtra("eid",eid)
        launchIntent?.putExtra("type",type)
        launchIntent?.putExtra("task",task)
        launchIntent?.putExtra("action",action)
        launchIntent?.putExtra("activityName",activityName)
        launchIntent?.putExtra("isSheela",isSheela)
        p0.startActivity(launchIntent)
    }
}

package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class OnTapNotificationBackground:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        if(p0!=null){
            val pm: PackageManager = p0.packageManager
            val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
            launchIntent?.action = Intent.ACTION_SEND
            launchIntent?.type=Constants.TXT_PLAIN
            p0.startActivity(launchIntent)
        }

    }
}

package com.globalmantrainnovations.myfhb.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationManagerCompat
import com.globalmantrainnovations.myfhb.R

class DeclineReciver:BroadcastReceiver(){

    override fun onReceive(p0: Context?, p1: Intent?) {
        var notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)

        var nsManager:NotificationManagerCompat = NotificationManagerCompat.from(p0!!)

        nsManager.cancel(notificationId!!)

    }
}
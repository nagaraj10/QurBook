package com.globalmantrainnovations.myfhb.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.globalmantrainnovations.myfhb.R


class AcceptReceiver:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val meeting_id = p1?.getStringExtra(p0?.getString(R.string.meetid))
        val username = p1?.getStringExtra(p0?.getString(R.string.username))
        val docId = p1?.getStringExtra(p0?.getString(R.string.docId))
        val docPic = p1?.getStringExtra(p0?.getString(R.string.docPic))
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)

        nsManager.cancel(notificationId!! as Int)
        p0.sendBroadcast(Intent(p0.getString(R.string.intaction_accept_call))
                .putExtra(p0.getString(R.string.meetid),meeting_id)
                .putExtra(p0.getString(R.string.username),username)
        )

        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type="text/plain"
        launchIntent?.putExtra(Intent.EXTRA_TEXT,meeting_id)
        launchIntent?.putExtra(p0.getString(R.string.username),username)
        launchIntent?.putExtra(p0.getString(R.string.docId),docId)
        launchIntent?.putExtra(p0.getString(R.string.docPic),docPic)
        p0.startActivity(launchIntent)
    }
}

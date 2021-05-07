package com.ventechsolutions.myFHB.services
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.R

class DismissReceiver:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        nsManager.cancel(notificationId!! as Int)

        /*val reminderService = Intent(p0, RemiderService::class.java)
        p0.stopService(reminderService)*/
        MyApp.snoozeTapCountTime=0


        /*p0.sendBroadcast(Intent(p0.getString(R.string.intaction_accept_call))
                .putExtra(p0.getString(R.string.meetid),meeting_id)
                .putExtra(p0.getString(R.string.username),username)
        )
        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type=Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,meeting_id)
        launchIntent?.putExtra(p0.getString(R.string.username),username)
        launchIntent?.putExtra(p0.getString(R.string.docId),docId)
        launchIntent?.putExtra(p0.getString(R.string.docPic),docPic)
        launchIntent?.putExtra(p0.getString(R.string.pat_id),patId)
        launchIntent?.putExtra(p0.getString(R.string.pat_name),patName)
        launchIntent?.putExtra(p0.getString(R.string.pat_pic),patPic)
        p0.startActivity(launchIntent)*/
    }

}
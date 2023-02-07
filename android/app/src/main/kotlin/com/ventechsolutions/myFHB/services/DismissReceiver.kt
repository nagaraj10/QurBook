package com.ventechsolutions.myFHB.services
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ventechsolutions.myFHB.MyApp
import com.ventechsolutions.myFHB.SharedPrefUtils
import com.ventechsolutions.myFHB.services.ReminderBroadcaster.Companion.NOTIFICATION_ID

class DismissReceiver:BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val notificationId = intent.getIntExtra(NOTIFICATION_ID, 0)
        notificationManager.cancel(notificationId)
        Log.e("DismissReceiver", "onReceive: "+notificationId )

        SharedPrefUtils().deleteNotificationObject(context, notificationId)

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
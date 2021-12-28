package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.NotificationManagerCompat
import com.ventechsolutions.myFHB.R
import com.ventechsolutions.myFHB.constants.Constants


class OnTapNotification:BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {
        val notificationId = p1?.getIntExtra(p0?.getString(R.string.nsid), 0)
        val meeting_id = p1?.getStringExtra(p0?.getString(R.string.meetid))
        val username = p1?.getStringExtra(p0?.getString(R.string.username))
        val redirct_to = p1?.getStringExtra(Constants.PROP_REDIRECT_TO)
        val plan_id = p1?.getStringExtra(Constants.PROP_PLANID)
        val externalLink = p1?.getStringExtra(Constants.PROB_EXTERNAL_LINK)
        val data = p1?.getStringExtra(Constants.PROP_DATA)
        val templateName = p1?.getStringExtra(Constants.PROP_TEMP_NAME)
        val HRMId = p1?.getStringExtra(Constants.PROP_HRMID)
        val EVEId = p1?.getStringExtra(Constants.PROP_EVEID)
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(p0!!)
        val docId = p1?.getStringExtra(p0?.getString(R.string.docId))
        val docPic = p1?.getStringExtra(p0?.getString(R.string.docPic))
        val docName = p1?.getStringExtra(p0?.getString(R.string.docName))
        val pat_id = p1?.getStringExtra(p0?.getString(R.string.pat_id))
        val pat_pic = p1?.getStringExtra(p0?.getString(R.string.pat_pic))
        val pat_name = p1?.getStringExtra(p0?.getString(R.string.pat_name))
        val message = p1?.getStringExtra(p0?.getString(R.string.message))
        val raw_title = p1?.getStringExtra(Constants.PROP_RAWTITLE)
        val raw_body = p1?.getStringExtra(Constants.PROP_RAWBODY)
        val user_id = p1?.getStringExtra(Constants.PROB_USER_ID)
        val appLog = p1?.getStringExtra(p0?.getString(R.string.ns_type_applog))

        nsManager.cancel(notificationId!! as Int)
        p0.sendBroadcast(Intent(p0.getString(R.string.intaction_accept_call))
                .putExtra(p0.getString(R.string.meetid),meeting_id)
                .putExtra(p0.getString(R.string.username),username)
        )

        val pm: PackageManager = p0.packageManager
        val launchIntent = pm.getLaunchIntentForPackage(p0.packageName)
        launchIntent?.action = Intent.ACTION_SEND
        launchIntent?.type=Constants.TXT_PLAIN
        launchIntent?.putExtra(Intent.EXTRA_TEXT,meeting_id)
        launchIntent?.putExtra(p0.getString(R.string.username),username)
        launchIntent?.putExtra(Constants.PROP_REDIRECT_TO,redirct_to)
        launchIntent?.putExtra(Constants.PROP_HRMID,HRMId)
        launchIntent?.putExtra(Constants.PROP_PLANID,plan_id)
        launchIntent?.putExtra(Constants.PROP_DATA,data)
        launchIntent?.putExtra(Constants.PROP_EVEID,EVEId)
        launchIntent?.putExtra(p0.getString(R.string.docId), docId)
        launchIntent?.putExtra(p0.getString(R.string.docPic), docPic)
        launchIntent?.putExtra(p0.getString(R.string.docName), docName)
        launchIntent?.putExtra(p0.getString(R.string.pat_id), pat_id)
        launchIntent?.putExtra(p0.getString(R.string.pat_pic), pat_pic)
        launchIntent?.putExtra(p0.getString(R.string.pat_name), pat_name)
        launchIntent?.putExtra(p0.getString(R.string.message), message)
        launchIntent?.putExtra(Constants.PROP_RAWBODY, raw_body)
        launchIntent?.putExtra(Constants.PROP_RAWTITLE, raw_title)
        launchIntent?.putExtra(Constants.PROP_TEMP_NAME,templateName)
        launchIntent?.putExtra(Constants.PROB_EXTERNAL_LINK,externalLink)
        launchIntent?.putExtra(Constants.PROB_USER_ID,user_id)
        launchIntent?.putExtra(p0.getString(R.string.ns_type_applog),appLog)
        p0.startActivity(launchIntent)
    }
}

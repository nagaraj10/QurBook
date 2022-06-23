package com.ventechsolutions.myFHB.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ventechsolutions.myFHB.SharedPrefUtils


class ScheduleAppointment : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
//        android.os.Debug.waitForDebugger()

        val notificationId = intent.getIntExtra(NOTIFICATION_ID, 0)
        Log.e("AppointmentBroadcast", "onReceive: ")

        SharedPrefUtils().deleteNotificationObject(context, notificationId)

        context.sendBroadcast(Intent("INTERNET_LOST"));

    }

    companion object {
        var NOTIFICATION_ID = "notification_id"
    }
}
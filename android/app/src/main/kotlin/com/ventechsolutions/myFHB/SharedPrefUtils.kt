package com.ventechsolutions.myFHB

import android.content.Context
import com.appsflyer.AppsFlyerLibCore.getSharedPreferences
import org.json.JSONArray
import org.json.JSONObject

class SharedPrefUtils {
    private val sTagAlarms = ":alarms"

     fun getNotificationId(context : Context,nsid: String): Int {
        val idsAlarms: JSONArray = getAlarmIds(context)
        var notificationId=0;
        for (i in 0 until idsAlarms.length()) {
            if(idsAlarms.optJSONObject(i).optString("nsid")==nsid){
                notificationId=idsAlarms.optJSONObject(i).optInt("alarmAndNotificationId")
            }
        }
        return notificationId
    }

     fun saveAlarmId(context : Context,nsid: String, alarmAndNotificationId : Int) :Boolean {
        val idsAlarms: JSONArray = getAlarmIds(context)
        val ids = listOf<String>()
        var presentInPref=false;

        for (i in 0 until idsAlarms.length()) {
            if(idsAlarms.optJSONObject(i).optString("nsid")==nsid){
                presentInPref=true;
            }
        }
        if (!presentInPref) {
            val jsonObject= JSONObject()
            jsonObject.put("nsid",nsid)
            jsonObject.put("alarmAndNotificationId",alarmAndNotificationId)
            idsAlarms.put(jsonObject);
            saveIdsInPreferences(context,idsAlarms)
        }
        return presentInPref
    }

     fun getAlarmIds(context : Context): JSONArray {
        var jsonArray= JSONArray()
        try {
            val prefs = context.getSharedPreferences(context.packageName + "_preferences", Context.MODE_PRIVATE)
            jsonArray = JSONArray(prefs.getString(context.packageName + sTagAlarms, "[]"))
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
        return jsonArray
    }

     fun saveIdsInPreferences(context : Context,lstIds: JSONArray) {
        val prefs = context.getSharedPreferences(context.packageName + "_preferences", Context.MODE_PRIVATE)
        val editor = prefs.edit()
        editor.putString(context.packageName + sTagAlarms, lstIds.toString())
        editor.apply()
    }

     fun deleteNotificationObject(context : Context,alarmAndNotificationId: Int){
        val idsAlarms: JSONArray = getAlarmIds(context)
        var notificationId : Int? = null
        for (i in 0 until idsAlarms.length()) {
            if(idsAlarms.optJSONObject(i).optInt("alarmAndNotificationId")==alarmAndNotificationId){
                notificationId=i
            }
        }
         if (notificationId != null) {
             idsAlarms.remove(notificationId)
         }
        saveIdsInPreferences(context,idsAlarms)
    }
}
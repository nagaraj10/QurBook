package com.ventechsolutions.myFHB

import android.app.Activity
import android.app.Application
import android.os.Bundle
import androidx.annotation.CallSuper
import com.google.firebase.firestore.FirebaseFirestore
import io.flutter.view.FlutterMain
import jp.co.ohq.ble.OHQDeviceManager
import java.lang.ref.WeakReference

public class MyApp : Application(), Application.ActivityLifecycleCallbacks {
    @CallSuper
    override fun onCreate() {
        super.onCreate()
        OHQDeviceManager.init(applicationContext)
        registerActivityLifecycleCallbacks(this)
        FlutterMain.startInitialization(this)

    }

    var currentActivity: Activity? = null

    companion object {
        var foregroundActivityRef: WeakReference<Activity>? = null
        var isMissedNSShown = true
        var recordId = ""
        const val TAG: String = "MyApp"
        var snoozeTapCountTime: Int = 0
    }

    fun updateStatus(isAccept: Boolean) {
        var data: HashMap<String, Any>
        if (isAccept) {
            data = hashMapOf(
                    "call_status" to "accept"
            )
        } else {
            data = hashMapOf(
                    "call_status" to "decline"
            )
        }

        try {
            var db = FirebaseFirestore.getInstance()
            db.collection("call_log")
                    .document(recordId)
                    .update(data)
        } catch (e: Exception) {
            print(e.message)
        }
    }

    override fun onActivityCreated(p0: Activity, p1: Bundle?) {
    }

    override fun onActivityStarted(activity: Activity) {
        foregroundActivityRef = WeakReference(activity)
    }

    override fun onActivityResumed(activity: Activity) {
        foregroundActivityRef = WeakReference(activity)
    }

    override fun onActivityPaused(activity: Activity) {
        if (foregroundActivityRef != null && foregroundActivityRef?.get() == activity) {
            foregroundActivityRef = null;
        }
    }

    override fun onActivityStopped(activity: Activity) {
        if (foregroundActivityRef != null && foregroundActivityRef?.get() == activity) {
            foregroundActivityRef = null;
        }
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {

    }

    override fun onActivityDestroyed(p0: Activity) {

    }


}


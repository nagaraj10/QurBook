package com.ventechsolutions.myFHB

import android.app.Activity
import android.app.Application
import android.util.Log
import androidx.annotation.CallSuper
import com.google.firebase.firestore.FirebaseFirestore
import io.flutter.view.FlutterMain

class MyApp : Application() {
    @CallSuper
    override fun onCreate() {
        super.onCreate()
        FlutterMain.startInitialization(this)
    }

    var currentActivity: Activity? = null

    companion object {
        var isMissedNSShown = true
        var recordId = ""
        const val TAG: String = "MyApp"
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


}
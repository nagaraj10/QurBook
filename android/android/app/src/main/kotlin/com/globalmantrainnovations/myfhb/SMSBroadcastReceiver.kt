package com.globalmantrainnovations.myfhb

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import java.util.regex.Pattern

class SMSBroadcastReceiver : BroadcastReceiver() {

    private var otpReceiver: OTPListener? = null

    fun injectOTPListener(receiver: OTPListener?) {
        this.otpReceiver = receiver
    }

    override fun onReceive(context: Context, intent: Intent) {
        //Log.v("RECORD_PERMISSION","we cant record without your permission.")
        if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
            val extras = intent.extras
            if (extras != null) {
                val status = extras.get(SmsRetriever.EXTRA_STATUS) as Status

                when (status.statusCode) {
                    CommonStatusCodes.SUCCESS -> {
                        // Get SMS message contents
                        val message = extras.get(SmsRetriever.EXTRA_SMS_MESSAGE) as String
//                        Extract the 6 digit integer from SMS
                        val pattern = Pattern.compile("\\d{4}")
                        val matcher = pattern.matcher(message)
                        if (matcher.find()) {
                            otpReceiver?.onOTPReceived(matcher.group(0))
                            return
                        }

                    }
                    CommonStatusCodes.TIMEOUT -> {
                        otpReceiver?.onOTPTimeOut()
                    }
                }// Waiting for SMS timed out (5 minutes)
                // Handle the error ...

            }

        }

    }

    interface OTPListener {
        fun onOTPReceived(otp: String)
        fun onOTPTimeOut()
    }

}
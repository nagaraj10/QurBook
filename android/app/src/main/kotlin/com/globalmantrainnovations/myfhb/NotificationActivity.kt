package com.globalmantrainnovations.myfhb

import android.Manifest
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.WindowManager.LayoutParams.*
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.sdk.meetings.utils.logger.LogLevel
import kotlinx.coroutines.*
import java.io.*
import java.net.HttpURLConnection
import java.net.URL

class NotificationActivity : AppCompatActivity() {
    private val TAG = "NotificationActivity"
    private var meetingID: String? = null
    private var yourName: String? = null
    private val WEBRTC_PERM = arrayOf(
            Manifest.permission.MODIFY_AUDIO_SETTINGS,
            Manifest.permission.RECORD_AUDIO
    )
    private val WEBRTC_PERMISSION_REQUEST_CODE = 1
    private val MEETING_REGION = "us-east-1"
    private val logger = ConsoleLogger(LogLevel.INFO)
    private val uiScope = CoroutineScope(Dispatchers.Main)
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification)
        setupActivity()
        val tv = findViewById<TextView>(R.id.recipient_name_tv)
        FROM_VAL=intent.getStringExtra(FROM)
        tv.text = "${intent.getStringExtra(FROM)}"
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val nsID:Int=intent.getIntExtra(NS_ID,0)
        nsManager.cancel(nsID)

    }


    private fun setupActivity() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        } else {
            window.addFlags(FLAG_SHOW_WHEN_LOCKED or FLAG_TURN_SCREEN_ON or FLAG_KEEP_SCREEN_ON)
        }
    }

    fun decline(v: View?) {
        //todo close this activity
        finish()
    }

    fun accept(v: View?) {
        //todo start amazon chime
        val meetid = intent.getStringExtra(MID)
        val mname = intent.getStringExtra(UNAME)
        startChime(meetid,mname)
    }

    companion object {
        const val UNAME = "username"
        const val FROM = "body"
        const val MID = "meeting_id"
        const val NS_ID = "notificationId"
        var FROM_VAL = ""
    }

    fun startChime(mid:String,name:String) {
        joinMeeting(mid,name)
    }

    private fun joinMeeting(mid:String,name:String) {
        meetingID = mid
        yourName = name

        if (meetingID.isNullOrBlank()) {
            Toast.makeText(
                    this,
                    getString(R.string.user_notification_meeting_id_invalid),
                    Toast.LENGTH_LONG
            ).show()
        } else if (yourName.isNullOrBlank()) {
            Toast.makeText(
                    this,
                    getString(R.string.user_notification_attendee_name_invalid),
                    Toast.LENGTH_LONG
            ).show()
        } else {
            if (hasPermissionsAlready()) {
                Log.d(TAG, "joinMeeting: permission has done")
                authenticate(getString(R.string.test_url), meetingID, yourName)
            } else {
                Log.d(TAG, "joinMeeting: permission not yet given")
                ActivityCompat.requestPermissions(this, WEBRTC_PERM, WEBRTC_PERMISSION_REQUEST_CODE)
            }
        }
    }



    private fun hasPermissionsAlready(): Boolean {
        Log.d(TAG, "hasPermissionsAlready: inside the block")
        return WEBRTC_PERM.all {
            ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissionsList: Array<String>,
            grantResults: IntArray
    ) {
        when (requestCode) {
            WEBRTC_PERMISSION_REQUEST_CODE -> {
                val isMissingPermission: Boolean =
                        grantResults.isEmpty() || grantResults.any { PackageManager.PERMISSION_GRANTED != it }

                if (isMissingPermission) {
                    Toast.makeText(
                            this,
                            getString(R.string.user_notification_permission_error),
                            Toast.LENGTH_LONG
                    )
                            .show()
                    return
                }
                authenticate(getString(R.string.test_url), meetingID, yourName)
            }
        }
    }

    private fun authenticate(
            meetingUrl: String,
            meetingId: String?,

            attendeeName: String?
    ) =
            uiScope.launch {
                //authenticationProgressBar?.visibility = View.VISIBLE
                logger.info(TAG, "Joining meeting. meetingUrl: $meetingUrl, meetingId: $meetingId, attendeeName: $attendeeName")

                Log.d(TAG, "authenticate: waiting for the meetingResponseJson")
                val meetingResponseJson: String? = joinMeeting(meetingUrl, meetingId, attendeeName)

                //authenticationProgressBar?.visibility = View.INVISIBLE

                if (meetingResponseJson == null) {
                    Toast.makeText(
                            applicationContext,
                            getString(R.string.user_notification_meeting_start_error),
                            Toast.LENGTH_LONG
                    ).show()
                } else {
                    val intent = Intent(applicationContext, CallOnUI::class.java)
                    intent.putExtra(MainActivity.MEETING_RESPONSE_KEY, meetingResponseJson)
                    intent.putExtra(MainActivity.MEETING_ID_KEY, meetingId)
                    intent.putExtra(MainActivity.NAME_KEY, attendeeName)
                    intent.putExtra(MainActivity.FROM_KEY, FROM_VAL)
                    startActivity(intent)
                    finish()
                }
            }

    private suspend fun joinMeeting(
            meetingUrl: String,
            meetingId: String?,
            attendeeName: String?
    ): String? {
        return getMeetingResponse(meetingUrl,meetingId,attendeeName)
    }

    suspend fun getMeetingResponse(
            meetingUrl: String,
            meetingId: String?,
            attendeeName: String?
    ):String?{
        return withContext(ioDispatcher) {
            val serverUrl =
                    URL(
                            "${meetingUrl}join?title=${encodeURLParam(
                                    meetingId
                            )}&name=${encodeURLParam(
                                    attendeeName
                            )}&region=${encodeURLParam(
                                    MEETING_REGION
                            )}"
                    )

            try {

                val response = StringBuffer()
                val conn:HttpURLConnection = serverUrl.openConnection() as HttpURLConnection
                conn.connectTimeout = 15000
                conn.readTimeout = 15000
                with(conn) {
                    requestMethod = "POST"
                    doInput = true
                    doOutput = true
                    BufferedReader(InputStreamReader(inputStream)).use {
                        var inputLine = it.readLine()
                        while (inputLine != null) {
                            response.append(inputLine)
                            inputLine = it.readLine()
                        }
                        it.close()
                    }

                    if (responseCode == 201) {
                        response.toString()
                    } else {
                        logger.error(TAG, "Unable to join meeting. Response code: $responseCode")
                        null
                    }
                }
            } catch (exception: Exception) {
                logger.error(TAG, "There was an exception while joining the meeting: $exception")
                null
            }
        }
    }

}
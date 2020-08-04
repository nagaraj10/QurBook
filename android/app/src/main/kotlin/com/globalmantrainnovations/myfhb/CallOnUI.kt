package com.globalmantrainnovations.myfhb

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.FrameLayout
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoFacade
import com.amazonaws.services.chime.sdk.meetings.session.CreateAttendeeResponse
import com.amazonaws.services.chime.sdk.meetings.session.CreateMeetingResponse
import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionConfiguration
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.sdk.meetings.utils.logger.LogLevel
import com.globalmantrainnovations.myfhb.data.JoinMeetingResponse
import com.globalmantrainnovations.myfhb.services.AVServices
import com.google.gson.Gson
import java.util.*

class CallOnUI : AppCompatActivity(),
        //DeviceManagementFragment.DeviceManagementEventListener,
        VideoFragment.VideoViewEventListener {
    private var mainContent: FrameLayout? = null
    private val logger = ConsoleLogger(LogLevel.DEBUG)
    private val gson = Gson()
    private lateinit var meetingId: String
    private lateinit var name: String
    private lateinit var from: String
    private lateinit var audioVideo: AudioVideoFacade
    private lateinit var videoViewFragment: VideoFragment
    private  var isExistingCall: Boolean = false
    private  var isLeaveMeetingPressed: Boolean = false

    private val TAG = "CallOnUI"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_callonui)
        initialiseView()

        meetingId = intent.getStringExtra(MEETING_ID_KEY) as String
        name = intent.getStringExtra(NAME_KEY) as String
        from = intent.getStringExtra(FROM_KEY) as String
        val meetingResponseJson = intent.getStringExtra(MEETING_RESPONSE_KEY) as String
        val sessionConfig = createSessionConfiguration(meetingResponseJson)
        val meetingSession = sessionConfig?.let {
            logger.info(TAG, "Creating meeting session for meeting Id: $meetingId")
            DefaultMeetingSession(
                    it,
                    logger,
                    applicationContext
            )
        }

        if (meetingSession == null) {
            Toast.makeText(
                    applicationContext,
                    getString(R.string.user_notification_meeting_start_error),
                    Toast.LENGTH_LONG
            ).show()
            finish()
        } else {
            audioVideo = meetingSession.audioVideo
        }

        if (savedInstanceState == null) {
            //todo mo-code
            videoViewFragment =
                    VideoFragment.newInstance(meetingId,isExistingCall,name,from)
            supportFragmentManager
                    .beginTransaction()
                    .replace(R.id.main_content, videoViewFragment, getString(R.string.frag_video))
                    .addToBackStack(getString(R.string.frag_video))
                    .commit()
        }


        /*if (MyApp().audioVideoFacade!=null){
            isExistingCall=true
            audioVideo=MyApp().audioVideoFacade
            meetingId="will_remove"
            name="dummy"
            if (savedInstanceState == null) {
//                val deviceManagementFragment =
//                        DeviceManagementFragment.newInstance(
//                                meetingId,
//                                name
//                        )
//                supportFragmentManager
//                        .beginTransaction()
//                        .add(R.id.main_content, deviceManagementFragment, getString(R.string.frag_device))
//                        .commit()
                videoViewFragment =
                        VideoFragment.newInstance(meetingId,isExistingCall,name)
                supportFragmentManager
                        .beginTransaction()
                        .replace(R.id.main_content, videoViewFragment, getString(R.string.frag_video))
                        .commit()
            }
        }else{
            isExistingCall=false
            meetingId = intent.getStringExtra(MEETING_ID_KEY) as String
            name = intent.getStringExtra(NAME_KEY) as String
            val meetingResponseJson = intent.getStringExtra(MEETING_RESPONSE_KEY) as String
            val sessionConfig = createSessionConfiguration(meetingResponseJson)
            val meetingSession = sessionConfig?.let {
                logger.info(TAG, "Creating meeting session for meeting Id: $meetingId")
                DefaultMeetingSession(
                        it,
                        logger,
                        applicationContext
                )
            }

            if (meetingSession == null) {
                Toast.makeText(
                        applicationContext,
                        getString(R.string.user_notification_meeting_start_error),
                        Toast.LENGTH_LONG
                ).show()
                finish()
            } else {
                audioVideo = meetingSession.audioVideo
            }

            if (savedInstanceState == null) {
//                val deviceManagementFragment =
//                        DeviceManagementFragment.newInstance(
//                                meetingId,
//                                name
//                        )
//                supportFragmentManager
//                        .beginTransaction()
//                        .add(R.id.main_content, deviceManagementFragment, getString(R.string.frag_device))
//                        .commit()
                //todo mo-code
                videoViewFragment =
                        VideoFragment.newInstance(meetingId,isExistingCall,name)
                supportFragmentManager
                        .beginTransaction()
                        .replace(R.id.main_content, videoViewFragment, getString(R.string.frag_video))
                        .commit()
            }
        }*/



    }

    override fun onResume() {
        super.onResume()
        //iCallTimer.getCallTimer(callTimer);
    }

    private fun initialiseView() {
        mainContent = findViewById(R.id.main_content)
    }

    override fun onPause() {
        super.onPause()
    }

    companion object {
        @JvmField
        var timerOffset: Long = 0
        const val MEETING_RESPONSE_KEY = "MEETING_RESPONSE"
        const val MEETING_ID_KEY = "MEETING_ID"
        const val NAME_KEY = "NAME"
        const val FROM_KEY = "FROM"
    }


    override fun onLeaveMeeting() {
//        audioVideo.stopLocalVideo()
//        audioVideo.stopRemoteVideo()
        isLeaveMeetingPressed=true
        showAlertDialogButtonClicked()
    }

    fun showAlertDialogButtonClicked() {

        // setup the alert builder
        val builder = AlertDialog.Builder(Objects.requireNonNull(this)!!)
        builder.setTitle(getString(R.string.alert))
        builder.setMessage(getString(R.string.msg_exitfromcall))
        builder.setCancelable(false)

        // add the buttons
        builder.setPositiveButton(getString(R.string.yes)) { dialogInterface, i -> //todo render audio screen.
            onBackPressedByUser()

        }
        builder.setNegativeButton(getString(R.string.no)) { dialogInterface, i -> dialogInterface.dismiss() }

        // create and show the alert dialog
        val dialog = builder.create()
        dialog.show()
    }

    private fun onBackPressedByUser() {
        if(this::videoViewFragment.isInitialized){
            audioVideo.stop() //
            audioVideo.removeActiveSpeakerObserver(videoViewFragment)
        }
        val serviceIntent = Intent(this, AVServices::class.java)
        stopService(serviceIntent)
        onBackPressed()
    }

    override fun onBackPressed() {
        val count = supportFragmentManager.backStackEntryCount
        if(count==0){
            Log.d(TAG, "activity onBackPressed invoked")
            super.onBackPressed()
        }else{
            Log.d(TAG, "fragment onBackPressed invoked")
            supportFragmentManager.popBackStack()
            if(!isLeaveMeetingPressed){
                showAlertDialogButtonClicked()  //todo this need to be changed with proper
            }else{
                isLeaveMeetingPressed=false
                super.onBackPressed()
            }

        }
    }

    fun getAudioVideo(): AudioVideoFacade = audioVideo

    private fun createSessionConfiguration(response: String?): MeetingSessionConfiguration? {
        if (response.isNullOrBlank()) return null

        return try {
            val joinMeetingResponse = gson.fromJson(response, JoinMeetingResponse::class.java)
            MeetingSessionConfiguration(
                    CreateMeetingResponse(joinMeetingResponse.joinInfo.meetingResponse.meeting),
                    CreateAttendeeResponse(joinMeetingResponse.joinInfo.attendeeResponse.attendee)
            )
        } catch (exception: Exception) {
            logger.error(
                    TAG,
                    "Error creating session configuration: ${exception.localizedMessage}"
            )
            null
        }
    }
}
package com.globalmantrainnovations.myfhb

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.*
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.cardview.widget.CardView
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.amazonaws.services.chime.sdk.meetings.audiovideo.*
import com.amazonaws.services.chime.sdk.meetings.audiovideo.audio.activespeakerdetector.ActiveSpeakerObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.audio.activespeakerpolicy.DefaultActiveSpeakerPolicy
import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.MetricsObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.ObservableMetric
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.DefaultVideoRenderView
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoPauseState
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileState
import com.amazonaws.services.chime.sdk.meetings.device.DeviceChangeObserver
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import com.amazonaws.services.chime.sdk.meetings.device.MediaDeviceType
import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatus
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatusCode
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.sdk.meetings.utils.logger.LogLevel
import com.globalmantrainnovations.myfhb.data.RosterAttendee
import com.globalmantrainnovations.myfhb.data.VideoCollectionTile
import com.globalmantrainnovations.myfhb.services.AVServices
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import java.util.*

class VideoFragment : Fragment, View.OnClickListener,
        RealtimeObserver, AudioVideoObserver, VideoTileObserver,
        MetricsObserver, ActiveSpeakerObserver, DeviceChangeObserver {
    private var nameContainer: LinearLayout? = null
    private var controlContainer: CardView? = null
    private var callEnd: LinearLayout? = null
    private var muteContainer: LinearLayout? = null
    private var callTimer: Chronometer? = null
    private var _video: ImageView? = null
    private var _mic: ImageView? = null
    private var _chat: ImageView? = null
    private var _remoteAudio: ImageView? = null
    private var _switchCamera: ImageView? = null
    private var _attachment: ImageView? = null
    private var _callername: TextView? = null
    private var recipient_view: DefaultVideoRenderView? = null
    private var dialer_view: DefaultVideoRenderView? = null
    private var isAttendeeJoin:Boolean=false
    private var isRemoteAttendeeId:String?=null
    private var isAttendeeMute:Boolean=false
    private val audioDevices = mutableListOf<MediaDevice>()
    private val logger = ConsoleLogger(LogLevel.DEBUG)
    private val mutex = Mutex()
    private val uiScope = CoroutineScope(Dispatchers.Main)
    private val currentRoster = mutableMapOf<String, RosterAttendee>()
    private val currentVideoTiles = mutableMapOf<Int, VideoCollectionTile>()
    private val currentScreenTiles = mutableMapOf<Int, VideoCollectionTile>()
    private val nextVideoTiles = LinkedHashMap<Int, VideoCollectionTile>()
    private var isMuted = false
    private var isCameraOn = true
    //private lateinit var meetingId: String
    private lateinit var audioVideo: AudioVideoFacade
    private lateinit var listener: VideoViewEventListener
    private  var isExistingCall: Boolean = false
    override val scoreCallbackIntervalMs: Int? get() = 1000

    private val MAX_TILE_COUNT = 2
    private val LOCAL_TILE_ID = 0
    private val WEBRTC_PERMISSION_REQUEST_CODE = 1
    private val TAG = "videoViewFragment"

    // Check if attendee Id contains this at the end to identify content share
    private val CONTENT_DELIMITER = "#content"

    // Append to attendee name if it's for content share
    private val CONTENT_NAME_SUFFIX = "<<Content>>"

    private val WEBRTC_PERM = arrayOf(
            Manifest.permission.CAMERA
    )

    constructor() {
        // Required empty public constructor
    }

    constructor(callTimer: Chronometer?) {
        this.callTimer = callTimer
    }

    private fun initialiseView(v: View) {
        nameContainer = v.findViewById(R.id.name_container)
        muteContainer = v.findViewById(R.id.mute_container)
        controlContainer = v.findViewById(R.id.control_container)
        recipient_view = v.findViewById(R.id.recipient_view)
        dialer_view = v.findViewById(R.id.dialer_view)
        callEnd = v.findViewById(R.id.call_end)
        callTimer = v.findViewById(R.id.call_timer)
        _video = v.findViewById(R.id.video)
        //_switchCamera = v.findViewById(R.id._switch_camera)
        _attachment= v.findViewById(R.id._attachment)
        _mic = v.findViewById(R.id.audio)
        _remoteAudio = v.findViewById(R.id.remote_audio_status)
        _chat = v.findViewById(R.id.chat)
        _callername = v.findViewById(R.id.rname)

        recipient_view?.setOnClickListener(this)
        _video?.setOnClickListener(this)
        _mic?.setOnClickListener(this)
        _chat?.setOnClickListener(this)
        callEnd?.setOnClickListener(this)
        //_switchCamera?.setOnClickListener(this)
        _attachment?.setOnClickListener(this)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        val v = inflater.inflate(R.layout.fragment_video, container, false)
        initialiseView(v)
        val name = arguments?.getString(MainActivity.NAME_KEY)
        _callername?.text=name

        Handler(Looper.myLooper()).postDelayed({
            controlContainer!!.visibility = View.INVISIBLE
            isHideControl = true
        }, 5000)

        val activity = activity as Context
        audioVideo = (activity as CallOnUI).getAudioVideo()
        audioVideo.addDeviceChangeObserver(this)
        uiScope.launch {
            populateDeviceList(listAudioDevices())
        }

        audioVideo.addAudioVideoObserver(this)
        audioVideo.addMetricsObserver(this)
        audioVideo.addRealtimeObserver(this)
        audioVideo.addVideoTileObserver(this)
        audioVideo.start()
        audioVideo.addActiveSpeakerObserver(DefaultActiveSpeakerPolicy(), this)
        startCamera()
        audioVideo.startRemoteVideo()
        //check if call is alive
        /*if(!isExistingCall){
            audioVideo.addDeviceChangeObserver(this)
            audioVideo.addAudioVideoObserver(this)
            audioVideo.addMetricsObserver(this)
            audioVideo.addRealtimeObserver(this)
            audioVideo.addVideoTileObserver(this)
            audioVideo.start()
            //audioVideo.addActiveSpeakerObserver(DefaultActiveSpeakerPolicy(), this)
            startCamera()
            audioVideo.startRemoteVideo()
        }else{
            audioVideo.startLocalVideo()
            audioVideo.startRemoteVideo()
        }*/

        callTimer!!.start()
        startOnGoingNS()
        //MyApp().audioVideoFacade=audioVideo
        return v
    }

    private fun populateDeviceList(freshAudioDeviceList: List<MediaDevice>) {
        audioDevices.clear()
        audioDevices.addAll(
                freshAudioDeviceList.filter {
                    it.type != MediaDeviceType.OTHER
                }.sortedBy { it.order }
        )
        //adapter.notifyDataSetChanged()
        if (audioDevices.isNotEmpty()) {
            //todo this need to be call when device
            audioVideo.chooseAudioDevice(audioDevices[0])
        }
    }

    private suspend fun listAudioDevices(): List<MediaDevice> {
        return withContext(Dispatchers.Default) {
            audioVideo.listAudioDevices()
        }
    }

    override fun onAudioDeviceChanged(freshAudioDeviceList: List<MediaDevice>) {
        populateDeviceList(freshAudioDeviceList)
    }

    private fun startOnGoingNS() {
        val serviceIntent = Intent(activity, AVServices::class.java)
        serviceIntent.putExtra("name", arguments?.getString(MainActivity.NAME_KEY))
        activity?.let { ContextCompat.startForegroundService(it, serviceIntent) }
    }


    override fun onResume() {
        super.onResume()
        callTimer!!.base = SystemClock.elapsedRealtime() - CallOnUI.timerOffset
        callTimer!!.start()
    }

    override fun onStop() {
        super.onStop()
        callTimer!!.stop()
        CallOnUI.timerOffset = SystemClock.elapsedRealtime() - callTimer!!.base
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    fun showAlertDialogButtonClicked() {

        // setup the alert builder
        val builder = AlertDialog.Builder(Objects.requireNonNull(activity)!!)
        builder.setTitle(getString(R.string.alert))
        builder.setMessage(getString(R.string.msg_video2audio))
        builder.setCancelable(false)

        // add the buttons
        builder.setPositiveButton(getString(R.string.yes)) { dialogInterface, i -> //todo render audio screen.
            Objects.requireNonNull(activity)!!.supportFragmentManager.beginTransaction().replace(R.id.main_content, AudioFragment()).commit()
        }
        builder.setNegativeButton(getString(R.string.no)) { dialogInterface, i -> dialogInterface.dismiss() }

        // create and show the alert dialog
        val dialog = builder.create()
        dialog.show()
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    override fun onClick(view: View) {
        when (view.id) {
            R.id.audio -> toggleMuteMeeting()
            R.id.video -> toggleVideo()
            R.id.call_end -> {
//                audioVideo.stopLocalVideo()
//                audioVideo.stopRemoteVideo()
                //MyApp().audioVideoFacade=null
                listener.onLeaveMeeting()
            }
            R.id.recipient_view ->                 //todo hide the name & controller for full screen
                if (isHideControl) {
                    nameContainer!!.visibility = View.VISIBLE
                    controlContainer!!.visibility = View.VISIBLE
                    if (isMuted) {
                        muteContainer!!.visibility = View.INVISIBLE
                    }
                    Handler(Objects.requireNonNull(Looper.myLooper())).postDelayed({
                        if (isMuted) {
                            muteContainer!!.visibility = View.VISIBLE
                        } else {
                            muteContainer!!.visibility = View.INVISIBLE
                        }
                        nameContainer!!.visibility = View.INVISIBLE
                        controlContainer!!.visibility = View.INVISIBLE
                        isHideControl = true
                    }, 5000)
                }
            R.id.chat -> { }
//            R.id._switch_camera ->{
//                //audioVideo.switchCamera()
//            }
            R.id._attachment ->{}
        }
    }

    companion object {
        private var isMute = false
        private var isVideoEnable = true
        private var isHideControl = false
        private var isExistingCall = false

        fun newInstance(meetingId: String,isCallAlive:Boolean=false,name:String): VideoFragment {
            val fragment = VideoFragment()
            isExistingCall=isCallAlive
            fragment.arguments = Bundle().apply {
                putString(MainActivity.MEETING_ID_KEY, meetingId)
                putString(MainActivity.NAME_KEY, name)
            }
            return fragment
        }
    }

    interface VideoViewEventListener {
        fun onLeaveMeeting()
    }


    override fun onAttach(context: Context) {
        super.onAttach(context)

        if (context is VideoViewEventListener) {
            listener = context
        } else {
            logger.error(TAG, "$context must implement VideoViewEventListener.")
            throw ClassCastException("$context must implement VideoViewEventListener.")
        }
    }

    override fun onAttendeesDropped(attendeeInfo: Array<AttendeeInfo>) {
        Log.d(TAG, "onAttendeesDropped: invoked")
    }

    override fun onAttendeesJoined(attendeeInfo: Array<AttendeeInfo>) {
        uiScope.launch {
            mutex.withLock {
                attendeeInfo.forEach { (attendeeId, externalUserId) ->
                    currentRoster.getOrPut(
                            attendeeId,
                            {
                                RosterAttendee(
                                        attendeeId,
                                        getAttendeeName(attendeeId, externalUserId)
                                )
                            })
                }
            }
        }
    }

    private fun getAttendeeName(attendeeId: String, externalUserId: String): String {
        val attendeeName = externalUserId.split('#')[1]

        return if (attendeeId.endsWith(CONTENT_DELIMITER)) {
            "$attendeeName $CONTENT_NAME_SUFFIX"
        } else {
            attendeeName
        }
    }

    private fun toggleMuteMeeting() {
        if (isMuted) unmuteMeeting() else muteMeeting()
        isMuted = !isMuted
    }

    private fun muteMeeting() {
        audioVideo.realtimeLocalMute()
        _mic?.setImageResource(R.drawable.ic_mic_off)
    }

    private fun unmuteMeeting() {
        audioVideo.realtimeLocalUnmute()
        _mic?.setImageResource(R.drawable.ic_mic_on)
    }

    private fun toggleVideo() {
        if (isCameraOn) stopCamera() else startCamera()
        isCameraOn = !isCameraOn
    }

    private fun startCamera() {
        if (hasPermissionsAlready()) {
            startLocalVideo()
        } else {
            requestPermissions(
                    WEBRTC_PERM,
                    WEBRTC_PERMISSION_REQUEST_CODE
            )
        }
    }

    private fun startLocalVideo() {
        audioVideo.startLocalVideo()
        _video?.setImageResource(R.drawable.ic_video_on)
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        when (requestCode) {
            WEBRTC_PERMISSION_REQUEST_CODE -> {
                val isMissingPermission: Boolean =
                        grantResults.isEmpty() || grantResults.any { PackageManager.PERMISSION_GRANTED != it }

                if (isMissingPermission) {
                    Toast.makeText(
                            context!!,
                            getString(R.string.user_notification_permission_error),
                            Toast.LENGTH_SHORT
                    )
                            .show()
                } else {
                    startLocalVideo()
                }
                return
            }
        }
    }

    private fun hasPermissionsAlready(): Boolean {
        return WEBRTC_PERM.all {
            ContextCompat.checkSelfPermission(context!!, it) == PackageManager.PERMISSION_GRANTED
        }
    }

    private fun stopCamera() {
        audioVideo.stopLocalVideo()
        _video?.setImageResource(R.drawable.ic_video_off)
    }

    private fun showVideoTile(tileState: VideoTileState) {
        if (tileState.isContent) {
            currentScreenTiles[tileState.tileId] = createVideoCollectionTile(tileState)
        } else {
            currentVideoTiles[tileState.tileId] = createVideoCollectionTile(tileState)
            val myVideo = createVideoCollectionTile(tileState)
            if (myVideo.videoTileState.isLocalTile){
                //this dialer video
                dialerVideo(myVideo)
            }else{
                //this caller video
                callerVideo(myVideo)
            }
        }
    }

    private fun dialerVideo(currentVideo: VideoCollectionTile) {
        dialer_view?.let {
            audioVideo.bindVideoView(it,currentVideo.videoTileState.tileId)
        }
    }
    fun callerVideo(currentVideo: VideoCollectionTile) {
        recipient_view?.let {
            audioVideo.bindVideoView(it,currentVideo.videoTileState.tileId)
        }
        isRemoteAttendeeId=currentVideo.videoTileState.attendeeId
        isAttendeeJoin=true
        //currentRoster[currentVideo.videoTileState.attendeeId]?.volumeLevelgh
    }

    private fun canShowMoreRemoteVideoTile(): Boolean {
        // Current max amount of tiles should preserve one spot for local video
        val currentMax =
                if (currentVideoTiles.containsKey(LOCAL_TILE_ID)) MAX_TILE_COUNT else MAX_TILE_COUNT - 1
        return currentVideoTiles.size < currentMax
    }

    private fun canShowMoreRemoteScreenTile(): Boolean {
        // only show 1 screen share tile
        return currentScreenTiles.isEmpty()
    }

    private fun createVideoCollectionTile(tileState: VideoTileState): VideoCollectionTile {
        val attendeeId = tileState.attendeeId
        attendeeId?.let {
            val attendeeName = currentRoster[attendeeId]?.attendeeName ?: ""
            return VideoCollectionTile(
                    attendeeName,
                    tileState
            )
        }

        return VideoCollectionTile(
                "",
                tileState
        )
    }

    override fun onAttendeesLeft(attendeeInfo: Array<AttendeeInfo>) {
        uiScope.launch {
            mutex.withLock {
                attendeeInfo.forEach { (attendeeId, _) -> currentRoster.remove(attendeeId) }
            }
        }
    }

    override fun onAttendeesMuted(attendeeInfo: Array<AttendeeInfo>) {
        attendeeInfo.forEach { (attendeeId, externalUserId) ->
            logger.info(
                    TAG,
                    "Attendee with attendeeId $attendeeId and externalUserId $externalUserId muted"
            )
            //notify("Attendee with attendeeId $attendeeId and externalUserId $externalUserId muted")
            Log.d(TAG, "onAttendeesMuted: with attendeeId $attendeeId and externalUserId $externalUserId muted")
            uiScope.launch {
                if (isRemoteAttendeeId!=null && isRemoteAttendeeId==attendeeId){
                    var str = externalUserId
                    val mySplitArray= str.split("#")
                    if(mySplitArray.isNotEmpty() && isAttendeeJoin){
                        if(mySplitArray[1]==_callername?.text){
                            _remoteAudio?.visibility=View.VISIBLE
                            _remoteAudio?.setImageResource(R.drawable.ic_mic_off)
                        }
                    }
                }
            }
        }
    }

    override fun onAttendeesUnmuted(attendeeInfo: Array<AttendeeInfo>) {
        attendeeInfo.forEach { (attendeeId, externalUserId) ->
            logger.info(
                    TAG,
                    "Attendee with attendeeId $attendeeId and externalUserId $externalUserId unmuted"
            )
            Log.d(TAG, "onAttendeesUnmuted: with attendeeId $attendeeId and externalUserId $externalUserId unmuted")
            uiScope.launch {
                if (isRemoteAttendeeId!=null && isRemoteAttendeeId==attendeeId){
                    var str = externalUserId
                    val mySplitArray= str.split("#")
                    if(mySplitArray.isNotEmpty() && isAttendeeJoin){
                        if(mySplitArray[1]==_callername?.text){
                            _remoteAudio?.visibility=View.INVISIBLE
                            _remoteAudio?.setImageResource(R.drawable.ic_mic_on)
                        }
                    }
                }
            }
        }
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>) {
        uiScope.launch {
            mutex.withLock {
                signalUpdates.forEach { (attendeeInfo, signalStrength) ->
                    currentRoster[attendeeInfo.attendeeId]?.let {
                        currentRoster[attendeeInfo.attendeeId] =
                                RosterAttendee(
                                        it.attendeeId,
                                        it.attendeeName,
                                        it.volumeLevel,
                                        signalStrength,
                                        it.isActiveSpeaker
                                )
                    }
                }
            }
        }
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>) {
        uiScope.launch {
            mutex.withLock {
                volumeUpdates.forEach { (attendeeInfo, volumeLevel) ->
                    currentRoster[attendeeInfo.attendeeId]?.let {
                        currentRoster[attendeeInfo.attendeeId] =
                                RosterAttendee(
                                        it.attendeeId,
                                        it.attendeeName,
                                        volumeLevel,
                                        it.signalStrength,
                                        it.isActiveSpeaker
                                )
                    }
                }
            }
        }
    }

    override fun onAudioSessionCancelledReconnect() {
        notify("Audio cancelled reconnecting")
    }

    override fun onAudioSessionDropped() {

    }

    override fun onAudioSessionStarted(reconnecting: Boolean) {
        notify("Audio successfully started. reconnecting: $reconnecting")
    }

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean) {
        notify("Audio started connecting. reconnecting: $reconnecting")
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus) {
        notify("Audio stopped for reason: ${sessionStatus.statusCode}")
        if (sessionStatus.statusCode != MeetingSessionStatusCode.OK) {
            //listener.onLeaveMeeting()
        }
    }

    override fun onConnectionBecamePoor() {
        notify("Connection quality has become poor")
    }

    override fun onConnectionRecovered() {
        notify("Connection quality has recovered")
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus) {
        if (sessionStatus.statusCode == MeetingSessionStatusCode.VideoAtCapacityViewOnly) {
            notify("Video encountered an error: ${sessionStatus.statusCode}")
        } else {
            notify("Video successfully started: ${sessionStatus.statusCode}")
        }
    }

    override fun onVideoSessionStartedConnecting() {
        notify("Video started connecting.")
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus) {
        notify("Video stopped for reason: ${sessionStatus.statusCode}")
    }

    override fun onVideoTileAdded(tileState: VideoTileState) {
        uiScope.launch {
            logger.info(
                    TAG,
                    "Video track added, titleId: ${tileState.tileId}, attendeeId: ${tileState.attendeeId}" +
                            ", isContent ${tileState.isContent}"
            )
            if (tileState.isContent) {
                if (!currentScreenTiles.containsKey(tileState.tileId) && canShowMoreRemoteScreenTile()) {
                    showVideoTile(tileState)
                }
            } else {
                // For local video, should show it anyway
                if (tileState.isLocalTile) {
                    showVideoTile(tileState)
                } else if (!currentVideoTiles.containsKey(tileState.tileId)) {
                    if (canShowMoreRemoteVideoTile()) {
                        showVideoTile(tileState)
                    } else {
                        nextVideoTiles[tileState.tileId] = createVideoCollectionTile(tileState)
                    }
                }
            }
        }
    }

    override fun onVideoTilePaused(tileState: VideoTileState) {
        if (tileState.pauseState == VideoPauseState.PausedForPoorConnection) {
            val attendeeName = currentRoster[tileState.attendeeId]?.attendeeName ?: ""
            notify(
                    "Video for attendee $attendeeName " +
                            " has been paused for poor network connection," +
                            " video will automatically resume when connection improves"
            )
        }
    }

    override fun onVideoTileRemoved(tileState: VideoTileState) {
        uiScope.launch {
            val tileId: Int = tileState.tileId

            logger.info(
                    TAG,
                    "Video track removed, titleId: $tileId, attendeeId: ${tileState.attendeeId}"
            )
            if (currentVideoTiles.containsKey(tileId)) {
                audioVideo.unbindVideoView(tileId)
                currentVideoTiles.remove(tileId)
                // Show next video tileState if available
                if (nextVideoTiles.isNotEmpty() && canShowMoreRemoteVideoTile()) {
                    val nextTileState: VideoTileState =
                            nextVideoTiles.entries.iterator().next().value.videoTileState
                    showVideoTile(nextTileState)
                    nextVideoTiles.remove(nextTileState.tileId)
                }
                //videoTileAdapter.notifyDataSetChanged()
            } else if (nextVideoTiles.containsKey(tileId)) {
                nextVideoTiles.remove(tileId)
            } else if (currentScreenTiles.containsKey(tileId)) {
                audioVideo.unbindVideoView(tileId)
                currentScreenTiles.remove(tileId)
                //screenTileAdapter.notifyDataSetChanged()
            }
        }
    }

    override fun onVideoTileResumed(tileState: VideoTileState) {
        val attendeeName = currentRoster[tileState.attendeeId]?.attendeeName ?: ""
        notify("Video for attendee $attendeeName has been unpaused")
    }

    override fun onMetricsReceived(metrics: Map<ObservableMetric, Any>) {
        logger.debug(TAG, "Media metrics received: $metrics")
    }

    override fun onActiveSpeakerDetected(attendeeInfo: Array<AttendeeInfo>) {
        uiScope.launch {
            mutex.withLock {
                var needUpdate = false
                val activeSpeakers = attendeeInfo.map { it.attendeeId }.toSet()
                currentRoster.values.forEach { attendee ->
                    if (activeSpeakers.contains(attendee.attendeeId) != attendee.isActiveSpeaker) {
                        currentRoster[attendee.attendeeId] =
                                RosterAttendee(
                                        attendee.attendeeId,
                                        attendee.attendeeName,
                                        attendee.volumeLevel,
                                        attendee.signalStrength,
                                        !attendee.isActiveSpeaker
                                )
                        needUpdate = true
                    }
                }

                if (needUpdate) {}
            }
        }
    }

    override fun onActiveSpeakerScoreChanged(scores: Map<AttendeeInfo, Double>) {
        logger.debug(TAG, "Active Speakers scores are: $scores")
    }

    private fun notify(message: String) {
        uiScope.launch {
            activity?.let {
                Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
            }
            logger.info(TAG, message)
        }
    }


}
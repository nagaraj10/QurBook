package com.globalmantrainnovations.myfhb

import android.app.Activity
import android.content.pm.PackageManager
import android.speech.RecognizerIntent
import android.speech.tts.TextToSpeech
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import kotlin.collections.ArrayList
import android.app.KeyguardManager
import android.content.*
import android.media.RingtoneManager
import android.os.Bundle
import android.speech.tts.UtteranceProgressListener
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import androidx.core.app.NotificationManagerCompat
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import com.amazonaws.services.chime.sdk.meetings.utils.logger.LogLevel
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.iid.FirebaseInstanceId
import kotlinx.coroutines.*
import java.io.BufferedReader
import java.io.InputStreamReader
import java.lang.Runnable
import java.net.HttpURLConnection
import java.net.URL


class MainActivity : FlutterActivity() {
    private val VERSION_CODES_CHANNEL = "flutter.native/versioncode"
    private val LISTEN4SMS = "flutter.native/listen4sms"
    private val VOICE_CHANNEL = "flutter.native/voiceIntent"
    private val TTS_CHANNEL = "flutter.native/textToSpeech"
    private val SECURITY_CHANNEL = "flutter.native/security"
    private val REQ_CODE = 112
    private val INTENT_AUTHENTICATE = 155
    private var voiceText = ""
    private var langSource: String? = null
    private var langDest: String? = null
    private var FromLang = "en"
    private var ToLang = "ta"
    private var ResultEN: String? = null
    private var ResultDest: String? = null
    var lang_list = arrayOf("English", "Tamil", "Telugu", "Hindi")
    var lang_ref = arrayOf("en_US", "ta_IN", "te_IN", "hi_IN")
    var tts: TextToSpeech? = null

    private lateinit var _result: MethodChannel.Result
    private lateinit var _securityResult: MethodChannel.Result
    private lateinit var _TTSResult: MethodChannel.Result
    //internal var smsBroadcastReceiver: SMSBroadcastReceiver? = null

    private val smsBroadcastReceiver by lazy { SMSBroadcastReceiver() }
    internal var TAG = this@MainActivity::class.toString()
    private val SMS_CONSENT_REQUEST = 2  // Set to an unused request code

    private val CHIME_CHANNEL="flutter.native/chime"
    private val NS_CHANNEL="flutter.native/ns"
    private val NS_MISSED_CALL_CHANNEL="flutter.native/missed_call_ns"
    private val logger = ConsoleLogger(LogLevel.INFO)
    private val uiScope = CoroutineScope(Dispatchers.Main)
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
    private lateinit var chaimeResult: MethodChannel.Result
    private lateinit var nsResult: MethodChannel.Result
    private var isAppInForeground:Boolean = false
    lateinit var nsManager: NotificationManagerCompat
    private val WEBRTC_PERMISSION_REQUEST_CODE = 1
    private val MEETING_REGION = "us-east-1"
    private object HOLDER {
        val INSTANCE = MainActivity()
    }

    private val WEBRTC_PERM = arrayOf(
            android.Manifest.permission.MODIFY_AUDIO_SETTINGS,
            android.Manifest.permission.RECORD_AUDIO
    )

    private var meetingID: String? = null
    private var yourName: String? = null

    companion object {
        const val MEETING_RESPONSE_KEY = "MEETING_RESPONSE"
        const val MEETING_ID_KEY = "MEETING_ID"
        const val NAME_KEY = "NAME"
        const val RESULT_KEY = "RESULT_KEY"
        val instance: MainActivity by lazy { HOLDER.INSTANCE }
    }


     override fun onCreate(savedInstanceState: Bundle?) {
       super.onCreate(savedInstanceState)
       //this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
    }

    var broadcastReceiver: BroadcastReceiver = object:BroadcastReceiver() {
        override fun onReceive(context: Context, intent:Intent) {
            val meetingID = intent.getStringExtra(context.getString(R.string.meetid))
            val recipientName = intent.getStringExtra(context.getString(R.string.username))
            startChime(meetingID,recipientName)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(broadcastReceiver)
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        tts = TextToSpeech(applicationContext, TextToSpeech.OnInitListener { status ->
            if (status != TextToSpeech.ERROR) {
                tts!!.language = Locale("en_US")
            }

        })

        val appSignatureHelper = AppSignatureHelper(applicationContext)
        appSignatureHelper.appSignatures;

        val smsVerificationReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
                    val extras = intent.extras
                    val smsRetrieverStatus = extras?.get(SmsRetriever.EXTRA_STATUS) as Status

                    when (smsRetrieverStatus.statusCode) {
                        CommonStatusCodes.SUCCESS -> {
                            // Get consent intent
                            val consentIntent = extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                            try {
                                // Start activity to show consent dialog to user, activity must be started in
                                // 5 minutes, otherwise you'll receive another TIMEOUT intent
                                startActivityForResult(consentIntent, SMS_CONSENT_REQUEST)
                            } catch (e: ActivityNotFoundException) {
                                // Handle the exception ...
                            }
                        }
                        CommonStatusCodes.TIMEOUT -> {
                            // Time out occurred, handle the error.
                        }
                    }
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VERSION_CODES_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == Constants.APP_VERSION) {
                //logics to get version code
                val appVersion = getAppVersion();
                result.success(appVersion);
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LISTEN4SMS).setMethodCallHandler { call, result ->
            if (call.method == Constants.LISTEN_SMS) {
                //call fucn for listen SMS
                listenForSMS()
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SECURITY_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == Constants.KEY_GAURD) {
                //logics to show security mehods
                _securityResult=result
                secureMe();
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VOICE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == Constants.VOICE_ASST) {
                _result=result
                speakWithVoiceAssistant()

            } else {
                result.notImplemented()
            }
        }
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,TTS_CHANNEL).setMethodCallHandler{ call, result ->
            _TTSResult=result
            if(call.method==Constants.TEXT2SPEECH){
                val msg = call.argument<String>("message")
                val iscls = call.argument<Boolean>("isClose")
                textToSpeech(msg!!,iscls!!)
            }else{
                result.notImplemented()
            }
        }

        nsManager = NotificationManagerCompat.from(this)
        val meet_id =intent.getStringExtra(context.getString(R.string.meetid))
        val uname =intent.getStringExtra(context.getString(R.string.username))
        if(meet_id!=null && uname!=null){
            startChime(meet_id,uname)
        }
        registerReceiver(broadcastReceiver, IntentFilter(context.getString(R.string.intaction_accept_call)))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHIME_CHANNEL).setMethodCallHandler { call, result ->
            try {
                if (call.method == getString(R.string.func_startchime)) {
                    chaimeResult=result
                    val mid = call.argument<String>(getString(R.string.arg_mid))
                    val name = call.argument<String>(getString(R.string.arg_name))
                    if (mid != null && name!=null) {
                        Toast.makeText(this,"Meeting id:${mid} and name:${name}",Toast.LENGTH_LONG).show()
                        startChime(mid,name)
                    }else{
                        Toast.makeText(this,getString(R.string.msg_err_meetid),Toast.LENGTH_LONG).show()
                    }
                    //result.success("activity started")
                }else {
                    result.notImplemented()
                }
            }catch (e:Exception){
                print(e.printStackTrace())
            }

        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NS_CHANNEL).setMethodCallHandler { call, result ->
            try {
                if(call.method ==getString(R.string.func_createns)){
                    val ns_title = call.argument<String>(getString(R.string.pro_ns_title))
                    val ns_body = call.argument<String>(getString(R.string.pro_ns_body))
                    if (ns_title != null && ns_body !=null) {
                        //createNotification(title = ns_title,body=ns_body)
                    }
                }else {
                    result.notImplemented()
                }
            }catch (e:Exception){
                print(e.printStackTrace())
            }

        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NS_MISSED_CALL_CHANNEL).setMethodCallHandler { call, result ->
            try {
                if(call.method ==getString(R.string.func_showms_ns)){
                    nsResult=result
                    val data: Map<String, String>? = call.argument<Map<String,String>>(getString(R.string.pro_data))
                    data?.let { showMissedCallNS(it) }
                }else {
                    result.notImplemented()
                }
            }catch (e:Exception){
                print(e.printStackTrace())
            }

        }

        getCurrentNewToken()

    }

    fun getCurrentNewToken(): String? {
        var mToken:String?=null
        FirebaseInstanceId.getInstance().instanceId
                .addOnCompleteListener(OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        return@OnCompleteListener
                    }

                    // Get new Instance ID token
                    val token = task.result?.token
                    mToken=task.result?.token
                    Log.d(TAG, "My CToken:\n $mToken")
                    Toast.makeText(baseContext, "My CToken:\n$mToken", Toast.LENGTH_SHORT).show()
                })
        return mToken
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
                authenticate(getString(R.string.test_url), meetingID, yourName)
            } else {
                ActivityCompat.requestPermissions(this, WEBRTC_PERM, WEBRTC_PERMISSION_REQUEST_CODE)
            }
        }
    }

    private fun hasPermissionsAlready(): Boolean {
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
                    intent.putExtra(MEETING_RESPONSE_KEY, meetingResponseJson)
                    intent.putExtra(MEETING_ID_KEY, meetingId)
                    intent.putExtra(NAME_KEY, attendeeName)
                    startActivity(intent)
                }
            }

    private suspend fun joinMeeting(
            meetingUrl: String,
            meetingId: String?,
            attendeeName: String?
    ): String? {
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
                val conn: HttpURLConnection = serverUrl.openConnection() as HttpURLConnection
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

    fun showMissedCallNS(data:Map<String, String> = HashMap()) {
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        val NS_ID = 9091
        val MEETING_ID = data.get(getString(R.string.meetid))
        val USER_NAME = data.get(getString(R.string.username))
        var alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        /*if (Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            val channel1 = NotificationChannel(
                    CHANNEL_INCOMING,
                    "channel 2",
                    NotificationManager.IMPORTANCE_HIGH
            )
            channel1.description = "This is channel is for missed call"
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel1)
        }

//        var activityIntent = Intent(this, NotificationActivity::class.java)
//                .putExtra("name", "mohan")
//                .putExtra("id", "1234")
//        var contentIntent = PendingIntent.getActivity(this,
//                0, activityIntent, PendingIntent.FLAG_UPDATE_CURRENT)


        val declineIntent = Intent(applicationContext, DeclineReciver::class.java)
        declineIntent.putExtra("notificationId", NS_ID)
        val declinePendingIntent = PendingIntent.getBroadcast(applicationContext, 0, declineIntent, 0)

        val acceptIntent = Intent(applicationContext, NotificationActivity::class.java)
                .putExtra("username", USER_NAME)
                .putExtra("meeting_id", MEETING_ID)
                .putExtra("notificationId", NS_ID)
        val acceptPendingIntent = PendingIntent.getActivity(this, 0, acceptIntent, PendingIntent.FLAG_UPDATE_CURRENT)


        val fullScreenIntent = Intent(this, NotificationActivity::class.java)
                .putExtra("username", USER_NAME)
                .putExtra("meeting_id", MEETING_ID)
                .putExtra("notificationId", NS_ID)
        val fullScreenPendingIntent = PendingIntent.getActivity(this, 0,
                fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT)


        var notification = NotificationCompat.Builder(this, CHANNEL_INCOMING)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Missed Call From")
                .setContentText("Mohan")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setDefaults(Notification.DEFAULT_ALL)
                .setContentIntent(fullScreenPendingIntent)
                .addAction(R.drawable.ic_missed_call, "call back", acceptPendingIntent)
                .addAction(R.drawable.ic_clear, "cancel", declinePendingIntent)
                .setAutoCancel(true)
                //.setFullScreenIntent(fullScreenPendingIntent,true)
                .setSound(alarmSound)
                .build()


        nsManager.notify(NS_ID,notification)*/

    }

    private fun speakWithVoiceAssistant() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        //intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault());
        GetSrcTargetLanguages()
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, "en_US")
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, Constants.VOICE_ASST_PROMPT)
        intent.addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT)
        try {
            startActivityForResult(intent, REQ_CODE)
        } catch (a: ActivityNotFoundException){}
    }

    private fun listenForSMS(){
        //Initialize the SmsRetriever client
        val client = SmsRetriever.getClient(this)
        //Start the SMS Retriever task
        val task = client.startSmsRetriever()
        task.addOnSuccessListener { aVoid ->
            //if successfully started, then start the receiver.
            //registerReceiver(smsBroadcastReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))

            Toast.makeText(this@MainActivity,"Listener started", Toast.LENGTH_SHORT).show()

            val otpListener = object : SMSBroadcastReceiver.OTPListener {
                override fun onOTPReceived(otp: String) {
                    //customCodeInput.setText(otp)
                    Toast.makeText(this@MainActivity, otp , Toast.LENGTH_LONG).show()
                }

                override fun onOTPTimeOut() {
                    Toast.makeText(this@MainActivity,"TimeOut", Toast.LENGTH_SHORT).show()
                }
            }
            smsBroadcastReceiver.injectOTPListener(otpListener)
            registerReceiver(smsBroadcastReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))
        }


        task.addOnFailureListener {
            Toast.makeText(this@MainActivity,"Problem to start listener", Toast.LENGTH_SHORT).show()
        }

    }

    private fun secureMe(){
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            val km: KeyguardManager = getSystemService(android.content.Context.KEYGUARD_SERVICE) as KeyguardManager
            if (km.isKeyguardSecure) {
                val authIntent: Intent = km.createConfirmDeviceCredentialIntent(Constants.KEY_GAURD_TITLE, Constants.KEY_GAURD_TITLE_DESC)
                startActivityForResult(authIntent, INTENT_AUTHENTICATE)
            }
        }
    }


    private fun textToSpeech(msg:String,isClose:Boolean){
        tts!!.setSpeechRate(1.0f)
        if(isClose){
            tts!!.stop()
        }else{
            tts!!.speak(msg, TextToSpeech.QUEUE_FLUSH, null,
                    TextToSpeech.Engine.KEY_PARAM_UTTERANCE_ID)
        }

        tts!!.setOnUtteranceProgressListener(object : UtteranceProgressListener(){
            override fun onDone(p0: String?) {
                runOnUiThread(Runnable { _TTSResult.success(1) })

            }

            override fun onError(p0: String?) {}

            override fun onStart(p0: String?) {}

        })

    }

    private fun getAppVersion(): String {
        val versionCode: Int = BuildConfig.VERSION_CODE
        val versionName: String = BuildConfig.VERSION_NAME

        return "v$versionName b${versionCode.toString()}"
    }

    private fun requestPermissionFromUSer(){
        ActivityCompat.requestPermissions(this,arrayOf(android.Manifest.permission.RECORD_AUDIO),REQ_CODE)
    }

    fun GetSrcTargetLanguages() {
        langSource = "en_US"
//        var fl = spinFromLang!!.selectedItem.toString()
//        var pos = findString(lang_list, fl)
//        if (pos != -1) langSource = lang_ref[pos]
        langDest = "en_US"
//        fl = spinToLang!!.selectedItem.toString()
//        pos = findString(lang_list, fl)
//        if (pos != -1) langDest = lang_ref[pos]
        FromLang = langSource!!.substring(0, 2)
        ToLang = langDest!!.substring(0, 2)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQ_CODE -> {
                if (resultCode == Activity.RESULT_OK && data != null) {
                    val result: ArrayList<*> = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
                    val finalWords = result[0].toString()
                    _result.success(finalWords)
                }
            }
            INTENT_AUTHENTICATE -> {
                if (resultCode == Activity.RESULT_OK) {
                    _securityResult.success(Constants.KEY_GAURD_AUTH_SUCC)
                }else{
                    _securityResult.success(Constants.KEY_GAURD_AUTH_FAIL)
                }
            }
            /*SMS_CONSENT_REQUEST ->
                // Obtain the phone number from the result
                if (resultCode == Activity.RESULT_OK && data != null) {
                    // Get SMS message content
                    val message = data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
                    // Extract one-time code from the message and complete verification
                    // `message` contains the entire text of the SMS message, so you will need
                    // to parse the string.
                    Log.v("my current message otp:",message)
                    //val oneTimeCode = parseOneTimeCode(message) // define this function

                    // send one time code to the server
                } else {
                    // Consent denied. User can type OTC manually.
                }*/

        }
    }

}

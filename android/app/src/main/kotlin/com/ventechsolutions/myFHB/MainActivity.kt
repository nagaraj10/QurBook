package com.ventechsolutions.myFHB

import android.app.Activity
import android.speech.RecognizerIntent
import android.speech.tts.TextToSpeech
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import kotlin.collections.ArrayList
import android.content.Intent
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import android.app.KeyguardManager
import android.content.*
import android.os.Bundle
import android.speech.tts.UtteranceProgressListener
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import android.view.WindowManager
import androidx.multidex.BuildConfig
import com.ventechsolutions.myFHB.constants.Constants
import com.ventechsolutions.myFHB.services.AVServices
import kotlin.system.exitProcess


class MainActivity : FlutterActivity() {
    private val VERSION_CODES_CHANNEL = Constants.CN_VC
    private val LISTEN4SMS = Constants.CN_LISTEN4SMS
    private val VOICE_CHANNEL = Constants.CN_VOICE_INTENT
    private val TTS_CHANNEL = Constants.CN_TTS
    private val SECURITY_CHANNEL = Constants.CN_SECURE
    private val ROUTE_CHANNEL=Constants.CN_ROUTE
    private val ONGOING_NS_CHANNEL=Constants.CN_ONG_NS
    private val STREAM = Constants.CN_EVE_STREAM
    private var sharedValue: String? = null
    private var username: String? = null
    private var templateName: String? = null
    private var bookingId: String? = null
    private var appDate: String? = null
    private var docSessionId: String? = null
    private var healthOrgId: String? = null
    private var docId: String? = null
    private var docPic: String? = null
    private lateinit var mEventChannel:EventSink
    private val REQ_CODE = 112
    private val INTENT_AUTHENTICATE = 155
    private var voiceText = ""
    private var langSource: String? = null
    private var langDest: String? = null
    private var FromLang = Constants.FROM_LANG
    private var ToLang = Constants.TO_LANG
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
    private val SMS_CONSENT_REQUEST = 2  // Set to an unused request code
    private var patId: String? = null
    private var patName: String? = null
    private var patPic: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //todo this must be un command when go to production
        //this.window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);

        val action = intent.action
        val type = intent.type
        if (Intent.ACTION_SEND == action && type != null) {
            if (Constants.TXT_PLAIN == type) {
                handleSendText(intent); // Handle text being sent
            }
        }
        //registerReceiver(smsBroadcastReceiver,
        //IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))

    }


    /* override fun onStop() {
         super.onStop()
         unregisterReceiver(smsBroadcastReceiver)
     }*/


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        tts = TextToSpeech(applicationContext, TextToSpeech.OnInitListener { status ->
            if (status != TextToSpeech.ERROR) {
                //tts!!.language = Locale(Constants.EN_US) //todo this need to be comment
            }

        })

        val appSignatureHelper = AppSignatureHelper(applicationContext)
        appSignatureHelper.appSignatures

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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ROUTE_CHANNEL).setMethodCallHandler { call, result ->
            try {
                if(call.method!!.contentEquals(Constants.FUN_GET_MY_ROUTE)){
                    result.success(sharedValue)
                    sharedValue=null
                }else {
                    result.notImplemented()
                }
            }catch (e:Exception){
                print(e.printStackTrace())
            }

        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ONGOING_NS_CHANNEL).setMethodCallHandler { call, result ->
            try {
                if(call.method!!.contentEquals(Constants.FUN_ONG_NS)){
                    val passedMode = call.argument<String>(Constants.PROP_MODE)
                    startOnGoingNS(username!!,passedMode!!)
                }else {
                    result.notImplemented()
                }
            }catch (e:Exception){
                print(e.printStackTrace())
            }

        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger,STREAM).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventSink?) {
                        mEventChannel=events!!
                    }

                    override fun onCancel(arguments: Any?) {
                    }
                }
        )


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VERSION_CODES_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_APP_VERSION) {
                //logics to get version code
                val appVersion = getAppVersion();
                result.success(appVersion);
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LISTEN4SMS).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_LISTEN_SMS) {
                listenForSMS()
            } else {
                result.notImplemented()
            }
        }


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SECURITY_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_KEY_GAURD) {
                //logics to show security methods
                _securityResult=result
                secureMe()
            } else {
                result.notImplemented()
            }
        }



        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VOICE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_VOICE_ASST) {
                val lang_code = call.argument<String>(Constants.PROP_LANG_CODE) //todo uncomment this line
                _result=result
                speakWithVoiceAssistant(lang_code!!) //todo uncomment this line
                //speakWithVoiceAssistant()//todo line need to remove
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,TTS_CHANNEL).setMethodCallHandler{ call, result ->
            _TTSResult=result
            if(call.method==Constants.FUN_TEXT2SPEECH){
                val msg = call.argument<String>(Constants.PROP_MSG)
                val iscls = call.argument<Boolean>(Constants.PROP_IS_CLOSE)
                val langCode = call.argument<String>(Constants.PROP_LANG) //todo this has to be uncomment
                tts!!.language = Locale(langCode!!) //todo this has to be uncomment
                textToSpeech(msg!!,iscls!!)
            }else{
                result.notImplemented()
            }
        }
    }

    private fun startOnGoingNS(name:String,mode:String){
        if(mode == Constants.PROP_START){
            val serviceIntent = Intent(this, AVServices::class.java)
            serviceIntent.putExtra(Constants.PROP_NAME,name)
            startService(serviceIntent)
        }else if(mode==Constants.PROP_STOP){
            val serviceIntent = Intent(this, AVServices::class.java)
            stopService(serviceIntent)
        }
    }

    fun handleSendText(intent: Intent) {
        sharedValue = intent.getStringExtra(Intent.EXTRA_TEXT)
        username = intent.getStringExtra(getString(R.string.username))
        docId = intent.getStringExtra(Constants.PROP_docId)
        docPic= intent.getStringExtra(getString(R.string.docPic))
        bookingId= intent.getStringExtra(Constants.PROP_BookingId)
        appDate= intent.getStringExtra(Constants.PROP_PlannedStartTime)
        docSessionId= intent.getStringExtra(Constants.PROP_docSessionId)
        healthOrgId= intent.getStringExtra(Constants.PROP_healthOrgId)
        templateName= intent.getStringExtra(Constants.PROP_TEMP_NAME)
        val providerReqId = intent.getStringExtra(Constants.PROP_PROVIDER_REQID)
        val redirect_to = intent.getStringExtra(Constants.PROP_REDIRECT_TO)
        val data = intent.getStringExtra(Constants.PROP_DATA)
        patId = intent.getStringExtra(getString(R.string.pat_id))
        patName = intent.getStringExtra(getString(R.string.pat_name))
        patPic = intent.getStringExtra(getString(R.string.pat_pic))
        if(sharedValue!=null && sharedValue =="chat"){
            sharedValue="$sharedValue"
        }else if(sharedValue!=null && username !=null && docId!=null && docPic !=null){
            sharedValue="$sharedValue&$username&$docId&$docPic&${Constants.PROP_CALL}&${patId}&${patName}&${patPic}"
        }else if(sharedValue==Constants.PROP_DOC_RESCHDULE){
            //todo redirect to telehealth page
            sharedValue="${Constants.PROP_DOC_RESCHDULE}&${docId!!}&${bookingId}&${docSessionId}&${healthOrgId}&${templateName}"
        }else if(sharedValue==Constants.PROP_DOC_CANCELLATION){
            //todo redirect to telehealth page
            sharedValue="${Constants.PROP_DOC_CANCELLATION}&${bookingId!!}&${appDate}&${templateName}"
        }else if(providerReqId != null && providerReqId != ""){
            if(sharedValue==Constants.PROP_ACCEPT){
                sharedValue="$sharedValue&${providerReqId}&${"accepted"}"
            }else{
                sharedValue="$sharedValue&${providerReqId}&${"rejected"}"
            }
        }else{
            if(data != null){
                sharedValue="${Constants.PROP_ACK}&${redirect_to!!}&${data!!}"
            }else{
                sharedValue="${Constants.PROP_ACK}&${redirect_to!!}&${""}"
            }

        }
        if (::mEventChannel.isInitialized){mEventChannel.success(sharedValue)}
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val action = intent.action
        val type = intent.type
        if (Intent.ACTION_SEND == action && type != null) {
            if (Constants.TXT_PLAIN == type) {
                handleSendText(intent); // Handle text being sent
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        val serviceIntent = Intent(this, AVServices::class.java)
        stopService(serviceIntent)
    }

    //todo this method need to uncomment
    private fun speakWithVoiceAssistant(langCode:String) {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        //intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault()) //todo this has to be comment
        GetSrcTargetLanguages()
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, langCode) //todo this has to be uncomment
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, Constants.VOICE_ASST_PROMPT)
        intent.addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT)
        try {
            startActivityForResult(intent, REQ_CODE)
        } catch (a: ActivityNotFoundException) {
            // Toast.makeText(applicationContext,
            //         "Sorry your device not supported",
            //         Toast.LENGTH_SHORT).show()
            //CalledFromListen = false
        }
//         tts = TextToSpeech(applicationContext, TextToSpeech.OnInitListener { status ->
//             if (status != TextToSpeech.ERROR) {
//                 tts!!.language = Locale(langDest)
//             }
//         })
    }

    //todo this method need to remove
    /*private fun speakWithVoiceAssistant() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault()) //todo this has to be comment
        GetSrcTargetLanguages()
        //intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, langCode) //todo this has to be uncomment
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, Constants.VOICE_ASST_PROMPT)
        intent.addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT)
        try {
            startActivityForResult(intent, REQ_CODE)
        } catch (a: ActivityNotFoundException) {
            // Toast.makeText(applicationContext,
            //         "Sorry your device not supported",
            //         Toast.LENGTH_SHORT).show()
            //CalledFromListen = false
        }
        /* tts = TextToSpeech(applicationContext, TextToSpeech.OnInitListener { status ->
             if (status != TextToSpeech.ERROR) {
                 tts!!.language = Locale(langDest)
             }
         })*/
    }*/

    private fun listenForSMS(){
        //Initialize the SmsRetriever client
        val client = SmsRetriever.getClient(this)
        //Start the SMS Retriever task
        val task = client.startSmsRetriever()
        task.addOnSuccessListener { aVoid ->
            //if successfully started, then start the receiver.
            //registerReceiver(smsBroadcastReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))

            //Toast.makeText(this@MainActivity,"Listener started", Toast.LENGTH_SHORT).show()

            val otpListener = object : SMSBroadcastReceiver.OTPListener {
                override fun onOTPReceived(otp: String) {
                    //customCodeInput.setText(otp)
                    Toast.makeText(this@MainActivity, otp , Toast.LENGTH_LONG).show()
                }

                override fun onOTPTimeOut() {
                    //Toast.makeText(this@MainActivity,"TimeOut", Toast.LENGTH_SHORT).show()
                }
            }
            smsBroadcastReceiver.injectOTPListener(otpListener)
            registerReceiver(smsBroadcastReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))
        }


        task.addOnFailureListener {
            //Toast.makeText(this@MainActivity,"Problem to start listener", Toast.LENGTH_SHORT).show()
        }

    }

    private fun secureMe(){
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            val km: KeyguardManager = getSystemService(android.content.Context.KEYGUARD_SERVICE) as KeyguardManager
            if (km.isKeyguardSecure()) {
                //user has set pin/password/pattern
                val authIntent: Intent = km.createConfirmDeviceCredentialIntent(Constants.KEY_GAURD_TITLE, Constants.KEY_GAURD_TITLE_DESC)
                startActivityForResult(authIntent, INTENT_AUTHENTICATE)
            }else{
                //user has not enabled any password/pin/pattern
                _securityResult.success(1004)
                return
            }
        }else{
            //there is no key guard feature below Android 5.0
            _securityResult.success(1000)
            return
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
        langSource = Constants.EN_US
//        var fl = spinFromLang!!.selectedItem.toString()
//        var pos = findString(lang_list, fl)
//        if (pos != -1) langSource = lang_ref[pos]
        langDest = Constants.EN_US
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
                    //Toast.makeText(applicationContext, "You said:\n$finalWords", Toast.LENGTH_LONG).show()
                    _result.success(finalWords)
                }
            }
            INTENT_AUTHENTICATE -> {
                if (resultCode == Activity.RESULT_OK) {
                    _securityResult.success(1002)
                }else{
                    //_securityResult.success(1003)
                    finishAffinity()
                    exitProcess(0)
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

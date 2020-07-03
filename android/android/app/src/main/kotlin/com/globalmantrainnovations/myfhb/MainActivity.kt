package com.globalmantrainnovations.myfhb

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.speech.RecognizerIntent
import android.speech.tts.TextToSpeech
import android.text.Html
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.loopj.android.http.JsonHttpResponseHandler
import com.loopj.android.http.TextHttpResponseHandler
import cz.msebera.android.httpclient.Header
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONException
import org.json.JSONObject
import java.lang.reflect.GenericArrayType
import java.util.*
import java.util.jar.Manifest
import kotlin.collections.ArrayList
import android.R


import android.content.Context.KEYGUARD_SERVICE
import android.app.KeyguardManager

import android.R.attr.data
import android.content.*
import android.os.Bundle
import android.os.PersistableBundle
import android.speech.tts.UtteranceProgressListener
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import android.view.WindowManager
import android.view.WindowManager.LayoutParams


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

     override fun onCreate(savedInstanceState: Bundle?) {
       super.onCreate(savedInstanceState)
       this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
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
            if (km.isKeyguardSecure()) {
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

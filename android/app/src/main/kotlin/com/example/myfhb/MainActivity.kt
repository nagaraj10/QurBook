package com.example.myfhb

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
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
import android.content.Context.KEYGUARD_SERVICE
import android.app.KeyguardManager

class MainActivity : FlutterActivity() {
    private val VERSION_CODES_CHANNEL = "flutter.native/versioncode"
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



    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VERSION_CODES_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppVersion") {
                //logics to get version code
                val appVersion = getAppVersion();
                result.success(appVersion);
            } else {
                result.notImplemented()
            }
        }

         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SECURITY_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "secureMe") {
                //logics to show security mehods
                _securityResult=result
                secureMe();

            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VOICE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "speakWithVoiceAssistant") {
                _result=result
                val rec_Permisson = ContextCompat.checkSelfPermission(this,android.Manifest.permission.RECORD_AUDIO)
                if(rec_Permisson==PackageManager.PERMISSION_GRANTED && tts?.isSpeaking()!=true){
                    speakWithVoiceAssistant()
                    //result.success(voiceText)
                }else{
                    Log.i("RECORD_PERMISSION","we cant record without your permission.")
                    requestPermissionFromUSer()
                }

            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,TTS_CHANNEL).setMethodCallHandler{ call, result ->
            if(call.method=="textToSpeech"){
                val msg = call.argument<String>("message")
                textToSpeech(msg!!)
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
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Need to speak")
        try {
            startActivityForResult(intent, REQ_CODE)
        } catch (a: ActivityNotFoundException) {
            // Toast.makeText(applicationContext,
            //         "Sorry your device not supported",
            //         Toast.LENGTH_SHORT).show()
            //CalledFromListen = false
        }
        tts = TextToSpeech(applicationContext, TextToSpeech.OnInitListener { status ->
            if (status != TextToSpeech.ERROR) {
                tts!!.language = Locale(langDest)
            }
        })
    }

     private fun secureMe(){
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            val km: KeyguardManager = getSystemService(android.content.Context.KEYGUARD_SERVICE) as KeyguardManager
            if (km.isKeyguardSecure()) {
                val authIntent: Intent = km.createConfirmDeviceCredentialIntent("MyFHB", "Please Authorize to use the Application")
                startActivityForResult(authIntent, INTENT_AUTHENTICATE)
            }
        }
    }

    private fun textToSpeech(msg:String){
        tts!!.speak(msg, TextToSpeech.QUEUE_FLUSH, null)
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
                    //Toast.makeText(applicationContext, "You said:\n$finalWords", Toast.LENGTH_LONG).show()
                    _result.success(finalWords)
                }
            }
            INTENT_AUTHENTICATE -> {
                if (resultCode == Activity.RESULT_OK && data != null) {
                    _securityResult.success(true)
                }else{
                    _securityResult.success(false)
                }
            }
        }
    }


    /*fun sendToMaya(Utterance: String?) {
        //var identity = editIdentity!!.text.toString()
        var identity = "test@default.com"
        //if (identity.length == 0) identity = "test@default.com"
        Http.postToMaya(identity, Utterance, object : TextHttpResponseHandler() {
            override fun onSuccess(statusCode: Int, headers: Array<Header>, response: String) {
                println("postToMaya:$response")
                //textViewMaya!!.text = response
                requestTranslation(response, "en", ToLang, 2)
            }

            override fun onFailure(statusCode: Int, headers: Array<Header>, response: String, throwable: Throwable) {
                println(statusCode)
                if (response != null) {
                    println(response)
                    Log.d("YOU_TOLD_ME", response)
                }
            }
        })
    }*/


    /*fun requestTranslation(txt: String, From: String, To: String, pass: Int) {
        println("Translation .$From-$To")
        if (From.equals("en", ignoreCase = true) && From.equals(To, ignoreCase = true)) {
            println("Translation Not Required")
            if (pass == 1) {
                sendToMaya(txt)
            } else {
                tts!!.speak(txt, TextToSpeech.QUEUE_FLUSH, null)
            }
            return
        }
        *//*        if (pass == 1) {
            textViewEN!!.text = "Loading..."
        } else {
            textViewDest!!.text = "Loading..."
        }
        *//*
        Http.post(txt, From, To, object : JsonHttpResponseHandler() {
            @RequiresApi(api = Build.VERSION_CODES.N)
            override fun onSuccess(statusCode: Int, headers: Array<Header>, response: JSONObject) {
                println(response.toString())
                try {
                    val serverResp = JSONObject(response.toString())
                    val jsonObject = serverResp.getJSONObject("data")
                    val transObject = jsonObject.getJSONArray("translations")
                    val transObject2 = transObject.getJSONObject(0)
                    println("TranslationPass:$pass")
                    if (pass == 1) {
                        ResultEN = transObject2.getString("translatedText")
                        ResultEN = Html.fromHtml(ResultEN, Html.FROM_HTML_MODE_LEGACY).toString()
                        //textViewEN!!.text = ResultEN
                        sendToMaya(ResultEN)
                    } else {
                        ResultDest = transObject2.getString("translatedText")
                        ResultDest = Html.fromHtml(ResultDest, Html.FROM_HTML_MODE_LEGACY).toString()
                        //textViewDest!!.text = ResultDest
                        tts!!.speak(ResultDest, TextToSpeech.QUEUE_FLUSH, null)
                    }
                } catch (e: JSONException) { // TODO Auto-generated catch block
                    e.printStackTrace()
                }
            }

        })
    }*/


}

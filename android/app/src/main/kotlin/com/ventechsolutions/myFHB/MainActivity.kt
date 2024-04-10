package com.ventechsolutions.myFHB

import android.Manifest
import android.annotation.SuppressLint
import android.app.*
import android.bluetooth.*
import android.content.*
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.location.Location
import android.location.LocationManager
import android.media.AudioManager
import android.net.*
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.net.wifi.WifiNetworkSpecifier
import android.os.*
import android.preference.PreferenceManager
import android.provider.Settings
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.text.Editable
import android.text.TextWatcher
import android.util.AndroidRuntimeException
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.Window
import android.view.inputmethod.InputMethodManager
import android.widget.*
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.facebook.FacebookSdk
import com.facebook.FacebookSdk.fullyInitialize
import com.facebook.FacebookSdk.setAutoInitEnabled
import com.facebook.FacebookSdk.setAutoLogAppEventsEnabled
import com.facebook.LoggingBehavior
import com.facebook.appevents.AppEventsLogger
import com.facebook.applinks.AppLinkData
import com.github.ybq.android.spinkit.SpinKitView
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import com.gsh.api.BluetoothStatus
import com.gsh.spo2.api.GoldenBLEDeviceManager
import com.gsh.spo2.api.GoldenBLEDeviceManagerCallback
import com.gsh.weightscale.api.WeightData
import com.lifesense.plugin.ble.LSBluetoothManager
import com.lifesense.plugin.ble.OnPairingListener
import com.lifesense.plugin.ble.OnSearchingListener
import com.lifesense.plugin.ble.OnSyncingListener
import com.lifesense.plugin.ble.data.*
import com.lifesense.plugin.ble.data.bgm.BGDataSummary
import com.lifesense.plugin.ble.data.bpm.LSBloodPressure
import com.lifesense.plugin.ble.data.scale.LSScaleState
import com.lifesense.plugin.ble.data.scale.LSScaleWeight
import com.lifesense.plugin.ble.data.tracker.ATDeviceData
import com.lifesense.plugin.ble.data.tracker.ATPairResultsCode
import com.lifesense.plugin.ble.data.tracker.ATUserInfo
import com.neovisionaries.bluetooth.ble.advertising.ADStructure
import com.ventechsolutions.myFHB.bloodpressure.controller.BluetoothPowerController
import com.ventechsolutions.myFHB.bloodpressure.controller.ScanController
import com.ventechsolutions.myFHB.bloodpressure.controller.util.AppLog
import com.ventechsolutions.myFHB.bloodpressure.model.entity.DiscoveredDevice
import com.ventechsolutions.myFHB.bloodpressure.model.entity.SessionData
import com.ventechsolutions.myFHB.bloodpressure.model.enumerate.SettingKey
import com.ventechsolutions.myFHB.bluetooth.BleManager
import com.ventechsolutions.myFHB.bluetooth.callback.BleGattCallback
import com.ventechsolutions.myFHB.bluetooth.callback.BleIndicateCallback
import com.ventechsolutions.myFHB.bluetooth.callback.BleNotifyCallback
import com.ventechsolutions.myFHB.bluetooth.callback.BleScanCallback
import com.ventechsolutions.myFHB.bluetooth.data.BleDevice
import com.ventechsolutions.myFHB.bluetooth.exception.BleException
import com.ventechsolutions.myFHB.constants.Constants
import com.ventechsolutions.myFHB.services.*
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import jp.co.ohq.androidcorebluetooth.CBConfig.CreateBondOption
import jp.co.ohq.androidcorebluetooth.CBConfig.RemoveBondOption
import jp.co.ohq.ble.OHQConfig
import jp.co.ohq.ble.enumerate.*
import jp.co.ohq.utility.Bundler
import jp.co.ohq.utility.Types
import java.util.*
import kotlin.experimental.and
import kotlin.system.exitProcess

class MainActivity : FlutterFragmentActivity(),
    BluetoothPowerController.Listener {
    private var wowGoDeviceList: ArrayList<String>?=null
    private var wowGoFunctionIndex=0
    private var wowgoFunctionList: ArrayList<Unit>?=null
    private var currentConnectedTime: Long=0
    private var devicesList= listOf<Any>()
    private var deviceType=""
    private var manufacture=""
    private var scanType=""
    private var macIdLsDevice=""
    private var deviceName=""
    private lateinit var lsDeviceInfo: LSDeviceInfo
    private var enableBackgroundNotification = false

    //    private lateinit var bluetoothFlutterResult: MethodChannel.Result
    private val LISTEN4SMS = Constants.CN_LISTEN4SMS
    private val VOICE_CHANNEL = Constants.CN_VOICE_INTENT
    private val TTS_CHANNEL = Constants.CN_TTS
    private val ONGOING_NS_CHANNEL = Constants.CN_ONG_NS
    private val SPEECH_TO_TEXT_STREAM = Constants.SPEECH_TO_TEXT_STREAM
    private val WIFICONNECT = Constants.WIFI_WORKS
    private val BLECONNECT = Constants.BLE_CONNECT
    private val DEVICES_CHANNEL = Constants.DEVICES_CHANNEL
    private val BPCONNECT = Constants.BP_CONNECT
    private val BLE_SCAN_CANCEL = Constants.BLE_SCAN_CANCEL
    private val BP_CONNECT_CANCEL = Constants.BP_SCAN_CANCEL
    private val BP_ENABLE_CHECK = Constants.BP_ENABLE_CHECK
    private val LOCATION_SERVICE_CHECK = Constants.LOCATION_SERVICE_CHECK
    private val IS_NOTIFICATION_PERMISSION_CHECK = Constants.IS_NOTIFICATION_PERMISSION_CHECK
    private val ENABLE_BACKGROUND_NOTIFICATION = Constants.ENABLE_BACKGROUND_NOTIFICATION
    private val DISABLE_BACKGROUND_NOTIFICATION = Constants.DISABLE_BACKGROUND_NOTIFICATION
    private val GET_CURRENT_LOCATION = Constants.GET_CURRENT_LOCATION
    private val CLOSE_SHEELA_DIALOG = Constants.CLOSE_SHEELA_DIALOG
    private var username: String? = null
    private lateinit var mSpeechToTextEventChannel: EventSink
    private lateinit var BLEEventChannel: EventSink
    private val REQ_CODE = 112
    private val INTENT_AUTHENTICATE = 155
    private var langSource: String? = null
    private var langDest: String? = null
    private var FromLang = Constants.FROM_LANG
    private var ToLang = Constants.TO_LANG
    private var ResultEN: String? = null
    private var ResultDest: String? = null
    var lang_list = arrayOf("English", "Tamil", "Telugu", "Hindi")
    var lang_ref = arrayOf("en_US", "ta_IN", "te_IN", "hi_IN")
    var tts: TextToSpeech? = null
    private var finalWords: String? = ""


    private var _result: MethodChannel.Result? = null
    private lateinit var _securityResult: MethodChannel.Result
    private lateinit var _TTSResult: MethodChannel.Result
    //internal var smsBroadcastReceiver: SMSBroadcastReceiver? = null

    //Blood pressure
    private lateinit var _resultBp: MethodChannel.Result
    private lateinit var _resultBpCancel: MethodChannel.Result

    private val smsBroadcastReceiver by lazy { SMSBroadcastReceiver() }
    private val SMS_CONSENT_REQUEST = 2  // Set to an unused request code
    private var patId: String? = null
    private var patName: String? = null
    private var patPic: String? = null
    private var isPartialResultInvoked: Boolean? = false
    private var speechRecognizer: SpeechRecognizer? = null
    private var speechIntent: Intent? = null
    private lateinit var dialog: Dialog
    private lateinit var countDownTimerDialog: Dialog

    var countDown: CountDownTimer? = null
    var firstTimeSpeechError=true;
    var measurementNotTaken=true;
    //private lateinit var builder: AlertDialog.Builder
    internal lateinit var displayText: EditText
    internal lateinit var sendBtn: Button
    internal lateinit var edit_view: LinearLayout
    internal lateinit var errorTxt: TextView

    internal lateinit var countDownTimer: TextView

    //internal lateinit var errorTxt: TextView
    internal lateinit var tryMe: LinearLayout
    internal lateinit var listeningLayout: LinearLayout
    internal lateinit var tryAgain: ImageView
    internal lateinit var customLayout: View
    internal lateinit var countDownTimerLayout: View
    internal lateinit var spin_kit: SpinKitView
    internal lateinit var close: ImageView
    internal lateinit var micOn: ImageView

    private val REQUEST_CODE_OPEN_GPS = 1
    private val REQUEST_CODE_PERMISSION_LOCATION = 2
    private val REQUEST_CODE_PERMISSION_NOTIFICATION = 3

    private val DEVICE_SPO2 = 1
    private val DEVICE_TEMP = 2
    private val DEVICE_WT = 3
    private val DEVICE_BP = 4
    private val DEVICE_BGL = 5
    private val DEVICE_WEIGHT = 3


    var autoRepeatScan = 1

    var postBleData: String? = null

    var scanningBleTimer = Timer()

    var bleName: String? = null

    //private var mOHQDeviceManager: OHQDeviceManager? = null

    private val ARG_MODE = "ARG_MODE"
    private val ARG_ADDRESS = "ARG_ADDRESS"
    private val ARG_OPTION = "ARG_OPTION"
    private val ARG_PARTIAL_HISTORY_DATA = "ARG_PARTIAL_HISTORY_DATA"

    private val CONNECTION_WAIT_TIME: Long = 60000
    //private var mSessionController: SessionController? = null

    private var mAddress = ""

    //private var mOption: Map<OHQSessionOptionKey, Object> = HashMap()
    private var mOption: MutableMap<OHQSessionOptionKey, Any> = mutableMapOf()

    private val mListener: ScanController.Listener? = null

    private var mSessionAddress: String? = null

    private var mSessionData = SessionData()

    //var mDiscoverDevice: DiscoveredDevice? = null

    var specifiedUserControl = true

    private val CONSENT_CODE_OHQ = 0x020E
    private val CONSENT_CODE_UNREGISTERED_USER = 0x0000

    private val USER_INDEX_UNREGISTERED_USER = 0xFF

    private val mDiscoveredDevices = LinkedHashMap<String, DiscoveredDevice>()
    var mLocationManager: LocationManager? = null
    private val lbm by lazy { LocalBroadcastManager.getInstance(this) }

    //Wow Bluetooth
    private var gManager: GoldenBLEDeviceManager? = null
    private var gManagerBP: com.gsh.bloodpressure.api.GoldenBLEDeviceManager? = null
    private var gManagerFat: com.gsh.weightscale.api.GoldenBLEDeviceManager? = null
    private var selectedBle = ""

    private val handlerBle = Handler(Looper.getMainLooper())
    private val handlerBleWowGo = Handler(Looper.getMainLooper())
    private var isExecuting = false

    var wowGoTimer = Timer()

    var sheelaTTSWordList: ArrayList<String> = arrayListOf<String>("sheila","sila","shila","shiela")

    private var langCode: String? = Locale.US.toString()

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setAutoInitEnabled(true)
        //OHQDeviceManager.init(applicationContext, this)
        fullyInitialize()
        FacebookSdk.setIsDebugEnabled(true)
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
        setAutoLogAppEventsEnabled(true)
        AppEventsLogger.newLogger(this).logEvent("started")
        // Get user consent
        val target: Uri? = getIntent().getData()
        Log.e("deeplink", "onCreate: " + target)
        if (target != null) {

        } else {
            // activity was created in a normal fashion
        }
        AppLinkData.fetchDeferredAppLinkData(this) { it ->
            Log.e("deeplinks", "onCreate: " + it?.appLinkData)
        }
        //registerReceiver(smsBroadcastReceiver,
        //IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))

//        builder = AlertDialog.Builder(context)
//        builder.setCancelable(true)
        dialog = Dialog(this)
        countDownTimerDialog = Dialog(this)
        customLayout = layoutInflater.inflate(R.layout.progess_dialog, null)
        countDownTimerLayout = layoutInflater.inflate(R.layout.listen_loading, null)
        displayText = customLayout.findViewById(R.id.displayTxt)
        countDownTimer = countDownTimerLayout.findViewById(R.id.countDownTimer)
        sendBtn = customLayout.findViewById(R.id.send)
        edit_view = customLayout.findViewById(R.id.edit_view)
        errorTxt = customLayout.findViewById(R.id.errorTxt)
        spin_kit = customLayout.findViewById(R.id.spin_kit)
        tryMe = customLayout.findViewById(R.id.tryMe)
        listeningLayout = customLayout.findViewById(R.id.listeningLayout)
        tryAgain = customLayout.findViewById(R.id.tryAgain)
        close = customLayout.findViewById(R.id.close)
        micOn = customLayout.findViewById(R.id.micOn)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setContentView(customLayout)
        dialog.setCancelable(false)
        countDownTimerDialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        countDownTimerDialog.setContentView(countDownTimerLayout)
        countDownTimerDialog.setCancelable(false)
        dialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        countDownTimerDialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        countDownTimerDialog.window?.setDimAmount(0.0f)
        displayText.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                handler.removeCallbacks(runnable)
            }

            override fun afterTextChanged(p0: Editable?) {
            }
        })

        close.setOnClickListener {
            try {
                speechRecognizer?.stopListening()

                //speechRecognizer?.destroy()
                if (dialog.isShowing) {
                    try {
                        _result.let {
                            _result?.error("", "", "")
                        }
                        _result = null
                    } catch (e: Exception) {
                        print(e.printStackTrace())
                    }
                    finalWords = ""
                    dialog.dismiss()
                    spin_kit.visibility = View.VISIBLE
                }
            } catch (e: Exception) {
                Log.d("Catch", "" + e.toString())
            }
        }
        //builder.show()
        sendBtn.setOnClickListener {

            if (displayText.text.toString().trim() == "") {
                displayText.clearFocus()
                val toast = Toast.makeText(
                    applicationContext,
                    "Please enter a valid input",
                    Toast.LENGTH_LONG
                )
                toast.setGravity(Gravity.CENTER, 0, 0)
                toast.show()
            } else {
                speechRecognizer?.stopListening()

                //speechRecognizer?.destroy()
                _result?.success(displayText.text.toString())
                _result = null
                finalWords = ""
                dialog.dismiss()
                spin_kit.visibility = View.VISIBLE
                displayText?.setText("")

            }
        }

        /*if (specifiedUserControl) {
                mOption[OHQSessionOptionKey.RegisterNewUserKey] = true
                mOption[OHQSessionOptionKey.ConsentCodeKey] =
                    CONSENT_CODE_OHQ
               *//* if (null != userIndex) {
                        mOption[OHQSessionOptionKey.UserIndexKey] =
                            jp.co.ohq.blesampleomron.view.fragment.RegistrationOptionFragment.Arg.UserIndex.name
                    }
                    if (null != userData) {
                        mOption[OHQSessionOptionKey.UserDataKey] = userData
                    }*//*
                    mOption[OHQSessionOptionKey.DatabaseChangeIncrementValueKey] = 0.toLong()
                    mOption[OHQSessionOptionKey.UserDataUpdateFlagKey] = true
                }
                *//*if (Protocol.OmronExtension === protocol) {
                    mOption[OHQSessionOptionKey.AllowAccessToOmronExtendedMeasurementRecordsKey] = true
                    mOption[OHQSessionOptionKey.AllowControlOfReadingPositionToMeasurementRecordsKey] = true
                }*/

        //mSessionController = SessionController(this, null)

        stopCriticalAlertServices()


    }




    var gCallbackFat: com.gsh.weightscale.api.GoldenBLEDeviceManagerCallback =
        object : com.gsh.weightscale.api.GoldenBLEDeviceManagerCallback {
            override fun onSupootBluetooth(p0: Boolean) {

            }

            override fun onBluetoothAvailable(p0: Boolean) {

            }

            override fun onDiscoverDevice(p0: BluetoothDevice?) {
                runOnUiThread {
//                Toast.makeText(applicationContext, "Weight: "+p0?.name.toString(), Toast.LENGTH_SHORT).show()
                }
                MainThreadEventSink(BLEEventChannel).success("macid|" + p0!!.address)
                MainThreadEventSink(BLEEventChannel).success("manufacturer|WOWGo")
                MainThreadEventSink(BLEEventChannel).success("bleDeviceType|weight" )
                stopExecutingMethods()

            }

            override fun onConnectStatusChange(
                p0: BluetoothDevice?,
                p1: BluetoothStatus?,
                p2: Int
            ) {
                runOnUiThread {
//                Toast.makeText(applicationContext, "Weight: "+p1?.toString(), Toast.LENGTH_SHORT).show()
                    if (ActivityCompat.checkSelfPermission(
                            applicationContext,
                            Manifest.permission.BLUETOOTH_CONNECT
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        // TODO: Consider calling
                        //    ActivityCompat#requestPermissions
                        // here to request the missing permissions, and then overriding
                        //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                        //                                          int[] grantResults)
                        // to handle the case where the user grants the permission. See the documentation
                        // for ActivityCompat#requestPermissions for more details.
                        return@runOnUiThread
                    }
                }
                bleName = p0?.name
                var bleMacId: String
                bleMacId = p0?.address.toString()
                var bleDeviceType: String
                bleDeviceType = "weight"
                if (p1 == BluetoothStatus.BLE_STATUS_CONNECTED) {
                    //if(p0?.address!=null ) {
                    if (::BLEEventChannel.isInitialized) {
                        /*MainThreadEventSink(BLEEventChannel).success("macid|" + bleMacId)
                        MainThreadEventSink(BLEEventChannel).success("manufacturer|WOWGo")
                        MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + bleDeviceType)*/
                        MainThreadEventSink(BLEEventChannel).success("connected|" + bleName + " connected successfully!!!")
                        stopExecutingMethods()

//                                BLEEventChannel.success("macid|" + bleMacId)
                    }
//                    }
                    sendPost("Connected", DEVICE_WT, 0, 0, 0)
                } else if (p1 == BluetoothStatus.BLE_ERROR){
                    stopExecutingMethods()

                    if (::BLEEventChannel.isInitialized) {
                        MainThreadEventSink(BLEEventChannel).success("connectionfailed| connectionfailed")
//                            BLEEventChannel.success("connectionfailed| connection failed")
                    }
                }else if (p1 == BluetoothStatus.BLE_STATUS_DISCONNECTED){
                    stopExecutingMethods()

                    if (::BLEEventChannel.isInitialized) {
                        MainThreadEventSink(BLEEventChannel).success("connectionfailed| connectionfailed")
//                            BLEEventChannel.success("connectionfailed| connection failed")
                    }
                }



            }

            override fun onReceiveMeasurementData(p0: BluetoothDevice?, p1: WeightData?) {
                try {
                    stopExecutingMethods()

                    runOnUiThread {
                        if (p1 != null) {
//                        Toast.makeText(applicationContext, "Weight: "+p1.weight.toString(), Toast.LENGTH_SHORT).show()
                            uploaded = 1
                            sendPost("Measurement", DEVICE_WT, 0, 0, 0, weight = p1.weight)
                            if (::BLEEventChannel.isInitialized) {
                                MainThreadEventSink(BLEEventChannel).success("measurement|" + postBleData)
//                                BLEEventChannel.success("measurement|" + postBleData)
                            }
                        }
                    }
                } catch (e: Exception) {
//                Toast.makeText(
//                    applicationContext,
//                    "try catch in onReceiveMeasurementData weight",
//                    Toast.LENGTH_SHORT
//                ).show()
                }

            }

            override fun showLogMessage(p0: String?) {

            }

        }

    var gCallBackBP: com.gsh.bloodpressure.api.GoldenBLEDeviceManagerCallback =
        object : com.gsh.bloodpressure.api.GoldenBLEDeviceManagerCallback {
            override fun onDiscoverDevice(p0: BluetoothDevice?) {
                runOnUiThread {
//                Toast.makeText(applicationContext, "BP: "+p0?.name.toString(), Toast.LENGTH_SHORT).show()
                }
                MainThreadEventSink(BLEEventChannel).success("macid|" + p0!!.address)
                MainThreadEventSink(BLEEventChannel).success("manufacturer|WOWGo")
                MainThreadEventSink(BLEEventChannel).success("bleDeviceType|BP")
                stopExecutingMethods()

            }

            override fun onConnectStatusChange(
                p0: BluetoothDevice?,
                p1: BluetoothStatus?,
                p2: Int
            ) {
                //stopExecutingMethods()

                runOnUiThread {
//                Toast.makeText(applicationContext, "BP: "+p1.toString(), Toast.LENGTH_SHORT).show()

                    if (ActivityCompat.checkSelfPermission(
                            applicationContext,
                            Manifest.permission.BLUETOOTH_CONNECT
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        // TODO: Consider calling
                        //    ActivityCompat#requestPermissions
                        // here to request the missing permissions, and then overriding
                        //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                        //                                          int[] grantResults)
                        // to handle the case where the user grants the permission. See the documentation
                        // for ActivityCompat#requestPermissions for more details.
                        return@runOnUiThread
                    }
                }
                bleName = p0?.name
                var bleMacId: String
                bleMacId = p0?.address.toString()
                var bleDeviceType: String
                bleDeviceType = "BP"
                if(p1==BluetoothStatus.BLE_STATUS_CONNECTED){
                    if(p0?.address!=null ) {
                        if (::BLEEventChannel.isInitialized) {
                            runOnUiThread {
                                Log.e("qurhealth","wowgostatus: macid")
                            }
                            /* MainThreadEventSink(BLEEventChannel).success("macid|" + bleMacId)
                             MainThreadEventSink(BLEEventChannel).success("manufacturer|WOWGo")
                             MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + bleDeviceType)*/
                            MainThreadEventSink(BLEEventChannel).success("connected|" + bleName + " connected successfully!!!")
                            stopExecutingMethods()
//                            BLEEventChannel.success("macid|" + bleMacId)
                        }
                    }
                    sendPost("Connected", DEVICE_BP, 0, 0, 0)

                }else if (p1 == BluetoothStatus.BLE_ERROR){
                    stopExecutingMethods()

                    if (::BLEEventChannel.isInitialized) {
                        MainThreadEventSink(BLEEventChannel).success("connectionfailed| connection failed")
//                            BLEEventChannel.success("connectionfailed| connection failed")
                    }
                }
                else if (p1 == BluetoothStatus.BLE_STATUS_DISCONNECTED){
                    stopExecutingMethods()

                    if (::BLEEventChannel.isInitialized) {
                        MainThreadEventSink(BLEEventChannel).success("connectionfailed| connection failed")
//                            BLEEventChannel.success("connectionfailed| connection failed")
                    }
                }
            }

            override fun onReceiveMeasurementData(
                p0: BluetoothDevice?,
                dia: Int,
                sis: Int,
                pulse: Int
            ) {
                try {
                    stopExecutingMethods()

                    runOnUiThread {
                        uploaded = 1
                        runOnUiThread {
                            Log.e("qurhealth","wowgostatus: measurementdata")
                        }
                        sendPost("Measurement", DEVICE_BP, sis, dia, pulse)
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("measurement|" + postBleData)
//                            BLEEventChannel.success("measurement|" + postBleData)
                        }
//                    Toast.makeText(applicationContext, "BP: dia: "+dia.toString()+" sis: "+sis.toString()+" pulse: "+pulse.toString(), Toast.LENGTH_SHORT).show()

                    }
                } catch (e: Exception) {
//                Toast.makeText(
//                    applicationContext,
//                    "try catch in onReceiveMeasurementData bp",
//                    Toast.LENGTH_SHORT
//                ).show()
                }


            }

            override fun showLogMessage(p0: String?) {

            }
        }
    var WOWGoDataUpload = 0

    var gCallback: GoldenBLEDeviceManagerCallback = object : GoldenBLEDeviceManagerCallback {

        override fun onDiscoverDevice(p0: BluetoothDevice?) {
            runOnUiThread {
                Log.e("device", "onConnectStatusChange: "+"SPO2 discoverDevice: "+p0.toString() )
//                Toast.makeText(applicationContext, "SPO2: "+p0?.name.toString(), Toast.LENGTH_SHORT).show()
            }

//            if (p0?.name.equals("My Oximeter",true))
//            {
//                gManager?.scanLeDevice(true)
//            }

            MainThreadEventSink(BLEEventChannel).success("macid|" + p0!!.address)
            MainThreadEventSink(BLEEventChannel).success("manufacturer|WOWGo")
            MainThreadEventSink(BLEEventChannel).success("bleDeviceType|SPO2" )
            stopExecutingMethods();

        }

        override fun onConnectStatusChange(p0: BluetoothDevice?, p1: BluetoothStatus?, p2: Int) {
            runOnUiThread {
                Log.e("device", "onConnectStatusChange: "+"SPO2: "+p1.toString() )
                //stopExecutingMethods();

//                Toast.makeText(applicationContext, "SPO2: "+p1.toString(), Toast.LENGTH_SHORT).show()
                if (ActivityCompat.checkSelfPermission(
                        applicationContext,
                        Manifest.permission.BLUETOOTH_CONNECT
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    // TODO: Consider calling
                    //    ActivityCompat#requestPermissions
                    // here to request the missing permissions, and then overriding
                    //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                    //                                          int[] grantResults)
                    // to handle the case where the user grants the permission. See the documentation
                    // for ActivityCompat#requestPermissions for more details.
                    return@runOnUiThread
                }
            }
            bleName = p0?.name
            var bleMacId: String
            bleMacId = p0?.address.toString()
            var bleDeviceType: String
            bleDeviceType = "SPO2"
            if (p1 == BluetoothStatus.BLE_STATUS_CONNECTED) {

//                if(p0?.address!=null ) {
                if (::BLEEventChannel.isInitialized && measurementNotTaken) {
                    /*stopExecutingMethods();

                    MainThreadEventSink(BLEEventChannel).success("macid|" + bleMacId)
                    MainThreadEventSink(BLEEventChannel).success("manufacturer|WOWGo")
                    MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + bleDeviceType)*/
                    MainThreadEventSink(BLEEventChannel).success("connected|" + bleName + " connected successfully!!!")
                }
//                }
                sendPost("Connected", DEVICE_SPO2, 0, 0, 0)
                //stopExecutingMethods()

            } else if (p1 == BluetoothStatus.BLE_ERROR){
                stopExecutingMethods()

                if (::BLEEventChannel.isInitialized && measurementNotTaken) {
                    runOnUiThread {
                        Log.e("qurhealth","wowgostatus: connectionfailed")
                    }

                    MainThreadEventSink(BLEEventChannel).success("connectionfailed| connectionfailed")
//                        BLEEventChannel.success("connectionfailed| connection failed")
                }
            }else if (p1 == BluetoothStatus.BLE_STATUS_DISCONNECTED){
                stopExecutingMethods()

                if (::BLEEventChannel.isInitialized && measurementNotTaken) {
                    runOnUiThread {
                        Log.e("qurhealth","wowgostatus: connectionfailed")
                    }

                    MainThreadEventSink(BLEEventChannel).success("connectionfailed| connectionfailed")
//                        BLEEventChannel.success("connectionfailed| connection failed")
                }
            }




        }

        override fun onReceiveSPO2MeasurementData(p0: BluetoothDevice?, spo2: Int, pulseRate: Int) {
            try {
                stopExecutingMethods()
                runOnUiThread {
                    Log.e("qurhealth","wowgostatus: measurement in outside")
                }
                runOnUiThread {
                    if (spo2 < 101 && pulseRate != 127 && pulseRate != 255 && WOWGoDataUpload == 0) {
                        //gManager?.scanLeDevice(false)
                        //gManager?.disconnect()

                        WOWGoDataUpload = 1
                        sendPost(
                            "Measurement",
                            DEVICE_SPO2,
                            spo2,
                            pulseRate,
                            0
                        )
                        if (::BLEEventChannel.isInitialized && measurementNotTaken) {
                            runOnUiThread {
                                Log.e("qurhealth","wowgostatus: measurement")
                            }

                            MainThreadEventSink(BLEEventChannel).success("measurement|" + postBleData)
//                            BLEEventChannel.success("measurement|" + postBleData)
                            measurementNotTaken=false;
                        }
                    }
//                    Toast.makeText(applicationContext, "SPO2: spo2: "+spo2.toString()+" pulse: "+pulseRate.toString(), Toast.LENGTH_SHORT).show()
                }

            } catch (e: Exception) {
//                Toast.makeText(applicationContext, "try catch in onReceiveSPO2MeasurementData", Toast.LENGTH_SHORT).show()
            }

        }

        override fun onReceiveSPO2PlethWave(p0: Int) {

        }

        override fun showLogMessage(p0: String?) {
//            Log.e("bleman: ",p0.toString())
        }
    }


    /* override fun onStop() {
         super.onStop()
         unregisterReceiver(smsBroadcastReceiver)
     }*/

    fun GetDeviceDataJson(
        Status: String,
        deviceType: Int,
        v1: Int,
        v2: Int,
        v3: Int,
        weight: Double
    ): String? {
        var DataToPost = ""
        val DevSeq = "03" // Kiran
        //String DevSeq="02";//Kunduru
        try {
            if (deviceType == DEVICE_SPO2) // SPO2
            {
                DataToPost = "{ \"Status\" : \"$Status\" , "
                DataToPost += " \"hubId\" : \"HB:AD:00:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceId\" : \"DV:WG:SP:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceType\" : \"SPO2\" , \"Data\" : {"
                DataToPost += " \"SPO2\" : \""
                DataToPost += v1
                DataToPost += "\" ,"
                DataToPost += " \"Pulse\" : \""
                DataToPost += v2
                DataToPost += "\" "
                DataToPost += " }}"
            } else if (deviceType == DEVICE_TEMP) // TEMP
            {
                DataToPost = "{ \"Status\" : \"$Status\" , "
                DataToPost += " \"hubId\" : \"HB:AD:00:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceId\" : \"DV:WG:TE:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceType\" : \"TEMP\" , \"unit\" : \"centigrade\" , \"Data\" : {"
                DataToPost += " \"Temperature\" : \""
                DataToPost += v1
                DataToPost += "\" "
                DataToPost += " }}"
            } else if (deviceType == DEVICE_WT) // WEIGHT
            {
                DataToPost = "{ \"Status\" : \"$Status\" , "
                DataToPost += " \"hubId\" : \"HB:AD:00:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceId\" : \"DV:WG:WT:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceType\" : \"WEIGHT\" , \"unit\" : \"lbs\" , \"Data\" : {"
                DataToPost += " \"Weight\" : \""
                DataToPost += weight.toString()
                DataToPost += "\" "
                DataToPost += " }}"
            } else if (deviceType == DEVICE_BP) // BP2
            {
                DataToPost = "{ \"Status\" : \"$Status\" , "
                DataToPost += " \"hubId\" : \"HB:AD:00:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceId\" : \"DV:WG:BP:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceType\" : \"BP\" , \"Data\" : {"
                DataToPost += " \"Systolic\" : \""
                DataToPost += v1
                DataToPost += "\" ,"
                DataToPost += " \"Diastolic\" : \""
                DataToPost += v2
                DataToPost += "\" ,"
                DataToPost += " \"Pulse\" : \""
                DataToPost += v3
                DataToPost += "\" "
                DataToPost += " }}"
            } else if (deviceType == DEVICE_BGL) // BGL
            {
                DataToPost = "{ \"Status\" : \"$Status\" , "
                DataToPost += " \"hubId\" : \"HB:AD:00:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceId\" : \"DV:WG:BG:00:00:$DevSeq\" ,"
                DataToPost += " \"deviceType\" : \"BGL\" , \"Data\" : {"
                DataToPost += " \"BGL\" : \""
                DataToPost += v1
                DataToPost += "\" "
                DataToPost += " }}"
            } else  // None
            {
                DataToPost = "{ \"Status\" : \"$Status\" , "
                DataToPost += " \"hubId\" : \"HB:AD:00:00:00:$DevSeq\" ,"
                DataToPost += " \"Data\" : {"
                DataToPost += " }}"
            }
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
        return DataToPost
    }

    private fun checkBluetoothTurnedOn(){
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (!bluetoothAdapter.isEnabled) {
            if (::BLEEventChannel.isInitialized) {
                BLEEventChannel.success("enablebluetooth|Please turn on your Bluetooth and try again")
            }
            //bluetoothFlutterResult.success("enablebluetooth|Please turn on your Bluetooth and try again")
            //Toast.makeText(this@MainActivity, "Please turn on Bluetooth first", Toast.LENGTH_LONG).show()
            return
        }
    }

    private fun checkPermissionStartScan(isFromBp: Boolean) {
        try {
            val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (!bluetoothAdapter.isEnabled) {
                if (::BLEEventChannel.isInitialized) {
                    BLEEventChannel.success("enablebluetooth|Please turn on your Bluetooth and try again")
                }
                //bluetoothFlutterResult.success("enablebluetooth|Please turn on your Bluetooth and try again")
                //Toast.makeText(this@MainActivity, "Please turn on Bluetooth first", Toast.LENGTH_LONG).show()
                return
            }
            Log.d("check BLE Permissions", "checkPermissionsStarcScan")
            val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
            val permissionDeniedList: MutableList<String> = ArrayList()
            for (permission in permissions) {
                val permissionCheck = ContextCompat.checkSelfPermission(this, permission)
                if (permissionCheck == PackageManager.PERMISSION_GRANTED) {
                    onPermissionGranted(permission, isFromBp)
                } else {
                    if (::BLEEventChannel.isInitialized) {
                        BLEEventChannel.success("permissiondenied|no permission granted")
                    }
                    //  bluetoothFlutterResult.success("permissiondenied|no permission granted")
                    permissionDeniedList.add(permission)
                }
            }
            if (!permissionDeniedList.isEmpty()) {
                val deniedPermissions = permissionDeniedList.toTypedArray()
                ActivityCompat.requestPermissions(
                    this,
                    deniedPermissions,
                    REQUEST_CODE_PERMISSION_LOCATION
                )
            }
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
    }

    private fun onPermissionGranted(permission: String, isFromBp: Boolean) {
        try {
            when (permission) {
                Manifest.permission.ACCESS_FINE_LOCATION -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !checkGPSIsOpen()) {
                    AlertDialog.Builder(this@MainActivity)
                        .setTitle("Error")
                        .setMessage("Allow Location ?")
                        .setNegativeButton("Cancel",
                            { dialog, which -> finish() })
                        .setPositiveButton("setting",
                            { dialog, which ->
                                val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                                startActivityForResult(intent, REQUEST_CODE_OPEN_GPS)
                            })
                        .setCancelable(false)
                        .show()
                } else {
                    //setScanRule();
                    if (isFromBp) {
                        //BP flow
                        startBpScan()
                    } else {
                        // pulse reading flow
                        autoRepeatScan = 1
                        startScanTimer()
                    }

                }
            }
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

    }

    private fun checkGPSIsOpen(): Boolean {
        val locationManager = this.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if (locationManager == null) {
            Log.d("GTAG", "LOCATION_SERVICE Missing in the device.")
            return false
        }

        Log.d("GTAG", "providers Available.")

        val providerList = locationManager.allProviders
        for (i in providerList.indices) {
            Log.d("GTAG", providerList[i])
        }

        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
                locationManager.isProviderEnabled(LocationManager.PASSIVE_PROVIDER) ||
                locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }


    private fun checkNotificationPermission() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.POST_NOTIFICATIONS
                    ) != PackageManager.PERMISSION_GRANTED
                ) {

                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                        REQUEST_CODE_PERMISSION_NOTIFICATION
                    )
                }
            }
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
    }


    var uploaded = 0
    fun sendPost(Status: String, deviceType: Int, v1: Int, v2: Int, v3: Int, weight: Double = 0.0) {
        try {
            postBleData = GetDeviceDataJson(Status, deviceType, v1, v2, v3, weight)
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
    }

    fun GetBitMaskPermissonStr(data: Int): String? {
        var ret = ""
        try {
            if (data and BluetoothGattCharacteristic.PERMISSION_READ != 0) ret += " PERMISSION_READ "
            if (data and BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED != 0) ret += " PERMISSION_READ_ENCRYPTED  "
            if (data and BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED_MITM != 0) ret += "  PERMISSION_READ_ENCRYPTED_MITM  "
            if (data and BluetoothGattCharacteristic.PERMISSION_WRITE != 0) ret += "  PERMISSION_WRITE  "
            if (data and BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED != 0) ret += "  PERMISSION_WRITE_ENCRYPTED  "
            if (data and BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED_MITM != 0) ret += "  PERMISSION_WRITE_ENCRYPTED_MITM "
            if (data and BluetoothGattCharacteristic.PERMISSION_WRITE_SIGNED != 0) ret += "  PERMISSION_WRITE_SIGNED  "
            if (data and BluetoothGattCharacteristic.PERMISSION_WRITE_SIGNED_MITM != 0) ret += "  PERMISSION_WRITE_SIGNED_MITM  "
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
        return ret
    }

    fun GetBitMaskPropertyStr(data: Int): String? {
        var ret = ""
        try {
            if (data and BluetoothGattCharacteristic.PROPERTY_BROADCAST != 0) ret += "  PROPERTY_BROADCAST  "
            if (data and BluetoothGattCharacteristic.PROPERTY_EXTENDED_PROPS != 0) ret += "  PROPERTY_EXTENDED_PROPS  "
            if (data and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) ret += "  PROPERTY_INDICATE  "
            if (data and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) ret += " PROPERTY_NOTIFY  "
            if (data and BluetoothGattCharacteristic.PROPERTY_READ != 0) ret += "  PROPERTY_READ  "
            if (data and BluetoothGattCharacteristic.PROPERTY_SIGNED_WRITE != 0) ret += "  PROPERTY_SIGNED_WRITE  "
            if (data and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) ret += "  PROPERTY_WRITE  "
            if (data and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) ret += "  PROPERTY_WRITE_NO_RESPONSE  "
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
        return ret
    }


    fun DumpServicesChars(services: List<BluetoothGattService>) {
        try {
            for (i in services.indices) {
                val bluetoothGattService = services[i]
                val uuid_service = bluetoothGattService.uuid.toString()
                Log.e("DumpServicesChars", "Serv: $uuid_service")
                val chars = BleManager.getInstance().getBluetoothGattCharacteristics(services[i])
                for (j in chars.indices) {
                    val c = chars[j]
                    val uuid_chars = c.uuid.toString()
                    var st: String? = "       Charac: "
                    st += uuid_chars
                    st += GetBitMaskPermissonStr(c.permissions)
                    st += GetBitMaskPropertyStr(c.properties)
                    Log.e("DumpServicesChars", st!!)
                }
            }
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

    }

    fun BytesToStr(data: ByteArray): String {
        var st = ""
        try {
            for (i in data.indices) {
                st += String.format("%02x ", data[i])
            }
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

        return st
    }


    @RequiresApi(Build.VERSION_CODES.O)
    fun getUB(b: Byte?): Int {
        return java.lang.Byte.toUnsignedInt(b!!)
    }

    private fun startScanTimer() {
        try {
            autoRepeatScan = 1
            scanningBleTimer = Timer()
            scanningBleTimer.schedule(object : TimerTask() {
                override fun run() {
                    startScan()
                }
            }, 1000)
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }
    }

    private fun stopScan() {
        try {
            autoRepeatScan = 0
            scanningBleTimer?.cancel()
            Handler().postDelayed({
                if (BleManager.getInstance() != null) {
                    runOnUiThread {
                        try {
                            BleManager.getInstance().cancelScan()

                        }catch (ex: Exception){

                        }
                    }
                }
            }, 1000)
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

    }

    private val onSyncingListener: OnSyncingListener = object : OnSyncingListener() {

        override fun onBloodPressureDataUpdate(p0: String?, p1: LSBloodPressure?) {
            super.onBloodPressureDataUpdate(p0, p1)
            runOnUiThread {
//                resultStream.success("\n\nonBloodPressureDataUpdate: "+p1.toString());
            }
            Log.e("bluetoothnew", "onBloodPressureDataUpdate: " )

        }

        override fun onScaleWeightDataUpdate(p0: String?, p1: LSScaleWeight?) {
            super.onScaleWeightDataUpdate(p0, p1)

            if(p1?.remainCount==0 && (p1!!.utc!!<currentConnectedTime)){
                runOnUiThread {
                    Handler().postDelayed({
                        p1?.weight?.let {
                            sendPost(
                                "Measurement",
                                DEVICE_WEIGHT,
                                0,
                                0,
                                0,
                                weight=it
                            )
                        }
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("measurement|" + postBleData)
                        }

                    }, 500)

//                    LSBluetoothManager.getInstance().stopDeviceSync()
//                    LSBluetoothManager.getInstance().stopDiscovery()
//                    LSBluetoothManager.getInstance().stopSearch()
                }

            }


        }

        override fun onStateChanged(p0: String?, p1: LSConnectState?) {
            super.onStateChanged(p0, p1)

            var status=p1?.status
            if(status==null){
                status=0
            }
            if(status!=null&&status==1&&measurementNotTaken){
                if (::BLEEventChannel.isInitialized) {
                    //MainThreadEventSink(BLEEventChannel).success("scanstarted|connection started")
                }
            }else if(status!=null&&status==2&&measurementNotTaken){
                if (::BLEEventChannel.isInitialized) {
                    MainThreadEventSink(BLEEventChannel).success("macid|" + macIdLsDevice)
                    MainThreadEventSink(BLEEventChannel).success("manufacturer|Transteck")
                }
                Log.e("devicesList", "devicesList: "+devicesList.size )

                devicesList.forEachIndexed { index, any ->
                    Log.e("devicesList", "devicesList: "+(any as HashMap<String,String>).get("deviceType") )

                    if((any as HashMap<String,String>).get("deviceType").equals("Weight",ignoreCase = true) && (lsDeviceInfo.deviceType.equals("02")|| lsDeviceInfo.deviceType.equals("01"))) {
                        sendPost("Connected", DEVICE_WEIGHT, 0, 0, 0,weight=0.0)
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + "weight")
                        }
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("connected|" + "weight" + " connected successfully!!!")
                        }
                    }else if((any as HashMap<String,String>).get("deviceType").equals("BGL",ignoreCase = true)&& lsDeviceInfo.deviceType.equals("06")) {
                        sendPost("Connected", DEVICE_BGL, 0, 0, 0)
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + "BGL")
                        }
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("connected|" + "bgl" + " connected successfully!!!")
                        }
                    }
                }
                Log.e("devicesList", "lsDeviceInfo.deviceType: "+lsDeviceInfo.deviceType )

                if(scanType.equals("scanAll",ignoreCase = true)){
                    if(lsDeviceInfo.deviceType.equals("06")) {
                        sendPost("Connected", DEVICE_BGL, 0, 0, 0)
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + "BGL")
//                            BLEEventChannel.success("bleDeviceType|" + bleDeviceType)
                        }
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("connected|" + "bgl" + " connected successfully!!!")
//                                BLEEventChannel.success("connected|" + bleName + " connected successfully!!!")
                        }
                    }else if(lsDeviceInfo.deviceType.equals("02")|| lsDeviceInfo.deviceType.equals("01")){
                        sendPost("Connected", DEVICE_WEIGHT, 0, 0, 0,weight=0.0)
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("bleDeviceType|" + "weight")
//                            BLEEventChannel.success("bleDeviceType|" + bleDeviceType)
                        }
                        if (::BLEEventChannel.isInitialized) {
                            MainThreadEventSink(BLEEventChannel).success("connected|" + "weight" + " connected successfully!!!")
                            MainThreadEventSink(BLEEventChannel).success("update|" + "Your device is ready")

//                                BLEEventChannel.success("connected|" + bleName + " connected successfully!!!")
                        }
                    }
                }

                Log.e("bluetoothnew", "bleNameInLSdeviceinfo: "+lsDeviceInfo.deviceName )

            }else{
//                if (::BLEEventChannel.isInitialized) {
//                    MainThreadEventSink(BLEEventChannel).success("scanstarted|connection started")
////                            BLEEventChannel.success("scanstarted|connection started")
//                }
            }
            Log.e("bluetoothnew", "onStateChanged: "+p1?.name+" "+p1?.status )
        }

        override fun onDeviceInformationUpdate(p0: String?, p1: LSDeviceInfo?) {
            super.onDeviceInformationUpdate(p0, p1)
            runOnUiThread {
//                resultStream.success("\n\nonDeviceInformationUpdate: "+p1.toString());

            }

            if (p1 != null) {
                lsDeviceInfo.setFirmwareVersion(p1?.getFirmwareVersion())
                lsDeviceInfo.setHardwareVersion(p1?.getHardwareVersion());
                lsDeviceInfo.setModelNumber(p1?.getModelNumber());
                if(p1?.getPassword()!=null){
                    lsDeviceInfo.setPassword(p1?.getPassword());
                }
            };

            Log.e("bluetoothnew", "onDeviceInformationUpdate: "+p1?.deviceName+" "+p1?.deviceType )
        }



        override fun onNotificationDataUpdate(p0: String?, p1: IDeviceData?) {
            super.onNotificationDataUpdate(p0, p1)
            runOnUiThread {
//                resultStream.success("\n\nonNotificationDataUpdate: "+p1.toString());

            }

            if (p1 is LSScaleState) {
                handleScaleState(p0!!, (p1 as LSScaleState?)!!)
            }

            if(lsDeviceInfo.deviceType.equals("06")) {


                //               if (p1.toString().contains("InsertStrip")) {
                //                   if (::BLEEventChannel.isInitialized) {
                //                       MainThreadEventSink(BLEEventChannel).success("update|" + "Strip inserted")
                //                   }
                //               }
                //               if (p1.toString().contains("Collecting")) {
                //                   if (::BLEEventChannel.isInitialized) {
                //                       MainThreadEventSink(BLEEventChannel).success("update|" + "Insert the blood sample on the strip.")
                //                   }
                //               } else
                if (p1.toString().contains("Collected")) {
                    if (::BLEEventChannel.isInitialized) {
                        MainThreadEventSink(BLEEventChannel).success("update|" + "Blood sample collected successfully.")
                    }
                } else if (p1.toString().contains("Result")) {
                    val result = p1.toString().substringAfter("value=").substringBefore(',')
                    sendPost(
                        "Measurement",
                        DEVICE_BGL,
                        result.toFloat().toInt(),
                        0,
                        0
                    )
                    if (::BLEEventChannel.isInitialized) {
                        MainThreadEventSink(BLEEventChannel).success("measurement|" + postBleData)
                    }
//                    LSBluetoothManager.getInstance().stopDeviceSync()
//                    LSBluetoothManager.getInstance().stopDiscovery()
//                    LSBluetoothManager.getInstance().stopSearch()
                }

                if (p1.toString().contains("PowerOff")) {
                    if (::BLEEventChannel.isInitialized) {

                        MainThreadEventSink(BLEEventChannel).success("disconnected|Disconnected")

                    }
                    LSBluetoothManager.getInstance().stopDeviceSync()
                    LSBluetoothManager.getInstance().stopDiscovery()
                    LSBluetoothManager.getInstance().stopSearch()
                }
                if(p1.toString().contains("Disconnect")){
                    //connectToBle()
                    MainThreadEventSink(BLEEventChannel).success("disconnected|Disconnected")
                }
            }



        }

        override fun onActivityTrackerDataUpdate(p0: String?, p1: Int, p2: ATDeviceData?) {
            super.onActivityTrackerDataUpdate(p0, p1, p2)
            runOnUiThread {
//                resultStream.success("\n\nonActivityTrackerDataUpdate: "+p1.toString());

            }

        }

        override fun onBloodGlucoseDataUpdate(p0: String?, p1: BGDataSummary?) {
            super.onBloodGlucoseDataUpdate(p0, p1)
            runOnUiThread {

//                resultStream.success("\n\nonBloodGlucoseDataUpdate: "+p1.toString());
            }
//            if(p1?.items!=null&&p1?.items.size>0){
//                var length=p1?.items.size-1
//                if( !p1?.items!![length].isHistoricalData){
//                    sendPost(
//                        "Measurement",
//                        DEVICE_BGL,
//                        p1?.items!![length].value.toInt(),
//                        0,
//                        0
//                    )
//                    if (::BLEEventChannel.isInitialized) {
//                        MainThreadEventSink(BLEEventChannel).success("measurement|" + postBleData)
////                            BLEEventChannel.success("measurement|" + postBleData)
//                    }
//                }
//
//            }


            Log.e("bluetoothnew", "onBloodGlucoseDataUpdate: " )

        }

    }

    private fun connectToBle(){
        LSBluetoothManager.getInstance().stopSearch()
        LSBluetoothManager.getInstance().addDevice(lsDeviceInfo)
        LSBluetoothManager.getInstance().startDeviceSync(onSyncingListener)
    }

    private fun handleScaleState(devMac: String, obj: LSScaleState) {
        if (obj.isReset) {
            LSBluetoothManager.getInstance().deleteDevice(devMac)
            LSBluetoothManager.getInstance().stopDeviceSync()
            connectToBle()
        }
    }

    private fun checkSupportRegisterAndConnect(){
        LSBluetoothManager.getInstance().stopSearch()
        LSBluetoothManager.getInstance().stopDeviceSync()
        LSBluetoothManager.getInstance().setDevices(null)
        if(isSupportRegister(lsDeviceInfo)){
            //set scale user info
            val userInfo = ATUserInfo()
            userInfo.age = 24
            userInfo.isAthlete = false
            userInfo.height = 1.73f
            userInfo.weight = 74f
            userInfo.userGender = LSUserGender.Male
            lsDeviceInfo.setUserInfo(userInfo)
            LSBluetoothManager.getInstance().pairDevice(lsDeviceInfo, mPairCallback)
        }else{
            connectDevice()
        }
    }
    private val mPairCallback: OnPairingListener = object : OnPairingListener() {
        override fun onStateChanged(lsDevice: LSDeviceInfo, status: Int) {
            if (status == ATPairResultsCode.PAIR_SUCCESSFULLY) {
//                runOnUiThread {
//                    resultStream.success("\n\nPaired Successfullly: ");
//                }
                Toast.makeText(this@MainActivity,"Paired successfully",Toast.LENGTH_SHORT)
                connectDevice()
            } else {
//                runOnUiThread {
//                    resultStream.success("\n\nPaired failed: ");
//                }
                Toast.makeText(this@MainActivity,"Connection failed",Toast.LENGTH_SHORT)
            }
        }

        override fun onMessageUpdate(macAddress: String, msg: LSDevicePairSetting) {
            if (msg.pairCmd == LSPairCommand.DeviceIdRequest) {
                //注册设备ID
                msg.obj = macAddress.replace(":", "")
                LSBluetoothManager.getInstance().pushPairSetting(macAddress, msg)
            }
        }
    }

    private fun isSupportRegister(lsDevice: LSDeviceInfo?): Boolean {
        if (lsDevice == null || lsDevice.protocolType == null) {
            return false
        }
        val state = LSProtocolType.A6.toString().equals(lsDevice.protocolType, ignoreCase = true)
        return if (state && lsDevice.registerStatus == 0x00) {
            true
        } else false
    }

    private fun connectDevice() {
        if (LSBluetoothManager.getInstance().managerStatus == LSManagerStatus.Syncing
            && LSBluetoothManager.getInstance()
                .checkConnectState(lsDeviceInfo.getMacAddress()) == LSConnectState.ConnectSuccess
        ) {
            LSBluetoothManager.getInstance().resetSyncingListener(onSyncingListener)
            return
        }
        if (LSBluetoothManager.getInstance().managerStatus == LSManagerStatus.Syncing) {
            return
        }
        createConnection()
    }

    private fun createConnection() {
        LSBluetoothManager.getInstance().stopDeviceSync()
        //clear measure device list
        LSBluetoothManager.getInstance().devices = null
        if (lsDeviceInfo.deviceName.equals("1014B", ignoreCase = true)) {
            lsDeviceInfo.isDelayDisconnect = true
        }
        //add target measurement device
        LSBluetoothManager.getInstance().addDevice(lsDeviceInfo)
        //start data syncing service
        LSBluetoothManager.getInstance().startDeviceSync(onSyncingListener)
        //update connect state
    }


    private val searchingListener: OnSearchingListener = object : OnSearchingListener() {
        override fun onSearchResults(lsDevice: LSDeviceInfo) {
            super.onSearchResults(lsDevice)
            Log.e("bluetoothsearch", "\n\nonSearchResults: "+lsDevice.deviceName+ " "+lsDevice.deviceType )
            var add=false;
            if(scanType.equals("scanAll",ignoreCase = true)){
                macIdLsDevice=lsDevice.macAddress;
                lsDeviceInfo=lsDevice
                checkSupportRegisterAndConnect()
            }else{
                val cal =Calendar.getInstance(TimeZone.getTimeZone("UTC"))
                cal.add(Calendar.MINUTE,-2)
                currentConnectedTime=cal.timeInMillis
                devicesList.forEachIndexed { index: Int, any: Any? ->
                    if((any as HashMap<String,String>).get("manufacture").equals("Transteck",ignoreCase = true)){
                        if((any as HashMap<String,String>).get("deviceType").equals("bgl",ignoreCase = true) && lsDevice.deviceType.equals("06")){
                            Log.e("bluetoothsearch", "\n\nonSearchResults: "+lsDevice.deviceName+ "connect " )
                            macIdLsDevice=lsDevice.macAddress;
                            lsDeviceInfo=lsDevice
                            checkSupportRegisterAndConnect()
                        }else if((any as HashMap<String,String>).get("deviceType").equals("weight",ignoreCase = true) && (lsDevice.deviceType.equals("01") || lsDevice.deviceType.equals("02"))){
                            Log.e("bluetoothsearch", "\n\nonSearchResults: "+lsDevice.deviceName+ "connect " )
                            macIdLsDevice=lsDevice.macAddress;
                            lsDeviceInfo=lsDevice
                            checkSupportRegisterAndConnect()
                        }
                    }
                }
            }

        }

        override fun onSystemConnectedDevice(name: String, macAddress: String) {
            super.onSystemConnectedDevice(name, macAddress)

        }

        override fun onSystemBondDevice(device: BluetoothDevice) {
            super.onSystemBondDevice(device)

        }
    }


    private fun startScan() {
        return
        try {
            BleManager.getInstance().scan(object : BleScanCallback() {
                override fun onScanStarted(success: Boolean) {
                    Log.d("startScan", "onScanStarted")
                }


                override fun onScanFinished(scanResultList: List<BleDevice?>) {
                    Log.d(
                        "startScan",
                        "onScanFinished autoRepeatScan:" + String.format("%d", autoRepeatScan)
                    )
                    Log.d("startScan", "onScanFinished scanResultList:$scanResultList")
                    if (autoRepeatScan == 1) {
                        startScanTimer()
                    }
                    //stopScan()
                }

                override fun onLeScan(bleDevice: BleDevice?) {
                    super.onLeScan(bleDevice)
                }


                override fun onScanning(bleDevice: BleDevice) {
                    if (bleDevice.name == null) return
                    val DevName: String = bleDevice.name
                    Log.d("startScan", "Found " + DevName + " " + bleDevice.mac)

                    if (DevName == "Mike") {
                        stopScan()
                        connectToSPO2(bleDevice)
                    }

                    if (DevName == "TeleBGM Gen1 BLE") {
                        stopScan()
                        deviceName="TeleBGM Gen1 BLE";
                        LSBluetoothManager.getInstance().resetSyncingListener(onSyncingListener)
                        LSBluetoothManager.getInstance().searchDevice(listOf(LSDeviceType.Unknown,LSDeviceType.ActivityTracker,LSDeviceType.KitchenScale,LSDeviceType.HeightMeter,LSDeviceType.FatScale,LSDeviceType.BloodGlucoseMeter,LSDeviceType.WeightScale,LSDeviceType.BloodPressureMeter),searchingListener)
                    }
                    if (DevName == "GBS-2012-B") {
                        stopScan()
                        deviceName="GBS-2012-B";
                        LSBluetoothManager.getInstance().resetSyncingListener(onSyncingListener)
                        LSBluetoothManager.getInstance().searchDevice(listOf(LSDeviceType.Unknown,LSDeviceType.ActivityTracker,LSDeviceType.KitchenScale,LSDeviceType.HeightMeter,LSDeviceType.FatScale,LSDeviceType.BloodGlucoseMeter,LSDeviceType.WeightScale,LSDeviceType.BloodPressureMeter),searchingListener)
                    }
// BP DEVICE SCANNING
                    if (DevName.lowercase(Locale.getDefault()).contains("blesmart")) {
                        stopScan()
                        getBpAddress(bleDevice.mac);
                    }

                    if (DevName == "GSH601") {
                        stopScan()
                        Handler().postDelayed({
                            selectedBle = "spo2"
                            gManager = GoldenBLEDeviceManager(applicationContext, gCallback)
                            gManager?.scanLeDevice(true)
                            WOWGoDataUpload = 0
                        }, 1500)

                    }
                    if (DevName == "GSH862" || DevName == "GSH_862B") {
                        stopScan()
                        Handler().postDelayed({
                            selectedBle = "bp"
                            gManagerBP = com.gsh.bloodpressure.api.GoldenBLEDeviceManager(
                                applicationContext,
                                gCallBackBP
                            )
                            gManagerBP?.scanLeDevice(true)
                        }, 1500)

                    }
                    if (DevName == "GSH-202" || DevName == "GSH-231" || DevName == "0202B-0001") {
                        stopScan()
                        Handler().postDelayed({
                            selectedBle = "weight"
                            gManagerFat = com.gsh.weightscale.api.GoldenBLEDeviceManager(
                                applicationContext,
                                gCallbackFat
                            )
                            gManagerFat?.scanLeDevice(true)
                        }, 1500)

                    }

//                    if (DevName == "GSH_862B") {
//                        stopScan()
//                        connectToBP(bleDevice)
//                    }
//                    if (DevName == "GSH230") {
//                        stopScan()
//                        connectToWT(bleDevice)
//                    }
//                    if (DevName == "GSH BH") {
//                        stopScan()
//                        connectToTEMP(bleDevice)
//                    }
//                    if (DevName == "GSH_BGM902") {
//                        stopScan()
//                        connectToBGL(bleDevice)
//                    }


                }


                private fun connectToWT(bleDevice: BleDevice) {}


                private fun connectToBP(bleDevice: BleDevice) {}


                private val BIT_SYNC = 0x80 // package head = 1, other byte = 0

                //byte0
                private val BIT_SIGNAL_STR = 0x0F //Signal strength 0~8
                private val BIT_SIGNAL = 0x10 //0 = OK, 1 = no signal
                private val BIT_PROBE = 0x20 //0 = OK, 1 = probe unplugged
                private val BIT_PULSE = 0x40 //1 = pulse beep

                //byte1
                private val BIT_PLETH = 0x7F //Pleth 0~100, 0 = invalid

                //byte2
                private val BIT_BARGRAPH = 0x0F //0~15, 0 = invalid
                private val BIT_FINGER = 0x10 //0 = OK, 1 = no finger
                private val BIT_PULSE_RESEARCH = 0x20 //0 = OK, 1 = pulse research
                private val BIT_PLUSE_RATE_BIT7 = 0x40 // is bit7 of pulse rate

                //byte3
                private val BIT_PLUSE_RATE_BIT0_6 =
                    0x7F // need add BIT_PLUSE_RATE_BIT7, 0xFF = invalid

                //byte4
                private val BIT_SPO2 = 0x7F // 0~100    0x7f = invalid
                private val UUID_SERVICE_DATA_SPO2 = "49535343-fe7d-4ae5-8fa9-9fafd205e455"
                private val UUID_CHARACTER_NOTIFY_SPO2 = "49535343-1e4d-4bd9-ba61-23c647249616"
                var SPO2_ReadingCount = 0

                private fun connectToSPO2(bleDevice: BleDevice) {
                    BleManager.getInstance().connect(bleDevice, object : BleGattCallback() {

                        override fun onStartConnect() {
                            Log.d("startScan", "onStartConnect ")
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("scanstarted|connection started")
                            }
                            // bluetoothFlutterResult.success("scanstarted|connection started")

                            //dev_status!!.text = "Connecting ..."
                        }


                        override fun onConnectFail(
                            bleDevice: BleDevice?,
                            exception: BleException?
                        ) {
                            Log.e("startScan", "onConnectFail ")
                            //dev_status!!.text = "ConnectFail SPO2..."
                            autoRepeatScan = 1
                            startScanTimer()
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("connectionfailed| connection failed")
                            }
                            // bluetoothFlutterResult.success("connectionfailed| connection failed")

                            //Toast.makeText(MainActivity.this, getString(R.string.connect_fail), Toast.LENGTH_LONG).show();
                        }

                        override fun onConnectSuccess(
                            bleDevice: BleDevice?,
                            gatt: BluetoothGatt?,
                            status: Int
                        ) {
                            Log.d("startScan", "onConnectSuccess ")
                            //val devName: String = bleDevice!!.getName()
                            bleName = bleDevice!!.name
                            var bleMacId: String
                            bleMacId = bleDevice!!.mac
                            var bleDeviceType: String
                            bleDeviceType = "SPO2"
                            if(bleMacId!=null && bleMacId.isNotEmpty()){
                                if (::BLEEventChannel.isInitialized) {
                                    BLEEventChannel.success("macid|" + bleMacId)
                                }
                            }

                            //Toast.makeText(applicationContext, "" + bleName + " connected successfully!!!" , Toast.LENGTH_LONG).show();
                            sendPost("deviceConnected", DEVICE_SPO2, 0, 0, 0)
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("bleDeviceType|" + bleDeviceType)
                            }
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("connected|" + bleName + " connected successfully!!!")
                            }
                            SPO2_ReadingCount = 0
                            val services =
                                BleManager.getInstance().getBluetoothGattServices(bleDevice)
                            DumpServicesChars(services)
                            BleManager.getInstance().notify(
                                bleDevice,
                                UUID_SERVICE_DATA_SPO2,
                                UUID_CHARACTER_NOTIFY_SPO2,
                                object : BleNotifyCallback() {
                                    override fun onNotifySuccess() {
                                        Log.e("startScan", "onNotifySuccess ")
                                    }

                                    override fun onNotifyFailure(exception: BleException?) {
                                        Log.e("startScan", "onNotifyFailure ")
                                    }

                                    @RequiresApi(Build.VERSION_CODES.O)
                                    override fun onCharacteristicChanged(data: ByteArray) {
                                        //Log.e(GTAG, "onCharacteristicChanged "+BytesToStr(data));
                                        var signalStrength: Int
                                        var isNoSignal: Int
                                        var isProbeUnplugged: Int
                                        var isBeep: Int
                                        var pleth: Int
                                        var bargraph: Int
                                        var isNoFinger: Int
                                        var isResearch: Int
                                        var pulseRate: Int
                                        var spo2: Int
                                        var index: Int
                                        index = 0
//                                        Log.d(
//                                            "received",
//                                            String.format("received data", data)
//                                        )
                                        while (index < data.size) {

                                            if (data[index] and BIT_SYNC.toByte() != 0.toByte()) {
                                                signalStrength =
                                                    getUB(data[index]) and BIT_SIGNAL_STR
                                                isNoSignal = getUB(data[index]) and BIT_SIGNAL
                                                isProbeUnplugged = getUB(data[index]) and BIT_PROBE
                                                isBeep = getUB(data[index]) and BIT_PULSE
                                                pleth = getUB(data[index + 1]) and BIT_PLETH
                                                bargraph = getUB(data[index + 2]) and BIT_BARGRAPH
                                                isNoFinger = getUB(data[index + 2]) and BIT_FINGER
                                                isResearch =
                                                    getUB(data[index + 2]) and BIT_PULSE_RESEARCH
                                                pulseRate =
                                                    getUB(data[index + 2]) and BIT_PLUSE_RATE_BIT7 shl 1
                                                pulseRate += getUB(data[index + 3]) and BIT_PLUSE_RATE_BIT0_6
                                                spo2 = getUB(data[index + 4]) and BIT_SPO2


//                                                Serial.print("SPO2_Stable ");Serial.println(SPO2_Stable);
//                                                Serial.print("Signal Strength ");Serial.println(signalStrength);
//                                                Serial.print("No Signal ");Serial.println(isNoSignal);
//                                                Serial.print("Probe Unplugged ");Serial.println(isProbeUnplugged);
//                                                Serial.print("Pulse Beep=");Serial.println(isBeep);
//
//                                                Serial.print("Pleth=");Serial.println(pleth);
//
//                                                Serial.print("Bargraph ");Serial.println(bargraph);
//                                                Serial.print("No Finger ");Serial.print(isNoFinger);
//                                                Serial.print("Pulse Research=");Serial.println(isResearch);
//
//                                                Serial.print("Pulse Rate ");Serial.print(pulseRate);
//                                                Serial.print("SPO2 ");Serial.print(spo2);
//                                                Serial.println();


//                                                    Log.d("nofinger",String.format("No Finger %d",isNoFinger));
//                                                    Log.d("pluse",String.format("Pulse Rate %d",pulseRate));
//                                                    Log.d("spo2",String.format("SPO2 %d",spo2));
                                                if (isNoFinger == 0 && pulseRate != 255 && pulseRate != 127 && spo2 < 101) {
                                                    SPO2_ReadingCount++
                                                    //dev_data.setText(String.format("%d PR %d SPO2 %d , F=%d",SPO2_ReadingCount,pulseRate,spo2,isNoFinger));
                                                    /*dev_data!!.text = String.format(
                                                        "PR %d SPO2 %d , F=%d",
                                                        pulseRate,
                                                        spo2,
                                                        isNoFinger
                                                    )*/
                                                    Log.d(
                                                        "data received", String.format(
                                                            "PR %d SPO2 %d , F=%d",
                                                            pulseRate,
                                                            spo2,
                                                            isNoFinger
                                                        )
                                                    )
                                                    if (uploaded == 0) {
                                                        Log.d(
                                                            "startScan",
                                                            String.format(
                                                                "Pulse Rate %d",
                                                                pulseRate
                                                            )
                                                        )
                                                        Log.d(
                                                            "startScan",
                                                            String.format("SPO2 %d", spo2)
                                                        )
                                                        uploaded = 1
                                                        sendPost(
                                                            "Measurement",
                                                            DEVICE_SPO2,
                                                            spo2,
                                                            pulseRate,
                                                            0
                                                        )
                                                        if (::BLEEventChannel.isInitialized) {
                                                            BLEEventChannel.success("measurement|" + postBleData)
                                                        }
                                                        // bluetoothFlutterResult.success("measurement|"+DEVICE_SPO2.toString()+"|"+spo2+"|"+pulseRate+bleName+" connected successfully!!!")

                                                    }
                                                } else {
                                                    //dev_data!!.text = "Reading SPO2."
                                                    SPO2_ReadingCount = 0
                                                }
                                            }
                                            index += 5
                                        }
                                    }
                                })

                            //bluetoothFlutterResult.success("connected|"+bleName+" connected successfully!!!")
                        }

                        override fun onDisConnected(
                            isActiveDisConnected: Boolean,
                            bleDevice: BleDevice?,
                            gatt: BluetoothGatt?,
                            status: Int
                        ) {
                            Log.d("startScan", "onDisConnected ")
                            //dev_status!!.text = "DisConnected SPO2."
                            sendPost("Disconnected", DEVICE_SPO2, 0, 0, 0)
                            uploaded = 0
                            if (isActiveDisConnected) {
                                Log.d("startScan", "isActiveDisConnected DisConnected ")

                                //Toast.makeText(MainActivity.this, getString(R.string.active_disconnected), Toast.LENGTH_LONG).show();
                            } else {
                                Log.d("startScan", " DisConnected ")
                                //Toast.makeText(MainActivity.this, getString(R.string.disconnected), Toast.LENGTH_LONG).show();
                            }
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("disconnected|" + bleName + " disconnected successfully!!!")
                            }
                            //stopScan()
                            // bluetoothFlutterResult.success("disconnected|"+bleName+" disconnected successfully!!!")

                        }
                    })
                }

                //********************************************************************************************************************
                val UUID_TEMPERATURE_SERVICE = "00001809-0000-1000-8000-00805f9b34fb"
                val UUID_TEMPERATURE_INDICATE_CHARACTERISTIC =
                    "00002a1c-0000-1000-8000-00805f9b34fb"

                private fun connectToTEMP(bleDevice: BleDevice) {
                    BleManager.getInstance().connect(bleDevice, object : BleGattCallback() {
                        override fun onStartConnect() {
                            Log.d("startScan", "onStartConnect ")
                        }

                        override fun onConnectFail(
                            bleDevice: BleDevice?,
                            exception: BleException?
                        ) {
                            Log.e("startScan", "onConnectFail ")
                            //dev_status!!.text = "ConnectFail TEMP..."
                            autoRepeatScan = 1
                            startScanTimer()
                            //Toast.makeText(MainActivity.this, getString(R.string.connect_fail), Toast.LENGTH_LONG).show();
                        }

                        override fun onConnectSuccess(
                            bleDevice: BleDevice?,
                            gatt: BluetoothGatt?,
                            status: Int
                        ) {
                            Log.d("startScan", "onConnectSuccess ")
                            //dev_status!!.text = "Connected to TEMP."
                            sendPost("Connected", DEVICE_TEMP, 0, 0, 0)
                            val services =
                                BleManager.getInstance().getBluetoothGattServices(bleDevice)
                            DumpServicesChars(services)
                            BleManager.getInstance().indicate(
                                bleDevice,
                                UUID_TEMPERATURE_SERVICE,
                                UUID_TEMPERATURE_INDICATE_CHARACTERISTIC,
                                object : BleIndicateCallback() {
                                    override fun onIndicateSuccess() {
                                        Log.e("startScan", "onIndicateSuccess ")
                                    }

                                    override fun onIndicateFailure(exception: BleException?) {
                                        Log.e("startScan", "onIndicateFailure ")
                                    }

                                    @RequiresApi(Build.VERSION_CODES.O)
                                    override fun onCharacteristicChanged(data: ByteArray) {
                                        Log.e(
                                            "startScan",
                                            "onCharacteristicChanged " + BytesToStr(data)
                                        )
                                        /*
    0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9
    07 7e 0e 00 fe 00 00 00 00 00 00 04 02
    * */
                                        val tmp32 =
                                            getUB(data[1]) + (getUB(data[2]) shl 8) + (getUB(data[3]) shl 16)
                                        val temperatureC = tmp32.toFloat() / 100
                                        val temperatureF = temperatureC * 9 / 5 + 32
                                        val MeasureCount = getUB(data[11])
                                        val st = StringBuilder()
                                        st.append(" Temperature C: ")
                                        st.append(temperatureC)
                                        st.append(" Temperature F: ")
                                        st.append(temperatureF)
                                        st.append(" MeasureCount: ")
                                        st.append(MeasureCount)
                                        var MeasurementLocation = ""
                                        if (data[12].equals(2)) MeasurementLocation = " Forehead "
                                        if (data[12].equals(9)) MeasurementLocation = " EAR "
                                        st.append(MeasurementLocation)
                                        Log.e("startScan", st.toString())
                                        /*dev_data!!.text = String.format(
                                            "Temp C %.2f Temp F %.2f Count %d ",
                                            temperatureC,
                                            temperatureF,
                                            MeasureCount
                                        ) + MeasurementLocation*/
                                        if (uploaded == 0) {
                                            uploaded = 1
                                            sendPost(
                                                "Measurement",
                                                DEVICE_TEMP,
                                                temperatureF.toInt(),
                                                0,
                                                0
                                            )
                                        }
                                    }
                                })
                        }

                        override fun onDisConnected(
                            isActiveDisConnected: Boolean,
                            bleDevice: BleDevice?,
                            gatt: BluetoothGatt?,
                            status: Int
                        ) {
                            Log.d("startScan", "onDisConnected ")
                            //dev_status!!.text = "DisConnected TEMP."
                            sendPost("Disconnected", DEVICE_TEMP, 0, 0, 0)
                            uploaded = 0
                            if (isActiveDisConnected) {
                                Log.d("startScan", "isActiveDisConnected DisConnected ")

                                //Toast.makeText(MainActivity.this, getString(R.string.active_disconnected), Toast.LENGTH_LONG).show();
                            } else {
                                Log.d("startScan", " DisConnected ")
                                //Toast.makeText(MainActivity.this, getString(R.string.disconnected), Toast.LENGTH_LONG).show();
                            }
                            //stopScan()
                        }
                    })
                }

                private fun connectToBGL(bleDevice: BleDevice) {}
            })
        } catch (ex: Exception) {
            Log.e("bleconnectstartscan", "startScan: " + ex.localizedMessage)
//            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        stopCriticalAlertServices()

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
                            val consentIntent:Intent? =
                                extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                            try {
                                // Start activity to show consent dialog to user, activity must be started in
                                // 5 minutes, otherwise you'll receive another TIMEOUT intent
                                startActivityForResult(consentIntent!!, SMS_CONSENT_REQUEST)
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



        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ONGOING_NS_CHANNEL
        ).setMethodCallHandler { call, result ->
            try {
                if (call.method!!.contentEquals(Constants.FUN_ONG_NS)) {
                    val passedMode = call.argument<String>(Constants.PROP_MODE)
                    startOnGoingNS(username!!, passedMode!!)
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                print(e.printStackTrace())
            }

        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SPEECH_TO_TEXT_STREAM
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {
                    mSpeechToTextEventChannel = events!!
                }

                override fun onCancel(arguments: Any?) {
                }
            }
        )
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Constants.Bluetooth_EVE_STREAM
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {
                    BLEEventChannel = events!!
                    measurementNotTaken=true
                    /*onCancel("")
                    Log.d("BLE VITALS", "StartingPoint")
                    BleManager.getInstance().init(application)
                    BleManager.getInstance()
                        .enableLog(true)
                    // .setReConnectCount(1, 5000)
                    // .setConnectOverTime(20000).operateTimeout = 5000
//                    val temp = checkPermissionStartScan(false)
                    startScanTimer()*/
                }

                override fun onCancel(arguments: Any?) {
                    Log.d("BLE_SCAN_CANCEL", "bleScanCancel")
                    stopScan()
                    stopExecutingMethods()
                    gManager?.scanLeDevice(false)
                    gManager?.disconnect()
                    gManager?.destroy()
                    gManagerFat?.scanLeDevice(false)
                    gManagerFat?.disconnect()
                    gManagerFat?.destroy()
                    gManagerBP?.scanLeDevice(false)
                    gManagerBP?.disconnect()
                    gManagerBP?.destroy()
                    gManager=null
                    gManagerFat=null
                    gManagerBP=null
                    LSBluetoothManager.getInstance().stopDeviceSync()
                    LSBluetoothManager.getInstance().stopDiscovery()
                    LSBluetoothManager.getInstance().stopSearch()
//                    when (selectedBle) {
//                        "spo2" -> {
//                            gManager?.scanLeDevice(false)
//                            gManager?.disconnect()
//                            gManager?.destroy()
//                        }
//                        "weight" -> {
//                            gManagerFat?.scanLeDevice(false)
//                            gManagerFat?.disconnect()
//                            gManagerFat?.destroy()
//                        }
//                        "bp" -> {
//                            gManagerBP?.scanLeDevice(false)
//                            gManagerBP?.disconnect()
//                            gManagerBP?.destroy()
//                        }
//                    }
                    selectedBle = ""
                    //Initialize Scan for all BLE devices
                   // scanAllBleDevices()

                    // resolved reconneting issues
                   // startScanWowGoDevices()
                }
            }
        )


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LISTEN4SMS
        ).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_LISTEN_SMS) {
                listenForSMS()
            } else {
                result.notImplemented()
            }
        }




        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            VOICE_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_VALIDATE_MIC_AVAIL) {
                val mic_status = validateMicAvailability()
                if (mic_status) {
                    result.success(true)
                } else {
                    result.success(false)
                }
            } else if (call.method == Constants.FUN_VOICE_ASST) {
                close.performClick()
                countDownTimerDialog.dismiss()
                val lang_code =
                    call.argument<String>(Constants.PROP_LANG_CODE) //todo uncomment this line
                _result = result
                langCode = lang_code!!
                speakWithVoiceAssistant()
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            TTS_CHANNEL
        ).setMethodCallHandler { call, result ->
            _TTSResult = result
            if (call.method == Constants.FUN_TEXT2SPEECH) {
                val msg = call.argument<String>(Constants.PROP_MSG)
                val iscls = call.argument<Boolean>(Constants.PROP_IS_CLOSE)
                val langCode =
                    call.argument<String>(Constants.PROP_LANG) //todo this has to be uncomment
                tts!!.language = Locale(langCode!!) //todo this has to be uncomment
                textToSpeech(msg!!, iscls!!)
            } else {
                result.notImplemented()
            }
        }


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            WIFICONNECT
        ).setMethodCallHandler { call, result ->
            if (call.method == "getTest") {

                Log.e("QUR", call.arguments.toString())
                val temp = getTest(
                    call.argument<String>("SSID").toString(),
                    call.argument<String>("Password").toString()
                )

                result.success(temp)
                // Note: this method is invoked on the main thread.
                // TODO
            }
            if (call.method == "dc") {
                val temp = disconnect()

                result.success(temp)
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DEVICES_CHANNEL
        ).setMethodCallHandler { call, result ->
            Log.d("BLE VITALS", "call method"+call.method)
            Log.d("BLE VITALS", "call arguments"+call.arguments)
            measurementNotTaken=true;
            MainThreadEventSink(BLEEventChannel).success("scanstarted|connection started")
            if (call.method == "scanAll") {
                scanType=call.method
                deviceType=""
                manufacture=""
                checkBluetoothTurnedOn()

                // bluetoothFlutterResult=result
                Log.d("BLE VITALS", "StartingPoint")
//                BleManager.getInstance().init(application)
//                BleManager.getInstance()
//                    .enableLog(true)
//                    .setReConnectCount(1, 5000)
//                    .setConnectOverTime(20000).operateTimeout = 5000
                stopExecutingMethods()
                scanAllBleDevices();
//                val temp = checkPermissionStartScan(false)
            }

            if (call.method == "scanSingle") {
                // bluetoothFlutterResult=result
                checkBluetoothTurnedOn()
                devicesList=call.arguments as ArrayList<*>

                scanType=call.method.toString()
                Log.e("check", "callMethodsDelayed: " + "wowgobeforeoutside" + wowGoFunctionIndex)
                stopScanWowgoDevices()
                stopExecutingMethods()
                scanSingleWowGoDevices();
                devicesList.forEachIndexed { index: Int, any: Any? ->
                    if((any as HashMap<String, String>).get("manufacture").equals("Transteck",ignoreCase = true)){
                        when((any as HashMap<String, String>).get("deviceType").toString().toLowerCase()) {
                            "weight"->{
                                LSBluetoothManager.getInstance().resetSyncingListener(onSyncingListener)
                                LSBluetoothManager.getInstance().searchDevice(listOf(LSDeviceType.WeightScale),searchingListener)
                            }
                            "bgl"->{
                                LSBluetoothManager.getInstance().resetSyncingListener(onSyncingListener)
                                LSBluetoothManager.getInstance().searchDevice(listOf(LSDeviceType.BloodGlucoseMeter),searchingListener)

                            }
                            else -> {}
                        }
                    }
                }
//                BleManager.getInstance().init(application)
//                BleManager.getInstance()
//                    .enableLog(true)
//                    .setReConnectCount(1, 5000)
//                    .setConnectOverTime(20000).operateTimeout = 5000

//                val temp = checkPermissionStartScan(false)


            }
        }




        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BLECONNECT
        ).setMethodCallHandler { call, result ->
            if (call.method == "bleconnect") {
                // bluetoothFlutterResult=result
                Log.d("BLE VITALS", "StartingPoint")
                /*BleManager.getInstance().init(application)
                BleManager.getInstance()
                    .enableLog(true)
                    .setReConnectCount(1, 5000)
                    .setConnectOverTime(20000).operateTimeout = 5000

                val temp = checkPermissionStartScan(false)*/

                /*                try {
                                    statusBleTimer = Timer()
                                    statusBleTimer.schedule(object : TimerTask()
                                    {
                                        override fun run() {
                                            if(postBleData?.contains("deviceConnected") == true)
                                            {
                                                result.success(bleName+" connected successfully!!!")
                                            }else if(postBleData?.contains("Disconnected") == true){
                                                result.success(bleName+" disconnected successfully!!!")
                                            }
                                        }
                                    }, 2000)
                                }catch (ex:Exception){
                                    Toast.makeText(this@MainActivity,ex.localizedMessage, Toast.LENGTH_SHORT).show()
                                }

                                Handler().postDelayed({
                                    result.success(postBleData)
                                    Handler().postDelayed({
                                        scanningBleTimer.cancel();
                                        statusBleTimer.cancel();
                                    }, 1000)
                                    //scanningBleTimer.cancel()
                                    //scanningBleTimer.purge()
                                }, 12000)*/

            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BLE_SCAN_CANCEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "bleScanCancel") {
                Log.d("BLE_SCAN_CANCEL", "bleScanCancel")
                stopExecutingMethods()
                //stopScan()
                LSBluetoothManager.getInstance().stopDeviceSync()
                LSBluetoothManager.getInstance().stopDiscovery()
                LSBluetoothManager.getInstance().stopSearch()
                //when (selectedBle) {
                //  "spo2" -> {
                gManager?.scanLeDevice(false)
                gManager?.disconnect()
                gManager?.destroy()
                //}
                //"weight" -> {
                gManagerFat?.scanLeDevice(false)
                gManagerFat?.disconnect()
                gManagerFat?.destroy()
                //}
                //"bp" -> {
                gManagerBP?.scanLeDevice(false)
                gManagerBP?.disconnect()
                gManagerBP?.destroy()
                //}
                //}
                selectedBle = ""
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BPCONNECT
        ).setMethodCallHandler { call, result ->
            _resultBp = result
            if (call.method == "bpconnect") {
                Log.d("BP START", "StartingPoint")
                //startBpScan()
                //checkPermissionStartScan(true)
            }
        }

        /*MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BP_CONNECT_CANCEL
        ).setMethodCallHandler { call, result ->
            _resultBpCancel = result
            if (call.method == "bpscancancel") {
                Log.d("BP SCAN CANCEL", "Cancel BP Scan ")
                try {
                    mOHQDeviceManager!!.stopScan();
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }*/

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BP_ENABLE_CHECK
        ).setMethodCallHandler { call, result ->
            if (call.method == BP_ENABLE_CHECK) {
                Log.d("BLUETOOTH_ENABLE_CHECK", "Bluetooth Enable Check")
                try {
                    val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
                    if (!bluetoothAdapter.isEnabled) {
                        result.success(false)
                    } else {
                        result.success(true)
                    }
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ENABLE_BACKGROUND_NOTIFICATION
        ).setMethodCallHandler { call, result ->
            if (call.method == ENABLE_BACKGROUND_NOTIFICATION) {
                try {
                    enableBackgroundNotification = true;
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DISABLE_BACKGROUND_NOTIFICATION
        ).setMethodCallHandler { call, result ->
            if (call.method == DISABLE_BACKGROUND_NOTIFICATION) {
                try {
                    enableBackgroundNotification = false;
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GET_CURRENT_LOCATION
        ).setMethodCallHandler { call, result ->
            if (call.method == GET_CURRENT_LOCATION) {
                Log.d("GET_CURRENT_LOCATION", "GET_CURRENT_LOCATION")
                try {
                    val myLocation = getLastKnownLocation()
                    if (myLocation != null) {
                        result.success("${myLocation.latitude}|${myLocation.longitude}")
                    } else {
                        result.success("")
                    }
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

       

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CLOSE_SHEELA_DIALOG
        ).setMethodCallHandler { call, result ->
            if (call.method == CLOSE_SHEELA_DIALOG) {
                Log.d("CLOSE_SHEELA_DIALOG", "CLOSE_SHEELA_DIALOG")
                try {
                    /*close.performClick()
                    countDownTimerDialog.dismiss()*/
                    result.success("success")
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LOCATION_SERVICE_CHECK
        ).setMethodCallHandler { call, result ->
            if (call.method == LOCATION_SERVICE_CHECK) {
                Log.d("LOCATION_SERVICE_CHECK", "LOCATION_SERVICE_CHECK")
                try {
                    val locationServiceEnabled = checkGPSIsOpen()
                    if (!locationServiceEnabled) {
                        result.success(false)
                    } else {
                        result.success(true)
                    }
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            IS_NOTIFICATION_PERMISSION_CHECK
        ).setMethodCallHandler { call, result ->
            if (call.method == IS_NOTIFICATION_PERMISSION_CHECK) {
                Log.d("IS_NOTIFICATION_PERMISSION_CHECK", "IS_NOTIFICATION_PERMISSION_CHECK")
                try {
                    checkNotificationPermission()
                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

    }

    fun scanAllBleDevices(){
        startAllDevicesScanForWOWGo()
        startTransteckWowGoDevice();
    }

    fun startTransteckWowGoDevice(){
        LSBluetoothManager.getInstance().setDevices(null)
        LSBluetoothManager.getInstance().resetSyncingListener(onSyncingListener)
        LSBluetoothManager.getInstance().searchDevice(listOf(LSDeviceType.WeightScale,LSDeviceType.BloodGlucoseMeter),searchingListener)
    }

    fun startAllDevicesScanForWOWGo(){
        startExecutingMethods()
//        startWowGoSpo2DeviceScan()
//        startWowGoBPDeviceScan()
//        startWowGoWeightDeviceScan()
    }

    private fun startExecutingMethods() {
        isExecuting = true
        executeMethods()
    }

    private fun executeMethods() {
        if (isExecuting) {
            stopScanWowgoDevices()
            startWowGoSpo2DeviceScan()
            handlerBle.postDelayed(::executeSecondMethod, 2000) // 2 sec delay
        }
    }

    private fun executeSecondMethod() {
        if (isExecuting) {
            stopScanWowgoDevices()
            startWowGoBPDeviceScan()
            handlerBle.postDelayed(::executeThirdMethod, 2000) // 2 sec delay
        }
    }

    private fun executeThirdMethod() {
        if (isExecuting) {
            stopScanWowgoDevices()
            startWowGoWeightDeviceScan()
            handlerBle.postDelayed(::executeMethods, 2000) // 2 sec delay, loop to the first method
        }
    }

    private fun scanSingleWowGoDevices() {
        wowGoDeviceList = arrayListOf<String>()
        wowgoFunctionList = arrayListOf<Unit>()
        stopScanWowgoDevices()
        devicesList.forEachIndexed { index: Int, any: Any? ->
            if ((any as HashMap<String, String>).get("manufacture")
                    .equals("WOWGo", ignoreCase = true)
            ) {
                var device =
                    (any as HashMap<String, String>).get("deviceType").toString().toLowerCase();
                wowGoDeviceList?.add(device)
                /*if (device.equals("spo2")) {
                    wowgoFunctionList?.add(startWowGoSpo2DeviceScan())
                } else if (device.equals("bp")) {
                    wowgoFunctionList?.add(startWowGoBPDeviceScan())
                } else if (device.equals("weight")) {
                    wowgoFunctionList?.add(startWowGoWeightDeviceScan())
                }*/
            }
        }

        if (wowGoDeviceList?.size == 1) {
            if(wowGoDeviceList!![0].equals("spo2")){
                startWowGoSpo2DeviceScan()
            }else if(wowGoDeviceList!![0].equals("bp")){
                startWowGoBPDeviceScan()
            }else if(wowGoDeviceList!![0].equals("weight")){
                startWowGoWeightDeviceScan()
            }
        } else {
            isExecuting=true
            wowGoFunctionIndex=0
            handlerBleWowGo.removeCallbacksAndMessages(null)

            Log.e("check", "callMethodsDelayed: " + "wowgobefore" + wowGoFunctionIndex)
            callMethodsDelayed()
        }
//       wowGoDeviceList.forEachIndexed { index, device ->
//           if(device.equals("spo2")){
//               isExecuting = true
//               stopScanWowgoDevices()
//               if(wowGoDeviceList[0].equals("spo2")){
//                   startWowGoSpo2DeviceScan()
//               }else{
//                   handler.postDelayed(::startWowGoSpo2DeviceScan, 2000)
//               }
//           }else if(device.equals("bp")){
//               isExecuting = true
//               stopScanWowgoDevices()
//               if(wowGoDeviceList[0].equals("bp")){
//                   startWowGoBPDeviceScan()
//               }else{
//                   handler.postDelayed(::startWowGoBPDeviceScan, 2000)
//               }
//           }else if(device.equals("weight")){
//               isExecuting = true
//               stopScanWowgoDevices()
//               if(wowGoDeviceList[0].equals("weight")){
//                   startWowGoWeightDeviceScan()
//               }else{
//                   handler.postDelayed(::startWowGoWeightDeviceScan, 2000)
//               }
//           }
//
//           if(wowGoDeviceList.size!=1){
//               handler.postDelayed(::scanSingleWowGoDevices, 2000)
//           }
//       }

    }

    private fun callMethodsDelayed() {
        if(isExecuting) {

            stopScanWowgoDevices()
            if (wowGoFunctionIndex < wowGoDeviceList?.size!!) {
                val currentMethod = wowGoDeviceList?.get(wowGoFunctionIndex)
//            currentMethod.invoke()
                if (wowGoDeviceList!![wowGoFunctionIndex].equals("spo2")) {
                    startWowGoSpo2DeviceScan()
                } else if (wowGoDeviceList!![wowGoFunctionIndex].equals("bp")) {
                    startWowGoBPDeviceScan()
                } else if (wowGoDeviceList!![wowGoFunctionIndex].equals("weight")) {
                    startWowGoWeightDeviceScan()
                }
                Log.e("check", "callMethodsDelayed: " + "wowgo" + wowGoFunctionIndex)
                wowGoFunctionIndex++
//                handlerBleWowGo.removeCallbacksAndMessages(null)
                handlerBleWowGo.postDelayed(::callMethodsDelayed, 3000)

            } else {
                // All methods completed, start again
                wowGoFunctionIndex = 0
                //handlerBleWowGo.removeCallbacksAndMessages(null)

                Log.e("check", "callMethodsDelayed: " + "starting again" + wowGoFunctionIndex)

                handlerBleWowGo.postDelayed(::callMethodsDelayed, 3000)
            }
        }
    }

    fun stopScanWowgoDevices(){
        gManager?.scanLeDevice(false)
        gManager?.disconnect()
        gManager?.destroy()
        gManagerFat?.scanLeDevice(false)
        gManagerFat?.disconnect()
        gManagerFat?.destroy()
        gManagerBP?.scanLeDevice(false)
        gManagerBP?.disconnect()
        gManagerBP?.destroy()
        gManager=null
        gManagerFat=null
        gManagerBP=null
    }

    private fun stopExecutingMethods() {
        isExecuting = false
        wowGoTimer.cancel()
        handlerBle.removeCallbacksAndMessages(null)
        handlerBleWowGo.removeCallbacksAndMessages(null)
    }


    fun startWowGoSpo2DeviceScan(){
        Log.e("checking", "startWowGoSpo2DeviceScan: starting spo2")
        selectedBle = "spo2"
        gManager = GoldenBLEDeviceManager(applicationContext, gCallback)
        gManager?.scanLeDevice(true)
        WOWGoDataUpload = 0
    }
    fun startWowGoBPDeviceScan(){
        Log.e("checking", "startWowGoBPDeviceScan: starting bp")

        selectedBle = "bp"
        gManagerBP = com.gsh.bloodpressure.api.GoldenBLEDeviceManager(
            applicationContext,
            gCallBackBP
        )
        gManagerBP?.scanLeDevice(true)
    }
    fun startWowGoWeightDeviceScan(){
        Log.e("checking", "startWowGoWeightDeviceScan: starting weight")

        selectedBle = "weight"
        gManagerFat = com.gsh.weightscale.api.GoldenBLEDeviceManager(
            applicationContext,
            gCallbackFat
        )
        gManagerFat?.scanLeDevice(true)
    }

    // scan only for wow go for reconnecting flow
    fun startScanWowGoDevices(){
        gManager = GoldenBLEDeviceManager(applicationContext, gCallback)
        gManager?.scanLeDevice(true)
        gManagerBP = com.gsh.bloodpressure.api.GoldenBLEDeviceManager(
            applicationContext,
            gCallBackBP
        )
        gManagerBP?.scanLeDevice(true)
        gManagerFat = com.gsh.weightscale.api.GoldenBLEDeviceManager(
            applicationContext,
            gCallbackFat
        )
        gManagerFat?.scanLeDevice(true)
        startTransteckWowGoDevice()
    }

    @SuppressLint("MissingPermission")
    private fun getLastKnownLocation(): Location? {
        mLocationManager = applicationContext.getSystemService(LOCATION_SERVICE) as LocationManager
        val providers = mLocationManager!!.getProviders(true)
        var bestLocation: Location? = null
        for (provider in providers) {
            val location = mLocationManager!!.getLastKnownLocation(provider) ?: continue
            if (bestLocation == null || location.accuracy < bestLocation.accuracy) {
                // Found best last known location: %s", l);
                bestLocation = location
            }
        }
        return bestLocation
    }


    private fun startBpScan() {
        //AppLog.vMethodIn()
        /*if (mIsScanning) {
            AppLog.e("Already scanning.")
            return
        }*/
        //mOHQDeviceManager = OHQDeviceManager.sharedInstance()
        val scanFilter: MutableList<OHQDeviceCategory> = ArrayList()
        //if (null != filteringDeviceCategory) {
        //AppLog.d("filteringDeviceCategory:$filteringDeviceCategory")
        scanFilter.add(OHQDeviceCategory.BloodPressureMonitor)
        //}
        /*mOHQDeviceManager!!.scanForDevicesWithCategories(
            scanFilter,
            ScanObserverBlock { deviceInfo ->
                *//*mHandler.post(Runnable { _onScan(deviceInfo) })*//*
                mOHQDeviceManager!!.stopScan()
                Log.e("Scan List response", "" + deviceInfo.toString())

                parseScanListJson(deviceInfo)

            },
            CompletionBlock { reason -> *//*mHandler.post(Runnable { _onScanCompletion(reason) })*//*
                Log.e(
                    "reason: ",
                    "" + reason.toString()
                )
            })*/
        //mIsScanning = true
        //mDiscoveredDevices.clear()
        /*mHandler.postDelayed(
            mBatchedScanRunnable,
            jp.co.ohq.blesampleomron.controller.ScanController.BATCHED_SCAN_INTERVAL
        )*/
    }

    private fun parseScanListJson(deviceInfo: Map<OHQDeviceInfoKey, Any>) {
        val address: String
        if (!deviceInfo.containsKey(OHQDeviceInfoKey.AddressKey)) {
            throw AndroidRuntimeException("The address must be present.")
        }
        if (null == Types.autoCast<String>(deviceInfo.get(OHQDeviceInfoKey.AddressKey)).also {
                address = it
            }) {
            throw AndroidRuntimeException("The address must be present.")
        }

        val discoveredDevice: DiscoveredDevice? = if (mDiscoveredDevices.containsKey(address)) {
            AppLog.d("Update discovered device. $address")
            mDiscoveredDevices[address]
        } else {
            AppLog.d("New discovered device. $address")
            DiscoveredDevice(address)
        }

        if (deviceInfo.containsKey(OHQDeviceInfoKey.AdvertisementDataKey)) {
            val advertisementData: List<ADStructure> = Types.autoCast(
                deviceInfo[OHQDeviceInfoKey.AdvertisementDataKey]
            )
            discoveredDevice!!.advertisementData = advertisementData
        }
        if (deviceInfo.containsKey(OHQDeviceInfoKey.CategoryKey)) {
            val deviceCategory: OHQDeviceCategory =
                Types.autoCast(deviceInfo[OHQDeviceInfoKey.CategoryKey])
            discoveredDevice!!.deviceCategory = deviceCategory
        }
        if (deviceInfo.containsKey(OHQDeviceInfoKey.RSSIKey)) {
            val rssi = Types.autoCast<Int>(deviceInfo[OHQDeviceInfoKey.RSSIKey])
            discoveredDevice!!.rssi = rssi
        }
        if (deviceInfo.containsKey(OHQDeviceInfoKey.ModelNameKey)) {
            val modelName = Types.autoCast<String>(deviceInfo[OHQDeviceInfoKey.ModelNameKey])
            discoveredDevice!!.modelName = modelName
        }
        if (deviceInfo.containsKey(OHQDeviceInfoKey.LocalNameKey)) {
            val localName = Types.autoCast<String>(deviceInfo[OHQDeviceInfoKey.LocalNameKey])
            discoveredDevice!!.localName = localName
        }

        mDiscoveredDevices[address] = discoveredDevice!!

        getBpAddress(address)
    }

    private fun getBpAddress(address: String) {

        mAddress = address
        mSessionData.deviceAddress = address
        mSessionAddress = address

        registerBpDevice();

    }

    private fun registerBpDevice() {
        /*mSessionController!!.setConfig(getConfig(applicationContext))
        mOption[OHQSessionOptionKey.ReadMeasurementRecordsKey] = true
        mOption[OHQSessionOptionKey.ConnectionWaitTimeKey] = CONNECTION_WAIT_TIME
        mSessionController!!.startSession(mAddress, mOption)*/
    }

    /*private fun transferBpData() {
        mSessionController!!.setConfig(getConfig(context))
        mOption[OHQSessionOptionKey.UserDataUpdateFlagKey] = false
        mOption[OHQSessionOptionKey.ReadMeasurementRecordsKey] = true
        mOption[OHQSessionOptionKey.ConnectionWaitTimeKey] = CONNECTION_WAIT_TIME
        mSessionController!!.startSession(mAddress, mOption)
    }*/


    private fun disconnect(): Int {
        if (android.os.Build.VERSION.SDK_INT >= 29) {
            val connectivityManager =
                applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            connectivityManager.unregisterNetworkCallback(mNetworkCallback)
        }
        return 1
    }

    private val mNetworkCallback = object : ConnectivityManager.NetworkCallback() {
        @RequiresApi(Build.VERSION_CODES.M)
        override fun onAvailable(network: Network) {
            //phone is connected to wifi network
            val connectivityManager =
                applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            connectivityManager.bindProcessToNetwork(network)
        }
    }

    private fun getTest(ssid: String, password: String): Int {

        if (android.os.Build.VERSION.SDK_INT >= 29) {
            val specifier = WifiNetworkSpecifier.Builder()
                // .setSsidPattern(PatternMatcher("SSID", PatternMatcher.PATTERN_PREFIX))
                .setSsid(ssid)
                .setWpa2Passphrase(password)
                .build()
            val request = NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .setNetworkSpecifier(specifier)
                .build()

            val connectivityManager =
                applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

            connectivityManager.requestNetwork(request, mNetworkCallback)

            // Release the request when done.
            //

            return 1
        } else {
            var networkSSID = ssid
            var networkPass = password
            var conf = WifiConfiguration()
            conf.SSID = "\"" + networkSSID + "\""
            conf.preSharedKey = "\"" + networkPass + "\""
            var wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            var netid = wifiManager.addNetwork(conf)
            wifiManager.disconnect()
            wifiManager.enableNetwork(netid, true)
            wifiManager.reconnect()
            return ssid.length

        }


    }


    private fun startOnGoingNS(name: String, mode: String) {
        if (mode == Constants.PROP_START) {
            val serviceIntent = Intent(this, AVServices::class.java)
            serviceIntent.putExtra(Constants.PROP_NAME, name)
            startService(serviceIntent)
        } else if (mode == Constants.PROP_STOP) {
            val serviceIntent = Intent(this, AVServices::class.java)
            stopService(serviceIntent)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun onPause() {
        try {
            Constants.foregroundActivityRef = false;
            stopCriticalAlertServices()
            super.onPause()
        } catch (e: Exception) {
            Log.d("Catch", "" + e.toString())
        }
    }


    override fun onResume() {
        Log.e("Myapp", "onResume: " + " onResume")
        Constants.foregroundActivityRef = true
        val nsManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        nsManager.cancel(2022)
        super.onResume()
    }


    override fun onDestroy() {
        try {
            Log.e("Myapp", "onDestroy: " + " onDestroy")
            Constants.foregroundActivityRef = false;
            if (enableBackgroundNotification) {
                val serviceIntent = Intent(this, CriticalAlertServices::class.java)
                startService(serviceIntent)
            }
            super.onDestroy()
            val serviceIntent = Intent(this, AVServices::class.java)
            stopService(serviceIntent)
            speechRecognizer?.destroy()
        } catch (e: Exception) {
            Log.d("Catch", "" + e.toString())
        }
    }


    val handler: Handler = Handler()
    val runnable = Runnable {
        try {
            if (dialog.isShowing) {
                Log.e("showing", "showing dialog")
                close.performClick()
                _result?.error("100", "no response", 100)
                _result = null
            }
        } catch (e: Exception) {

        }
    }

    //todo this method need to uncomment
    private fun speakWithVoiceAssistant() {

        try {

            Log.e("langs", langCode!!)


            countDownTimerDialog.show()

            countDown = object : CountDownTimer(11000, 1000) {
                override fun onTick(millisUntilFinished: Long) {
                    countDownTimer.text = (millisUntilFinished / 1000).toString() + " seconds"
                }

                override fun onFinish() {
                    countDownTimerDialog.dismiss()
                    countDown?.cancel()
                    speechRecognizer?.stopListening()
                    close.performClick()
                    _result?.error("100", "no response", 100)
                    _result = null
                }
            }
            countDown?.start()
            firstTimeSpeechError=true;
            initSpeechRecognizer()
        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }

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

    private fun listenForSMS() {
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
                    Toast.makeText(this@MainActivity, otp, Toast.LENGTH_LONG).show()
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


    private fun textToSpeech(msg: String, isClose: Boolean) {
        tts!!.setSpeechRate(1.0f)
        if (isClose) {
            tts!!.stop()
        } else {
            tts!!.speak(
                msg, TextToSpeech.QUEUE_FLUSH, null,
                TextToSpeech.Engine.KEY_PARAM_UTTERANCE_ID
            )
        }

        tts!!.setOnUtteranceProgressListener(object : UtteranceProgressListener() {
            override fun onDone(p0: String?) {
                runOnUiThread(Runnable { _TTSResult.success(1) })
            }

            override fun onError(p0: String?) {}

            override fun onStart(p0: String?) {}

        })

    }


    private fun requestPermissionFromUSer() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(android.Manifest.permission.RECORD_AUDIO),
            REQ_CODE
        )
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
                /*if (resultCode == Activity.RESULT_OK && data != null) {
                    val result: ArrayList<*> = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
                    val finalWords = result[0].toString()
                    //Toast.makeText(applicationContext, "You said:\n$finalWords", Toast.LENGTH_LONG).show()
                    //_result.success(finalWords)
                }*/
            }
            INTENT_AUTHENTICATE -> {
                if (resultCode == Activity.RESULT_OK) {
                    _securityResult.success(1002)
                } else {
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



    private fun validateMicAvailability(): Boolean {
        var available = true
        val am: AudioManager = applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (am.mode === AudioManager.MODE_IN_COMMUNICATION) {
            //Mic is in use
            available = false
        }
        return available
    }



    private fun getConfig(context: Context): Bundle {
        val pref: SharedPreferences =
            PreferenceManager.getDefaultSharedPreferences(context)
        var s: String?
        val cOption: CreateBondOption
        s = pref.getString(SettingKey.create_bond_option.name, null)
        cOption = if (getString(R.string.create_bond_before_catt_connection).equals(s)) {
            CreateBondOption.UsedBeforeGattConnection
        } else if (getString(R.string.create_bond_after_services_discovered).equals(s)) {
            CreateBondOption.UsedAfterServicesDiscovered
        } else {
            CreateBondOption.NotUse
        }
        val rOption: RemoveBondOption
        s = pref.getString(SettingKey.remove_bond_option.name, null)
        rOption = if (getString(R.string.remove_bond_use).equals(s)) {
            RemoveBondOption.UsedBeforeConnectionProcessEveryTime
        } else {
            RemoveBondOption.NotUse
        }
        return Bundler.bundle(
            OHQConfig.Key.CreateBondOption.name,
            cOption,
            OHQConfig.Key.RemoveBondOption.name,
            rOption,
            OHQConfig.Key.AssistPairingDialogEnabled.name,
            pref.getBoolean(SettingKey.assist_pairing_dialog.name, false),
            OHQConfig.Key.AutoPairingEnabled.name,
            pref.getBoolean(SettingKey.auto_pairing.name, false),
            OHQConfig.Key.AutoEnterThePinCodeEnabled.name,
            pref.getBoolean(SettingKey.auto_enter_the_pin_code.name, false),
            OHQConfig.Key.PinCode.name,
            pref.getString(SettingKey.pin_code.name, "123456"),
            OHQConfig.Key.StableConnectionEnabled.name,
            pref.getBoolean(SettingKey.stable_connection.name, false),
            OHQConfig.Key.StableConnectionWaitTime.name,
            pref.getString(
                SettingKey.stable_connection_wait_time.name,
                "123456"
            )?.let {
                java.lang.Long.valueOf(
                    it
                )
            },
            OHQConfig.Key.ConnectionRetryEnabled.name,
            pref.getBoolean(SettingKey.connection_retry.name, false),
            OHQConfig.Key.ConnectionRetryDelayTime.name,
            pref.getString(
                SettingKey.connection_retry_delay_time.name,
                "123456"
            )?.let {
                java.lang.Long.valueOf(
                    it
                )
            },
            OHQConfig.Key.ConnectionRetryCount.name,
            pref.getString(SettingKey.connection_retry_count.name, "123456")
                ?.let { Integer.valueOf(it) },
            OHQConfig.Key.UseRefreshWhenDisconnect.name,
            pref.getBoolean(SettingKey.refresh_use.name, false)
        )
    }

    /*override fun onConnectionStateChanged(connectionState: OHQConnectionState) {
        AppLog.vMethodIn(connectionState.name)
        //mListener!!.onConnectionStateChanged(connectionState)
    }*/

    /*override fun onSessionComplete(sessionData: SessionData) {
        AppLog.vMethodIn(sessionData.completionReason!!.name)
        mSessionAddress = null
        mSessionData = sessionData
        mSessionData.setCompletionReason(sessionData.completionReason)
        mSessionData.deviceAddress = mAddress
        if(mAddress!=null&& mAddress.isNotEmpty()){
            if (::BLEEventChannel.isInitialized) {
                BLEEventChannel.success("macid|" + mAddress)
            }
        }


        if (::BLEEventChannel.isInitialized) {
            BLEEventChannel.success("bleDeviceType|" + "BP")
        }
        Log.e("outputNative", "" + mSessionData.toString());
        if (mSessionData != null && mSessionData.measurementRecords != null && mSessionData.measurementRecords!!.size > 0) {
//            _resultBp.success(mSessionData.toString())
//
            var sys: Int =
                mSessionData.measurementRecords!!.last().get(OHQMeasurementRecordKey.SystolicKey)
                    .toString().toDouble().toInt()
            var dia: Int =
                mSessionData.measurementRecords!!.last().get(OHQMeasurementRecordKey.DiastolicKey)
                    .toString().toDouble().toInt()
            var pul: Int =
                mSessionData.measurementRecords!!.last().get(OHQMeasurementRecordKey.PulseRateKey)
                    .toString().toDouble().toInt()

            sendPost("Measurement", DEVICE_BP, sys, dia, pul)
            if (::BLEEventChannel.isInitialized) {
                BLEEventChannel.success("measurement|" + postBleData)
            }
        }


        *//*if (sessionData.completionReason!!.name == "Disconnected") {
            if (sessionData.measurementRecords!!.size > 0) {

            } else {
                transferBpData()
            }
        }*//*
        //mListener!!.onSessionComplete(mSessionData)
    }*/

    /*override fun onDetailedStateChanged(newState: OHQDetailedState) {
        TODO("Not yet implemented")
    }

    override fun onPairingRequest() {
        TODO("Not yet implemented")
    }*/

    /*override fun onBondStateChanged(bondState: CBPeripheral.BondState) {
        TODO("Not yet implemented")
    }

    override fun onAclConnectionStateChanged(aclConnectionState: CBPeripheral.AclConnectionState) {
        TODO("Not yet implemented")
    }

    override fun onGattConnectionStateChanged(gattConnectionState: CBPeripheral.GattConnectionState) {
        TODO("Not yet implemented")
    }*/

    override fun onBluetoothStateChanged(enable: Boolean) {
        TODO("Not yet implemented")
    }


    private fun stopCriticalAlertServices() {
        try {
            val serviceIntent = Intent(this, CriticalAlertServices::class.java)
            stopService(serviceIntent)
            Log.d("stopCriticalAlert", "Calling")
        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }
    }

    fun prefixListFiltering(): String {
        try {
            for (strSheelaText in sheelaTTSWordList) {
                if (finalWords!!.lowercase().contains(strSheelaText.lowercase())) {
                    finalWords =
                        finalWords!!.replace(strSheelaText, Constants.sheelaText, ignoreCase = true)
                }
            }
            return finalWords!!
        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
            return finalWords!!
        }
    }


    private fun initSpeechRecognizer() {
        try {

            speechRecognizer?.destroy()

            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this@MainActivity)
            speechIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)


            speechRecognizer?.setRecognitionListener(object : RecognitionListener {
                override fun onReadyForSpeech(params: Bundle?) {}

                override fun onBeginningOfSpeech() {
                    Log.e("speechreco", "onBeginningOfSpeech: ")
                    countDown?.cancel()
                    countDownTimerDialog.dismiss()
                    if (!dialog.isShowing) {
                        micOn.visibility = View.GONE

                        listeningLayout.visibility = View.VISIBLE
                        tryMe.visibility = View.GONE
                        displayText?.setText("")
                        edit_view.clearFocus()
                        val imm: InputMethodManager =
                            getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
                        var view = currentFocus
                        if (view == null) {
                            view = View(applicationContext)
                        }
                        imm.hideSoftInputFromWindow(view.windowToken, 0)
                        dialog.show()
                    }
                }

                override fun onRmsChanged(rmsdB: Float) {}

                override fun onBufferReceived(buffer: ByteArray?) {}

                override fun onEndOfSpeech() {}

                override fun onError(error: Int) {
                    Log.e("onError ", "${error.toString()}")
                    if(firstTimeSpeechError){
                        firstTimeSpeechError=false;
                        initSpeechRecognizer()
                    }
                }

                override fun onResults(results: Bundle?) {
                    Log.e("speechreco", "onResults: ")

                    val data = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    Log.e("speechreco", "onResults: " + data)


                    if (data != null && data.size > 0) {
                        val pattern = Regex("^[A-Za-z]+\$")

                        finalWords += data[0] + " "
                        if (langCode!!.contains("en")) {
                            displayText.setText((prefixListFiltering()))
                        } else {
                            displayText.setText(finalWords)
                        }

                        speechRecognizer?.stopListening()
                        speechIntent?.putExtra(RecognizerIntent.EXTRA_LANGUAGE, langCode)
                        speechRecognizer?.startListening(speechIntent)
                    }
                }

                override fun onPartialResults(partialResults: Bundle?) {}

                override fun onEvent(eventType: Int, params: Bundle?) {}
            })

            speechIntent?.putExtra(RecognizerIntent.EXTRA_LANGUAGE, langCode)
            speechRecognizer?.startListening(speechIntent)


        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }
    }


}

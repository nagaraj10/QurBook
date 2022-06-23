package com.ventechsolutions.myFHB

import android.Manifest
import android.annotation.SuppressLint
import android.app.*
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import android.content.*
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.location.Location
import android.location.LocationManager
import android.media.AudioAttributes
import android.media.AudioManager
import android.net.*
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.preference.PreferenceManager
import android.provider.Settings
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.util.AndroidRuntimeException
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.Window
import android.widget.*
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.multidex.BuildConfig
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
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.neovisionaries.bluetooth.ble.advertising.ADStructure
import com.ventechsolutions.myFHB.bloodpressure.controller.BluetoothPowerController
import com.ventechsolutions.myFHB.bloodpressure.controller.ScanController
import com.ventechsolutions.myFHB.bloodpressure.controller.SessionController
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
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import jp.co.ohq.androidcorebluetooth.CBConfig.CreateBondOption
import jp.co.ohq.androidcorebluetooth.CBConfig.RemoveBondOption
import jp.co.ohq.ble.OHQConfig
import jp.co.ohq.ble.OHQDeviceManager
import jp.co.ohq.ble.OHQDeviceManager.CompletionBlock
import jp.co.ohq.ble.OHQDeviceManager.ScanObserverBlock
import jp.co.ohq.ble.enumerate.OHQConnectionState
import jp.co.ohq.ble.enumerate.OHQDeviceCategory
import jp.co.ohq.ble.enumerate.OHQDeviceInfoKey
import jp.co.ohq.ble.enumerate.OHQSessionOptionKey
import jp.co.ohq.utility.Bundler
import jp.co.ohq.utility.Types
import java.io.IOException
import java.security.SecureRandom
import java.util.*
import java.util.concurrent.atomic.AtomicInteger
import kotlin.experimental.and
import kotlin.system.exitProcess


class MainActivity : FlutterActivity(), SessionController.Listener,
    BluetoothPowerController.Listener {

    //    private lateinit var bluetoothFlutterResult: MethodChannel.Result
    private val VERSION_CODES_CHANNEL = Constants.CN_VC
    private val LISTEN4SMS = Constants.CN_LISTEN4SMS
    private val VOICE_CHANNEL = Constants.CN_VOICE_INTENT
    private val TTS_CHANNEL = Constants.CN_TTS
    private val SECURITY_CHANNEL = Constants.CN_SECURE
    private val ROUTE_CHANNEL = Constants.CN_ROUTE
    private val SHEELA_CHANNEL = Constants.SHEELA_CHANNEL
    private val ONGOING_NS_CHANNEL = Constants.CN_ONG_NS
    private val STREAM = Constants.CN_EVE_STREAM
    private val SPEECH_TO_TEXT_STREAM = Constants.SPEECH_TO_TEXT_STREAM
    private val WIFICONNECT = Constants.WIFI_WORKS
    private val BLECONNECT = Constants.BLE_CONNECT
    private val BPCONNECT = Constants.BP_CONNECT
    private val BLE_SCAN_CANCEL = Constants.BLE_SCAN_CANCEL
    private val BP_CONNECT_CANCEL = Constants.BP_SCAN_CANCEL
    private val BP_ENABLE_CHECK = Constants.BP_ENABLE_CHECK
    private val GET_CURRENT_LOCATION = Constants.GET_CURRENT_LOCATION
    private val APPOINTMENT_TIME = Constants.APPOINTMENT_DETAILS
    private var sharedValue: String? = null
    private var username: String? = null
    private var templateName: String? = null
    private var bookingId: String? = null
    private var appDate: String? = null
    private var docSessionId: String? = null
    private var healthOrgId: String? = null
    private var docId: String? = null
    private var docPic: String? = null
    private lateinit var mEventChannel: EventSink
    private lateinit var scheduleAppointmentChannel: EventSink
    private lateinit var mSpeechToTextEventChannel: EventSink
    private lateinit var BLEEventChannel: EventSink
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
    private var finalWords: String? = null

    private val STATE_START = 0
    private val STATE_READY = 1
    private val STATE_DONE = 2
    private val STATE_FILE = 3
    private val STATE_MIC = 4


    private lateinit var _result: MethodChannel.Result
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
    private lateinit var dialog: Dialog

    //private lateinit var builder: AlertDialog.Builder
    internal lateinit var displayText: EditText
    internal lateinit var sendBtn: Button
    internal lateinit var edit_view: LinearLayout
    internal lateinit var errorTxt: TextView

    //internal lateinit var errorTxt: TextView
    internal lateinit var tryMe: LinearLayout
    internal lateinit var listeningLayout: LinearLayout
    internal lateinit var tryAgain: ImageView
    internal lateinit var customLayout: View
    internal lateinit var spin_kit: SpinKitView
    internal lateinit var close: ImageView
    internal lateinit var micOn: ImageView

    private val REMINDER_CHANNEL = "android/notification"
    private val REMINDER_METHOD_NAME = "addReminder"
    private val CANCEL_REMINDER_METHOD_NAME = "removeReminder"
    var alarmManager: AlarmManager? = null

    var elapsedTime = 3000

    private val REQUEST_CODE_OPEN_GPS = 1
    private val REQUEST_CODE_PERMISSION_LOCATION = 2

    private val DEVICE_SPO2 = 1
    private val DEVICE_TEMP = 2
    private val DEVICE_WT = 3
    private val DEVICE_BP = 4
    private val DEVICE_BGL = 5

    var autoRepeatScan = 1

    var postBleData: String? = null

    var scanningBleTimer = Timer()

    var bleName: String? = null

    private var mOHQDeviceManager: OHQDeviceManager? = null

    private val ARG_MODE = "ARG_MODE"
    private val ARG_ADDRESS = "ARG_ADDRESS"
    private val ARG_OPTION = "ARG_OPTION"
    private val ARG_PARTIAL_HISTORY_DATA = "ARG_PARTIAL_HISTORY_DATA"

    private val CONNECTION_WAIT_TIME: Long = 60000
    private var mSessionController: SessionController? = null

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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setAutoInitEnabled(true)
        registerReceiver(broadcastReceiver, IntentFilter("INTERNET_LOST"));
        fullyInitialize()
        FacebookSdk.setIsDebugEnabled(true)
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
        setAutoLogAppEventsEnabled(true)
        AppEventsLogger.newLogger(this).logEvent("started")
        // Get user consent

        val target: Uri? = getIntent().getData()
        Log.e("deeplink", "onCreate: " + target)
        if (target != null) {
            mEventChannel.success("facebookdeeplink&" + target.toString());
        } else {
            // activity was created in a normal fashion
        }
        AppLinkData.fetchDeferredAppLinkData(this) { it ->
            Log.e("deeplinks", "onCreate: " + it?.appLinkData)
            if (::mEventChannel.isInitialized) {
                mEventChannel.success("facebookdeeplink&" + it?.appLinkData);
            }
        }

        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
        val action = intent.action
        val type = intent.type
        if (Intent.ACTION_SEND == action && type != null) {
            if (Constants.TXT_PLAIN == type) {
                handleSendText(intent) // Handle text being sent
            }
        }
        //registerReceiver(smsBroadcastReceiver,
        //IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))

//        builder = AlertDialog.Builder(context)
//        builder.setCancelable(true)
        dialog = Dialog(this)
        customLayout = layoutInflater.inflate(R.layout.progess_dialog, null)
        displayText = customLayout.findViewById(R.id.displayTxt)
        sendBtn = customLayout.findViewById(R.id.send)
        edit_view = customLayout.findViewById(R.id.edit_view)
        errorTxt = customLayout.findViewById(R.id.errorTxt)
        spin_kit = customLayout.findViewById(R.id.spin_kit)
        tryMe = customLayout.findViewById(R.id.tryMe)
        listeningLayout = customLayout.findViewById(R.id.listeningLayout)
        tryAgain = customLayout.findViewById(R.id.tryAgain)
        close = customLayout.findViewById(R.id.close)
        micOn = customLayout.findViewById(R.id.micOn)
        //builder.setView(customLayout)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setContentView(customLayout)
        dialog.setCancelable(false)
        //dialog = builder.create()
        //dialog.setInverseBackgroundForced(true)
        //dialog.window?.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
        dialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        close.setOnClickListener {
            speechRecognizer!!.cancel()
            if (dialog.isShowing) {
                try {
                    _result.let {
                        _result.success("")
                    }
                } catch (e: Exception) {
                    print(e.printStackTrace())
                }
                dialog.dismiss()
                spin_kit.visibility = View.VISIBLE
            }
        }
        //builder.show()

        sendBtn.setOnClickListener {
            speechRecognizer!!.cancel()
            if (displayText.text.toString().trim() == "") {
                displayText.clearFocus()
                val toast = Toast.makeText(context, "Please enter a valid input", Toast.LENGTH_LONG)
                toast.setGravity(Gravity.CENTER, 0, 0)
                toast.show()
            } else {
                _result.success(displayText.text.toString())
                dialog.dismiss()
                spin_kit.visibility = View.VISIBLE
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

        mSessionController = SessionController(this, null)


    }

    var broadcastReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            Log.e("mainActivitycalled", "mainActivitycalled")
            if (::scheduleAppointmentChannel.isInitialized) {
                scheduleAppointmentChannel.success("scheduleAppointment|success")
            }
        }
    }


    /* override fun onStop() {
         super.onStop()
         unregisterReceiver(smsBroadcastReceiver)
     }*/

    fun GetDeviceDataJson(Status: String, deviceType: Int, v1: Int, v2: Int, v3: Int): String? {
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
                DataToPost += v1
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
                DataToPost += " \"Bgl\" : \""
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

    private fun checkPermissionStartScan(isFromBp: Boolean) {
        try {
            val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
            if (!bluetoothAdapter.isEnabled) {
                if (::BLEEventChannel.isInitialized) {
                    BLEEventChannel.success("enablebluetooth|Please turn on your bluetooth")
                }
                //bluetoothFlutterResult.success("enablebluetooth|please enable bluetooth")
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
        val locationManager = this.getSystemService(LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }


    var uploaded = 0
    fun sendPost(Status: String, deviceType: Int, v1: Int, v2: Int, v3: Int) {
        try {
            postBleData = GetDeviceDataJson(Status, deviceType, v1, v2, v3)
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
            scanningBleTimer.cancel()
            Handler().postDelayed({
                if (BleManager.getInstance() != null) {
                    BleManager.getInstance().cancelScan()
                }
            }, 1000)
        } catch (ex: Exception) {
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

    }

    private fun startScan() {
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
                    if (DevName == "GSH601" || DevName == "Mike") {
                        stopScan()
                        connectToSPO2(bleDevice)
                    }
                    if (DevName == "GSH_862B") {
                        stopScan()
                        connectToBP(bleDevice)
                    }
                    if (DevName == "GSH230") {
                        stopScan()
                        connectToWT(bleDevice)
                    }
                    if (DevName == "GSH BH") {
                        stopScan()
                        connectToTEMP(bleDevice)
                    }
                    if (DevName == "GSH_BGM902") {
                        stopScan()
                        connectToBGL(bleDevice)
                    }

                    // BP DEVICE SCANNING
                    if (DevName.lowercase(Locale.getDefault()).contains("blesmart")) {
                        stopScan()
                        getBpAddress(bleDevice.mac);
                    }
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
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("macid|" + bleMacId)
                            }
                            //Toast.makeText(applicationContext, "" + bleName + " connected successfully!!!" , Toast.LENGTH_LONG).show();
                            sendPost("deviceConnected", DEVICE_SPO2, 0, 0, 0)
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("bleDeviceType|" + bleDeviceType)
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
                            if (::BLEEventChannel.isInitialized) {
                                BLEEventChannel.success("connected|" + bleName + " connected successfully!!!")
                            }
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
            Toast.makeText(this@MainActivity, ex.localizedMessage, Toast.LENGTH_SHORT).show()
        }

    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

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
                            val consentIntent =
                                extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ROUTE_CHANNEL
        ).setMethodCallHandler { call, result ->
            try {
                if (call.method!!.contentEquals(Constants.FUN_GET_MY_ROUTE)) {
                    result.success(sharedValue)
                    sharedValue = null
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                print(e.printStackTrace())
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

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {
                    mEventChannel = events!!
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
                }

                override fun onCancel(arguments: Any?) {
                }
            }
        )

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Constants.Appointment_EVE_STREAM
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {
                    scheduleAppointmentChannel = events!!
                }

                override fun onCancel(arguments: Any?) {
                }
            }
        )


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            VERSION_CODES_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_APP_VERSION) {
                //logics to get version code
                val appVersion = getAppVersion()
                result.success(appVersion)
            } else {
                result.notImplemented()
            }
        }

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
            SECURITY_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == Constants.FUN_KEY_GAURD) {
                //logics to show security methods
                _securityResult = result
                secureMe()
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
                val lang_code =
                    call.argument<String>(Constants.PROP_LANG_CODE) //todo uncomment this line
                _result = result
                speakWithVoiceAssistant(lang_code!!) //todo uncomment this line
                //speakWithVoiceAssistant()//todo line need to remove
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
            REMINDER_CHANNEL
        ).setMethodCallHandler { call, result ->
            try {
                if (call.method == REMINDER_METHOD_NAME) {
                    val data = call.argument<String>("data")
                    val retMap: Map<String, Any> = Gson().fromJson(
                        data, object : TypeToken<HashMap<String?, Any?>?>() {}.type
                    )

                    heyKindlyRemindMe(retMap)
                    result.success("success")
                } else if (call.method == CANCEL_REMINDER_METHOD_NAME) {
                    val data = call.argument<String>("data")
                    data?.let { heyCancelMyReminder(it) }
                    result.success("success")
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                print("exception" + e.message)
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
            BLECONNECT
        ).setMethodCallHandler { call, result ->
            if (call.method == "bleconnect") {
                // bluetoothFlutterResult=result
                Log.d("BLE VITALS", "StartingPoint")
                BleManager.getInstance().init(application)
                BleManager.getInstance()
                    .enableLog(true)
                    .setReConnectCount(1, 5000)
                    .setConnectOverTime(20000).operateTimeout = 5000

                val temp = checkPermissionStartScan(false)

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
                stopScan()
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
                checkPermissionStartScan(true)
            }
        }

        MethodChannel(
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
        }

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
            APPOINTMENT_TIME
        ).setMethodCallHandler { call, result ->
            if (call.method == APPOINTMENT_TIME) {
                Log.d("APPOINTMENT_TIME", "APPOINTMENT_TIME")
                try {
                    val data = call.argument<String>("data")
                    val retMap: Map<String, Any> = Gson().fromJson(
                        data, object : TypeToken<HashMap<String?, Any?>?>() {}.type
                    )

                    scheduleAppointment(retMap)
                    result.success("success")

                } catch (e: Exception) {
                    Log.d("Catch", "" + e.toString())
                }
            }
        }

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
        mOHQDeviceManager = OHQDeviceManager.sharedInstance()
        val scanFilter: MutableList<OHQDeviceCategory> = ArrayList()
        //if (null != filteringDeviceCategory) {
        //AppLog.d("filteringDeviceCategory:$filteringDeviceCategory")
        scanFilter.add(OHQDeviceCategory.BloodPressureMonitor)
        //}
        mOHQDeviceManager!!.scanForDevicesWithCategories(
            scanFilter,
            ScanObserverBlock { deviceInfo ->
                /*mHandler.post(Runnable { _onScan(deviceInfo) })*/
                mOHQDeviceManager!!.stopScan()
                Log.e("Scan List response", "" + deviceInfo.toString())

                parseScanListJson(deviceInfo)

            },
            CompletionBlock { reason -> /*mHandler.post(Runnable { _onScanCompletion(reason) })*/
                Log.e(
                    "reason: ",
                    "" + reason.toString()
                )
            })
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
        mSessionController!!.setConfig(getConfig(context))
        mOption[OHQSessionOptionKey.ReadMeasurementRecordsKey] = true
        mOption[OHQSessionOptionKey.ConnectionWaitTimeKey] = CONNECTION_WAIT_TIME
        mSessionController!!.startSession(mAddress, mOption)
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
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            connectivityManager.unregisterNetworkCallback(mNetworkCallback)
        }
        return 1
    }

    private val mNetworkCallback = object : ConnectivityManager.NetworkCallback() {
        @RequiresApi(Build.VERSION_CODES.M)
        override fun onAvailable(network: Network) {
            //phone is connected to wifi network
            val connectivityManager =
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
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
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

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
            var wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
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

    fun handleSendText(intent: Intent) {
        sharedValue = intent.getStringExtra(Intent.EXTRA_TEXT)
        username = intent.getStringExtra(getString(R.string.username))
        docId = intent.getStringExtra(Constants.PROP_docId)
        docPic = intent.getStringExtra(getString(R.string.docPic))
        bookingId = intent.getStringExtra(Constants.PROP_BookingId)
        appDate = intent.getStringExtra(Constants.PROP_PlannedStartTime)
        docSessionId = intent.getStringExtra(Constants.PROP_docSessionId)
        healthOrgId = intent.getStringExtra(Constants.PROP_healthOrgId)
        templateName = intent.getStringExtra(Constants.PROP_TEMP_NAME)
        val providerReqId = intent.getStringExtra(Constants.PROP_PROVIDER_REQID)
        var redirect_to = intent.getStringExtra(Constants.PROP_REDIRECT_TO)
        val claimId = intent.getStringExtra(Constants.PROP_CLAIM_ID)
        val patientPhoneNumber = intent.getStringExtra(Constants.PATIENT_PHONE_NUMBER)
        val verificationCode = intent.getStringExtra(Constants.VERIFICATION_CODE)
        val caregiverRequestor = intent.getStringExtra(Constants.CAREGIVER_REQUESTER)
        val caregiverReceiver = intent.getStringExtra(Constants.CAREGIVER_RECEIVER)
        val uid = intent.getStringExtra(Constants.UID)
        val type = intent.getStringExtra("type")

        val data = intent.getStringExtra(Constants.PROP_DATA)
        val prescriptionId = intent.getStringExtra(Constants.PROP_PRESCRIPTION_ID)
        val HRMId = intent.getStringExtra(Constants.PROP_HRMID)
        val EVEId = intent.getStringExtra(Constants.PROP_EVEID)
        val patientName = intent.getStringExtra(Constants.PROB_PATIENT_NAME)
        val careGiverMemberId = intent.getStringExtra(Constants.PROP_CAREGIVER_REQUESTOR)
        val careCoordinatorUserId = intent.getStringExtra(Constants.CARE_COORDINATOR_USER_ID)
        val careGiverName = intent.getStringExtra(Constants.CARE_GIVER_NAME)
        val activityTime = intent.getStringExtra(Constants.ACTIVITY_TIME)
        val activityName = intent.getStringExtra(Constants.ACTIVITY_NAME)
        val doctorID = intent.getStringExtra(getString(R.string.docId))
        val docName = intent.getStringExtra(getString(R.string.docName))
        val senderId = intent.getStringExtra(getString(R.string.senderId))
        val senderName = intent.getStringExtra(getString(R.string.senderName))
        val senderProfile = intent.getStringExtra(getString(R.string.senderProfilePic))
        val notificationListId = intent.getStringExtra(getString(R.string.notificationListId))
        val groupId = intent.getStringExtra(getString(R.string.chatListId))
        val rawTitle = intent.getStringExtra(Constants.PROP_RAWTITLE)
        val rawBody = intent.getStringExtra(Constants.PROP_RAWBODY)
        patId = intent.getStringExtra(getString(R.string.pat_id))
        patName = intent.getStringExtra(getString(R.string.pat_name))
        patPic = intent.getStringExtra(getString(R.string.pat_pic))
        val message = intent.getStringExtra(getString(R.string.message))
        var externalLink = intent.getStringExtra(Constants.PROB_EXTERNAL_LINK)
        var planId = intent.getStringExtra(Constants.PROP_PLANID)
        var callType = intent.getStringExtra(getString(R.string.callType))
        var userId = intent.getStringExtra(Constants.PROB_USER_ID)
        var isWeb = intent.getStringExtra(getString(R.string.web))
        var appLog = intent.getStringExtra(getString(R.string.ns_type_applog))
        val appointmentID = intent.getStringExtra(Constants.APPOINTMENTID)
                val createdBy = intent.getStringExtra(Constants.CREATEDBY)


        if (sharedValue != null && sharedValue == "chat") {
            sharedValue =
                "${Constants.PROP_ACK}&$sharedValue&${senderId}&${senderName}&${senderProfile}&${groupId}"
        } else if (redirect_to == "claimList") {
            sharedValue = "${redirect_to}&${claimId}&${userId}"
        } else if (redirect_to?.contains("myRecords") == true) {

            sharedValue = "ack&${redirect_to}&${userId}&${patientName}"
        } else if (redirect_to?.contains("escalateToCareCoordinatorToRegimen") == true) {

            sharedValue =
                "ack&${redirect_to}&${careCoordinatorUserId}&${patientName}&${careGiverName}&${activityTime}&${activityName}&${userId}&${uid}&${patientPhoneNumber}"
        } else if (redirect_to?.contains("appointmentPayment") == true) {

            sharedValue = "ack&${redirect_to}&${appointmentID}"
        } else if (redirect_to?.contains("familyMemberCaregiverRequest") == true) {
        }
        else if(redirect_to?.contains("mycart") == true){

            sharedValue = "ack&${redirect_to}&${userId}&${createdBy}&${bookingId}"
        }
        else if (redirect_to?.contains("familyMemberCaregiverRequest") == true) {

            sharedValue =
                "ack&${redirect_to}&${type}&${patientPhoneNumber}&${verificationCode}&${caregiverReceiver}&${caregiverRequestor}"
        } else if (redirect_to?.contains("communicationSetting") == true) {

            sharedValue = "ack&${redirect_to}"
        } else if (redirect_to?.contains("careGiverMemberProfile") == true) {

            sharedValue = "ack&${redirect_to}&${careGiverMemberId}"
        } else if (redirect_to?.contains("communicationSetting") == true) {

            sharedValue = "ack&${redirect_to}"
        } else if (externalLink != null && externalLink != "") {
            if (!externalLink.startsWith("http://") && !externalLink.startsWith("https://"))
                externalLink = "http://" + externalLink
            sharedValue = "openurl&$externalLink"
        } else if (sharedValue != null && username != null && docId != null && docPic != null && callType != null && isWeb != null) {
            sharedValue =
                "$sharedValue&$username&$docId&$docPic&${Constants.PROP_CALL}&${patId}&${patName}&${patPic}&${callType}&${isWeb}"
        } else if (sharedValue == Constants.PROP_DOC_RESCHDULE) {
            //todo redirect to telehealth page
            sharedValue =
                "${Constants.PROP_DOC_RESCHDULE}&${docId!!}&${bookingId}&${docSessionId}&${healthOrgId}&${templateName}"
        } else if (sharedValue == Constants.PROP_DOC_CANCELLATION) {
            //todo redirect to telehealth page
            sharedValue =
                "${Constants.PROP_DOC_CANCELLATION}&${bookingId!!}&${appDate}&${templateName}"
        } else if (providerReqId != null && providerReqId != "") {
            if (sharedValue == Constants.PROP_ACCEPT) {
                sharedValue = "$sharedValue&${providerReqId}&${"accepted"}"
            } else {
                sharedValue = "$sharedValue&${providerReqId}&${"rejected"}"
            }
        } else if (data != null && ((data == "DoctorPatientAssociation") || (data == "QurplanCargiverPatientAssociation"))) {
            sharedValue =
                "${Constants.PROP_ACK}&${redirect_to!!}&${"$doctorID|$docName|$docPic|$patId|$patName|$patPic|$message"}"
        } else if (data != null && data == "MissingActivitiesReminder") {
            sharedValue = "${Constants.PROP_ACK}&${redirect_to!!}&${EVEId}"
        } else if ((planId != null && planId != "") && (templateName != null && templateName != "") && (userId != null && userId != "") && (patName != null && patName != "")) {
            if ((sharedValue == Constants.PROP_RENEW) || (sharedValue == Constants.PROP_CALLBACK)) {
                sharedValue = "$sharedValue&${planId}&${"$templateName"}&${userId}&${patName}"
            } else if (redirect_to == Constants.MY_PLAN_DETAILS) {
                sharedValue = "myplandetails&${planId}&${"$templateName"}&${userId}&${patName}"
            }
        } else if (appLog != null && appLog == "FETCH_LOG") {
            sharedValue = appLog
        } else {
            if (HRMId != null && HRMId != "") {
                sharedValue = "${Constants.PROP_ACK}&${redirect_to!!}&${HRMId}"
            } else if (data != null) {
                sharedValue = "${Constants.PROP_ACK}&${redirect_to!!}&${data}"
            } else {
                if (redirect_to != null) {
                    if (redirect_to.contains("sheela")) {
                        var redirectArray = redirect_to.split("|")
                        if (redirectArray.size > 1 && redirectArray[1] == "pushMessage") {
                            sharedValue =
                                "${Constants.PROP_ACK}&${"sheela"}&${"$rawTitle|$rawBody"}&${notificationListId}"
                        } else {
                            sharedValue = "${Constants.PROP_ACK}&${redirect_to}&${""}"
                        }
                    } else {
                        sharedValue = "${Constants.PROP_ACK}&${redirect_to}&${""}"
                    }
                }


            }

        }
        Log.e("MainActivity", "dataIntent: " + sharedValue)
        if (::mEventChannel.isInitialized) {
            mEventChannel.success(sharedValue)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val action = intent.action
        val type = intent.type
        if (Intent.ACTION_SEND == action && type != null) {
            if (Constants.TXT_PLAIN == type) {
                handleSendText(intent) // Handle text being sent
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(broadcastReceiver);
        val serviceIntent = Intent(this, AVServices::class.java)
        stopService(serviceIntent)
        speechRecognizer!!.destroy()
        MyApp.snoozeTapCountTime = 0
    }

    val handler: Handler = Handler()
    val runnable = Runnable {
//        if (dialog.isShowing) {
//            dialog.dismiss()
//        }
    }

    //todo this method need to uncomment
    private fun speakWithVoiceAssistant(langCode: String) {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        intent.putExtra(
            RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
        )
        //intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault()) //todo this has to be comment
        GetSrcTargetLanguages()
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, langCode) //todo this has to be uncomment
        intent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
        intent.addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT)
        intent.putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_MINIMUM_LENGTH_MILLIS, 50000000)
        intent.putExtra(
            RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS,
            50000000
        )
        intent.putExtra(
            RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS,
            50000000
        )
        //intent.putExtra(RecognizerIntent.EXTRA_PROMPT, Constants.VOICE_ASST_PROMPT)

        //Timer().schedule(100){
        try {
            //startActivityForResult(intent, REQ_CODE)
            speechRecognizer!!.setRecognitionListener(object : RecognitionListener {
                override fun onReadyForSpeech(bundle: Bundle) {}
                override fun onBeginningOfSpeech() {
                    if (!dialog.isShowing) {
                        this@MainActivity.runOnUiThread(
                            object : Runnable {
                                override fun run() {
                                    //displayText.text = "Speak now"
                                    micOn.visibility = View.VISIBLE
                                    edit_view.visibility = View.GONE
                                    listeningLayout.visibility = View.VISIBLE
                                    tryMe.visibility = View.GONE
                                }
                            }
                        )

                        dialog.show()
                    }
                }

                override fun onRmsChanged(v: Float) {}
                override fun onBufferReceived(bytes: ByteArray) {}
                override fun onEndOfSpeech() {
                    if (finalWords != null && finalWords?.length!! > 0 && finalWords != "") {
                        //dialog.dismiss()
                    } else if (finalWords == "") {
                        //do nothing
                    } else if (isPartialResultInvoked == true) {
                        //do nothing
                    } else {
                        this@MainActivity.runOnUiThread(
                            object : Runnable {
                                override fun run() {
                                    if (listeningLayout.visibility == View.VISIBLE) {
                                        listeningLayout.visibility = View.GONE
                                        tryMe.visibility = View.VISIBLE
                                        errorTxt.text = "Please Retry"
                                        customLayout.setOnClickListener {
                                            this@MainActivity.runOnUiThread(
                                                object : Runnable {
                                                    override fun run() {
                                                        //displayText.text = "Speak now"
                                                        micOn.visibility = View.VISIBLE
                                                        edit_view.visibility = View.GONE
                                                        spin_kit.visibility = View.VISIBLE
                                                        listeningLayout.visibility = View.VISIBLE
                                                        tryMe.visibility = View.GONE
                                                        speechRecognizer!!.startListening(intent)
                                                    }
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        )

                    }
                }

                override fun onError(errorCode: Int) {
                    val message: String
                    when (errorCode) {
                        SpeechRecognizer.ERROR_AUDIO -> message = "Audio recording error"
                        SpeechRecognizer.ERROR_CLIENT -> message = "Client side error"
                        SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> message =
                            "Insufficient permissions"
                        SpeechRecognizer.ERROR_NETWORK -> message = "Network error"
                        SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> message = "Network timeout"
                        SpeechRecognizer.ERROR_NO_MATCH -> message = "No match"
                        SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> message =
                            "RecognitionService busy"
                        SpeechRecognizer.ERROR_SERVER -> message = "error from server"
                        SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> message = "No speech input"
                        else -> {
                            message = "Didn't understand, please try again."
                        }
                    }
                    this@MainActivity.runOnUiThread(
                        object : Runnable {
                            override fun run() {
                                //Toast.makeText(this@MainActivity, message, Toast.LENGTH_LONG).show()
                            }
                        }
                    )
                }

                override fun onResults(bundle: Bundle) {
                    val data = bundle.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    if (data != null && data.size > 0) {
                        finalWords = data[0].toString()
                        isPartialResultInvoked = false
                        //_result.success(finalWords)
                        if (finalWords != null && finalWords?.length!! > 0 && finalWords != "") {
                            handler.postDelayed(runnable, 1000)
                            //dialog.dismiss()
                            spin_kit.visibility = View.GONE
                            displayText.setText(finalWords)
                            finalWords = null
                        } else if (finalWords == "") {
                            //do nothing
                        } else {
                            this@MainActivity.runOnUiThread(
                                object : Runnable {
                                    override fun run() {
                                        if (listeningLayout.visibility == View.VISIBLE) {
                                            listeningLayout.visibility = View.GONE
                                            tryMe.visibility = View.VISIBLE
                                            errorTxt.text = "Please Retry"
                                            customLayout.setOnClickListener {
                                                this@MainActivity.runOnUiThread(
                                                    object : Runnable {
                                                        override fun run() {
                                                            //displayText.text = "Speak now"
                                                            micOn.visibility = View.VISIBLE
                                                            edit_view.visibility = View.GONE
                                                            listeningLayout.visibility =
                                                                View.VISIBLE
                                                            tryMe.visibility = View.GONE
                                                            speechRecognizer!!.startListening(intent)
                                                        }
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }
                            )
                        }
                    } else {
                        this@MainActivity.runOnUiThread(
                            object : Runnable {
                                override fun run() {
                                    if (listeningLayout.visibility == View.VISIBLE) {
                                        listeningLayout.visibility = View.GONE
                                        tryMe.visibility = View.VISIBLE
                                        errorTxt.text = "Please Retry"
                                        customLayout.setOnClickListener {
                                            this@MainActivity.runOnUiThread(
                                                object : Runnable {
                                                    override fun run() {
                                                        //displayText.text = "Speak now"
                                                        micOn.visibility = View.VISIBLE
                                                        edit_view.visibility = View.GONE
                                                        listeningLayout.visibility =
                                                            View.VISIBLE
                                                        tryMe.visibility = View.GONE
                                                        speechRecognizer!!.startListening(intent)
                                                    }
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        )
                    }
                }

                override fun onPartialResults(bundle: Bundle) {
                    val data = bundle.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    if (data != null && data.size > 0) {
                        finalWords = data[0].toString()
                        isPartialResultInvoked = true
                        this@MainActivity.runOnUiThread(
                            object : Runnable {
                                override fun run() {
                                    if (micOn.isShown) {
                                        this@MainActivity.runOnUiThread(
                                            object : Runnable {
                                                override fun run() {
                                                    edit_view.visibility = View.VISIBLE
                                                    micOn.visibility = View.GONE
                                                }
                                            }
                                        )
                                    }
                                    displayText.setText(finalWords)
                                }
                            }
                        )
                    }
                }

                override fun onEvent(i: Int, bundle: Bundle) {}
            })
            speechRecognizer!!.startListening(intent)
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

    private fun secureMe() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            val km: KeyguardManager =
                getSystemService(android.content.Context.KEYGUARD_SERVICE) as KeyguardManager
            if (km.isKeyguardSecure) {
                //user has set pin/password/pattern
                val authIntent: Intent = km.createConfirmDeviceCredentialIntent(
                    Constants.KEY_GAURD_TITLE,
                    Constants.KEY_GAURD_TITLE_DESC
                )
                startActivityForResult(authIntent, INTENT_AUTHENTICATE)
            } else {
                //user has not enabled any password/pin/pattern
                _securityResult.success(1004)
                return
            }
        } else {
            //there is no key guard feature below Android 5.0
            _securityResult.success(1000)
            return
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

    private fun getAppVersion(): String {
        val versionCode: Int = BuildConfig.VERSION_CODE
        val versionName: String = BuildConfig.VERSION_NAME

        return "v$versionName b$versionCode"
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

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun heyKindlyRemindMe(data: Map<String, Any>) {
        val title: String = data["title"] as String
        val body: String = data["description"] as String
        val nsId = data["eid"] as String
        val eDateTime: String = data["estart"] as String  //2021-04-20 06:10:00
        val remindin: String = data["remindin"] as String
        val remindBefore: String = data["remindbefore"] as String
        val importance: String = data["importance"] as String
        val date: String = eDateTime.split(" ")[0]
        val time: String = eDateTime.split(" ")[1]
        val alarmHour = time.split(":")[0].toInt()
        val alarmMin = time.split(":")[1].toInt()
        val alarmDate = date.split("-")[2].toInt()
        val alarmMonth = date.split("-")[1].toInt()
        val alarmYear = date.split("-")[0].toInt()
        val reminderBroadcaster = Intent(this, ReminderBroadcaster::class.java)
        reminderBroadcaster.putExtra("title", title)
        reminderBroadcaster.putExtra("body", body)
        /*reminderBroadcaster.putExtra("nsid", nsId.toInt())*/
        reminderBroadcaster.putExtra("isCancel", false)
        createNotificationChannel(importance)
        var channelId = ""
        if (importance == "2") {
            channelId = "schedule_v3"
        } else {
            channelId = "schedule"
        }
        if (remindBefore.toInt() > 0) {
            // Set the alarm to start for specific time
            val calendar: Calendar = Calendar.getInstance().apply {
                timeInMillis = System.currentTimeMillis()
                set(Calendar.YEAR, alarmYear)
                set(Calendar.MONTH, alarmMonth - 1)
                set(Calendar.DAY_OF_MONTH, alarmDate)
                set(Calendar.HOUR_OF_DAY, alarmHour)
                set(Calendar.MINUTE, alarmMin)
                set(Calendar.SECOND, 0)
            }

            calendar.add(Calendar.MINUTE, -remindBefore.toInt())

            //check the reminder time with current time if its true allow user to create alaram
            if (calendar.timeInMillis > Calendar.getInstance().timeInMillis) {
                val eIdAppend = "${nsId}${"000"}"
                val notificationAndAlarmId = NotificationID.currentMillis
                SharedPrefUtils().saveAlarmId(this, eIdAppend, notificationAndAlarmId)
                createNotifiationBuilder(
                    title,
                    body,
                    eIdAppend,
                    notificationAndAlarmId,
                    calendar.timeInMillis,
                    false,
                    false,
                    channelId
                )
            }
        }

        // Set the alarm to start for specific time
        val calendar: Calendar = Calendar.getInstance().apply {
            timeInMillis = System.currentTimeMillis()
            set(Calendar.YEAR, alarmYear)
            set(Calendar.MONTH, alarmMonth - 1)
            set(Calendar.DAY_OF_MONTH, alarmDate)
            set(Calendar.HOUR_OF_DAY, alarmHour)
            set(Calendar.MINUTE, alarmMin)
            set(Calendar.SECOND, 0)
        }

        //check the reminder time with current time if its true allow user to create alaram
        if (calendar.timeInMillis > Calendar.getInstance().timeInMillis) {
            val notificationAndAlarmId = NotificationID.currentMillis
            SharedPrefUtils().saveAlarmId(this, nsId, notificationAndAlarmId)
            createNotifiationBuilder(
                title,
                body,
                nsId,
                notificationAndAlarmId,
                calendar.timeInMillis,
                false,
                true,
                channelId
            )
        }

        if (remindin.toInt() > 0) {
            // Set the alarm to start for specific time
            val calendar: Calendar = Calendar.getInstance().apply {
                timeInMillis = System.currentTimeMillis()
                set(Calendar.YEAR, alarmYear)
                set(Calendar.MONTH, alarmMonth - 1)
                set(Calendar.DAY_OF_MONTH, alarmDate)
                set(Calendar.HOUR_OF_DAY, alarmHour)
                set(Calendar.MINUTE, alarmMin)
                set(Calendar.SECOND, 0)
            }

            calendar.add(Calendar.MINUTE, remindin.toInt())

            //check the reminder time with current time if its true allow user to create alaram
            if (calendar.timeInMillis > Calendar.getInstance().timeInMillis) {
                val eIdAppend = "${nsId}${"111"}"
                val notificationAndAlarmId = NotificationID.currentMillis
                SharedPrefUtils().saveAlarmId(this, eIdAppend, notificationAndAlarmId)
                createNotifiationBuilder(
                    title,
                    body,
                    eIdAppend,
                    notificationAndAlarmId,
                    calendar.timeInMillis,
                    false,
                    false,
                    channelId
                )
            }
        }

    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun scheduleAppointment(data: Map<String, Any>) {

        val remindBefore = "5"
        val nsId = data["eid"] as String
        val eDateTime: String = data["estart"] as String
        val eDateReplace: String = eDateTime.replace("T", " ")
        val date: String = eDateReplace.split(" ")[0]
        val time: String = eDateReplace.split(" ")[1]
        val alarmHour = time.split(":")[0].toInt()
        val alarmMin = time.split(":")[1].toInt()
        val alarmDate = date.split("-")[2].toInt()
        val alarmMonth = date.split("-")[1].toInt()
        val alarmYear = date.split("-")[0].toInt()

        // Set the alarm to start for specific time
        val calendar: Calendar = Calendar.getInstance().apply {
            timeInMillis = System.currentTimeMillis()
            set(Calendar.YEAR, alarmYear)
            set(Calendar.MONTH, alarmMonth - 1)
            set(Calendar.DAY_OF_MONTH, alarmDate)
            set(Calendar.HOUR_OF_DAY, alarmHour)
            set(Calendar.MINUTE, alarmMin)
            set(Calendar.SECOND, 0)
        }

        calendar.add(Calendar.MINUTE, -remindBefore.toInt())

        //check the reminder time with current time if its true allow user to create alaram
        if (calendar.timeInMillis > Calendar.getInstance().timeInMillis) {
            val eIdAppend = "${nsId}${"000"}"
            val notificationAndAlarmId = NotificationID.currentMillis
            SharedPrefUtils().saveAlarmId(this, eIdAppend, notificationAndAlarmId)
            createScheduleAppointment(
                notificationAndAlarmId,
                calendar.timeInMillis,
            )
        }

    }

    @SuppressLint("LaunchActivityFromNotification")
    private fun createNotifiationBuilder(
        title: String,
        body: String,
        eId: String,
        nsId: Int,
        currentMillis: Long,
        isCancel: Boolean,
        isButtonShown: Boolean,
        channelId: String
    ) {
        try {
            val _sound: Uri =
                Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + this.packageName + "/" + R.raw.msg_tone)

            val dismissIntent = Intent(this, DismissReceiver::class.java)
            dismissIntent.putExtra(ReminderBroadcaster.NOTIFICATION_ID, nsId)
            val dismissPendingIntent = PendingIntent.getBroadcast(
                this,
                nsId,
                dismissIntent,
                PendingIntent.FLAG_CANCEL_CURRENT
            )
            val snoozeIntent = Intent(this, SnoozeReceiver::class.java)
            snoozeIntent.putExtra(ReminderBroadcaster.NOTIFICATION_ID, nsId)
            snoozeIntent.putExtra(this.getString(R.string.currentMillis), currentMillis)
            snoozeIntent.putExtra(this.getString(R.string.title), title)
            snoozeIntent.putExtra(this.getString(R.string.body), body)
            val snoozePendingIntent = PendingIntent.getBroadcast(
                this,
                nsId,
                snoozeIntent,
                PendingIntent.FLAG_CANCEL_CURRENT
            )


            val onTapNS = Intent(this, OnTapNotification::class.java)
            onTapNS.putExtra("nsid", nsId)
            onTapNS.putExtra("meeting_id", "")
            onTapNS.putExtra("username", "")
            //onTapNS.putExtra(getString(R.string.username), "$USER_NAME")
            onTapNS.putExtra(Constants.PROP_DATA, "")
            onTapNS.putExtra(Constants.PROP_REDIRECT_TO, "regiment_screen")
            onTapNS.putExtra(Constants.PROP_HRMID, "")
            val onTapPendingIntent =
                PendingIntent.getBroadcast(this, nsId, onTapNS, PendingIntent.FLAG_CANCEL_CURRENT)
            val builder: NotificationCompat.Builder
            if (isButtonShown) {
                builder = NotificationCompat.Builder(context, channelId)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setLargeIcon(
                        BitmapFactory.decodeResource(
                            context.resources,
                            R.mipmap.ic_launcher
                        )
                    )
                    .setContentTitle(title)
                    .setContentText(body)
                    .setContentIntent(onTapPendingIntent)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .addAction(R.drawable.ic_close, "Dismiss", dismissPendingIntent)
                    .addAction(R.drawable.ic_snooze, "Snooze", snoozePendingIntent)
                    .setAutoCancel(true)
                    .setOnlyAlertOnce(false)
            } else {
                builder = NotificationCompat.Builder(context, channelId)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setLargeIcon(
                        BitmapFactory.decodeResource(
                            context.resources,
                            R.mipmap.ic_launcher
                        )
                    )
                    .setContentTitle(title)
                    .setContentText(body)
                    .setContentIntent(onTapPendingIntent)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .setAutoCancel(true)
                    .setOnlyAlertOnce(false)
            }
            val notification: Notification = builder.build()
            val notificationIntent = Intent(this, ReminderBroadcaster::class.java)
            notificationIntent.putExtra(ReminderBroadcaster.NOTIFICATION_ID, nsId)
            notificationIntent.putExtra(ReminderBroadcaster.NOTIFICATION, notification)
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                nsId,
                notificationIntent,
                PendingIntent.FLAG_CANCEL_CURRENT
            )
            val alarmManager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    currentMillis,
                    pendingIntent
                )
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, currentMillis, pendingIntent)
            }

        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }
    }

    @SuppressLint("LaunchActivityFromNotification")
    private fun createScheduleAppointment(
        nsId: Int,
        currentMillis: Long,
    ) {
        try {

            val notificationIntent = Intent(this, ScheduleAppointment::class.java)
            notificationIntent.putExtra(ScheduleAppointment.NOTIFICATION_ID, nsId)

            val pendingIntent = PendingIntent.getBroadcast(
                this,
                nsId,
                notificationIntent,
                PendingIntent.FLAG_CANCEL_CURRENT
            )
            val alarmManager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    currentMillis,
                    pendingIntent
                )
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, currentMillis, pendingIntent)
            }

        } catch (e: Exception) {
            Log.e("crash", e.message.toString())
        }
    }

    private fun createNotificationChannel(importanceChannel: String) {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Reminder Channel"
            val descriptionText = "Scheduled Notification"
            val importance = NotificationManager.IMPORTANCE_HIGH
            var channelId = ""
            var ack_sound: Uri? = null
            if (importanceChannel == "2") {
                channelId = "schedule_v3"
                ack_sound =
                    Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/raw/beep_beep")
            } else {
                channelId = "schedule"
                ack_sound =
                    Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + R.raw.msg_tone)
            }
            var channel = NotificationChannel(channelId, name, importance)
            channel.description = descriptionText

            val attributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION).build()
            channel.setSound(ack_sound, attributes)
            // Register the channel with the system
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun heyCancelMyReminder(nsId: String) {
        val notificationAndAlarmId = SharedPrefUtils().getNotificationId(this, nsId)
        val reminderBroadcaster = Intent(this, ReminderBroadcaster::class.java)
        reminderBroadcaster.putExtra("nsid", notificationAndAlarmId)
        reminderBroadcaster.putExtra("isCancel", true)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            notificationAndAlarmId,
            reminderBroadcaster,
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        alarmManager.cancel(pendingIntent)
        SharedPrefUtils().deleteNotificationObject(this, notificationAndAlarmId)
    }

    private fun validateMicAvailability(): Boolean {
        var available = true
        val am: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (am.mode === AudioManager.MODE_IN_COMMUNICATION) {
            //Mic is in use
            available = false
        }
        return available
    }


    object NotificationID {
        private val atomic = AtomicInteger(0)
        val currentMillis: Int get() = System.currentTimeMillis().toInt()
//        val currentMillis : Int get() = createRandomCode(5)

        fun createRandomCode(codeLength: Int): Int {
            val chars = "1234567890".toCharArray()
            val sb = StringBuilder()
            val random: Random = SecureRandom()
            for (i in 0 until codeLength) {
                val c = chars[random.nextInt(chars.size)]
                sb.append(c)
            }
            return sb.toString().toInt()
        }
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

    override fun onConnectionStateChanged(connectionState: OHQConnectionState) {
        AppLog.vMethodIn(connectionState.name)
        //mListener!!.onConnectionStateChanged(connectionState)
    }

    override fun onSessionComplete(sessionData: SessionData) {
        AppLog.vMethodIn(sessionData.completionReason!!.name)
        mSessionAddress = null
        mSessionData = sessionData
        mSessionData.setCompletionReason(sessionData.completionReason)
        mSessionData.deviceAddress = mAddress
        Log.e("outputNative", "" + mSessionData.toString());
        if (mSessionData != null && mSessionData.measurementRecords != null && mSessionData.measurementRecords!!.size > 0) {
            _resultBp.success(mSessionData.toString())
            return
        }

        if (::BLEEventChannel.isInitialized) {
            BLEEventChannel.success("macid|" + mAddress)
        }

        if (::BLEEventChannel.isInitialized) {
            BLEEventChannel.success("bleDeviceType|" + "BP")
        }
        /*if (sessionData.completionReason!!.name == "Disconnected") {
            if (sessionData.measurementRecords!!.size > 0) {

            } else {
                transferBpData()
            }
        }*/
        //mListener!!.onSessionComplete(mSessionData)
    }

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

}

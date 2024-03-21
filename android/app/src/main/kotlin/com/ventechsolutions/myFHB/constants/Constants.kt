package com.ventechsolutions.myFHB.constants

object Constants {
    var foregroundActivityRef=false
    val FUN_LISTEN_SMS = "listenForSMS"
    val FUN_VOICE_ASST = "speakWithVoiceAssistant"
    val FUN_VALIDATE_MIC_AVAIL= "validateMicAvailability"
    val VOICE_ASST_PROMPT = "Need to speak"
    val FUN_TEXT2SPEECH = "textToSpeech"
    val KEY_GAURD_TITLE = "QurBook"
    val KEY_GAURD_TITLE_DESC = "Please Authorize to use the Application"
    val KEY_GAURD_AUTH_SUCC = 1002
    val KEY_GAURD_AUTH_FAIL = 1002
    val TXT_PLAIN = "text/plain"
    val TICKER = "Ticker values"
    val CN_VC = "flutter.native/versioncode"
    val CN_LISTEN4SMS = "flutter.native/listen4sms"
    val CN_VOICE_INTENT = "flutter.native/voiceIntent"
    val CN_TTS = "flutter.native/textToSpeech"
    val SHEELA_CHANNEL = "sheela.channel"
    val CN_ONG_NS = "ongoing_ns.channel"
    val SPEECH_TO_TEXT_STREAM = "speechToText/stream"
    val Bluetooth_EVE_STREAM = "QurbookBLE/stream"

    val FROM_LANG = "com.example.agoraflutterquickstart/stream"
    val TO_LANG = "com.example.agoraflutterquickstart/stream"
    val EN_US = "en_US"
    val START_SHEELA_LISTENING = "startSheelaListening"
    val FUN_ONG_NS = "startOnGoingNS"
    val PROP_MODE = "mode"
    val PROP_MSG = "message"
    val PROP_IS_CLOSE = "isClose"

    val PROP_START = "start"
    val PROP_STOP = "stop"
    val PROP_NAME = "name"
    val PROP_LANG_CODE = "langcode"
    val PROP_LANG = "lang"
    val WIFI_WORKS ="wifiworks"
    val BLE_CONNECT ="bleConnect"
    val DEVICES_CHANNEL ="QurbookBLE/method"
    val BP_CONNECT ="bpconnect"
    val BP_SCAN_CANCEL ="bpscancancel"
    val BP_ENABLE_CHECK ="bluetooth_enable_check"
    val LOCATION_SERVICE_CHECK ="location_service_check"
    val ENABLE_BACKGROUND_NOTIFICATION ="enablebackgroundnotification"
    val DISABLE_BACKGROUND_NOTIFICATION ="disablebackgroundnotification"
    val BP_LOCATION_CHECK ="bp_location_check"
    val BLE_SCAN_CANCEL ="bleScanCancel"
    val GET_CURRENT_LOCATION ="getCurrentLocation"

    val CRITICAL_APP_STOPPED="⚠️ CRITICAL - App Stopped";
    val CRITICAL_APP_STOPPED_DESCRIPTION="The app must be running in the background to receive alerts. Tap to re-open the app";


    val CLOSE_SHEELA_DIALOG = "closeSheelaDialog"

    val IS_NOTIFICATION_PERMISSION_CHECK ="notification_permission_check"

    val sheelaText ="Sheela"


}

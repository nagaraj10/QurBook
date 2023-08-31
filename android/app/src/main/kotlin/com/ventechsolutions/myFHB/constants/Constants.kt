package com.ventechsolutions.myFHB.constants

object Constants {
    var foregroundActivityRef=false
    val FUN_APP_VERSION = "getAppVersion"
    val FUN_LISTEN_SMS = "listenForSMS"
    val FUN_KEY_GAURD = "secureMe"
    val FUN_VOICE_ASST = "speakWithVoiceAssistant"
    val FUN_VALIDATE_MIC_AVAIL= "validateMicAvailability"
    val VOICE_ASST_PROMPT = "Need to speak"
    val FUN_TEXT2SPEECH = "textToSpeech"
    val KEY_GAURD_TITLE = "QurHome"
    val KEY_GAURD_TITLE_DESC = "Please Authorize to use the Application"
    val KEY_GAURD_AUTH_SUCC = 1002
    val KEY_GAURD_AUTH_FAIL = 1002
    val TXT_PLAIN = "text/plain"
    val TICKER = "Ticker values"
    val CN_VC = "flutter.native/versioncode"
    val CN_LISTEN4SMS = "flutter.native/listen4sms"
    val CN_VOICE_INTENT = "flutter.native/voiceIntent"
    val CN_TTS = "flutter.native/textToSpeech"
    val CN_SECURE = "flutter.native/security"
    val CN_ROUTE = "navigation.channel"
    val SHEELA_CHANNEL = "sheela.channel"
    val CN_ONG_NS = "ongoing_ns.channel"
    val CN_EVE_STREAM = "com.example.agoraflutterquickstart/stream"
    val SPEECH_TO_TEXT_STREAM = "speechToText/stream"
    val Bluetooth_EVE_STREAM = "QurbookBLE/stream"
    val Appointment_EVE_STREAM = "ScheduleAppointment/stream"

    val FROM_LANG = "com.example.agoraflutterquickstart/stream"
    val TO_LANG = "com.example.agoraflutterquickstart/stream"
    val EN_US = "en_US"
    val FUN_GET_MY_ROUTE = "getMyRoute"
    val START_SHEELA_LISTENING = "startSheelaListening"
    val FUN_ONG_NS = "startOnGoingNS"
    val PROP_MODE = "mode"
    val PROP_MSG = "message"
    val PROP_IS_CLOSE = "isClose"
    val PROP_CLAIM_ID = "claimId"
    val PROP_PRESCRIPTION_ID = "prescriptionId"
        val PROP_ISSHEELA= "isSheela"


    val PROP_START = "start"
    val PROP_STOP = "stop"
    val PROP_NAME = "name"
    val PROP_CALL = "call"
    val PROP_ACK = "ack"
    val PROP_RESCHEDULE = "reschedule"
    val PROP_CANCEL_APPS = "cancel_appointment"
    val PROP_CANCEL_KEY = "cancel_apps"
    val PROP_DOC_KEY = "doctorId"
    val PROP_LANG_CODE = "langcode"
    val PROP_LANG = "lang"
    val PROP_PlannedStartTime ="plannedStartDateTime"
    val PROP_BookingId ="bookingId"
    val PROP_docSessionId ="doctorSessionId"
    val PROP_healthOrgId ="healthOrganizationId"
    val PROP_docId ="doctorId"
    val PROP_ACCEPT ="accept"
    val PROP_RENEW ="Renew"
    val PROP_CALLBACK ="Callback"
    val MY_PLAN_DETAILS ="myplandetails"
    val PROP_PLANID ="planId"
    val PROP_DECLINE ="decline"
    val PROP_PROVIDER_REQID ="providerRequestId"
    val PROP_DOC_CANCELLATION ="DoctorCancellation"
    val PROP_DOC_RESCHDULE ="DoctorRescheduling"
    val PROP_TEMP_NAME ="templateName"
    val PROP_REDIRECT_TO ="redirectTo"
    val PROP_CAREGIVER_REQUESTOR ="caregiverRequestor"
    val PROP_DATA ="data"
    val PROP_HRMID ="healthRecordMetaIds"
    val PROP_EVEID ="eventId"
    val PROP_RAWTITLE ="rawTitle"
        val PROP_sheelaAudioMsgUrl ="sheelaAudioMsgUrl"

    val PROP_RAWBODY ="rawBody"
    val PROB_EXTERNAL_LINK ="externalLink"
    val PROB_USER_ID ="userId"
    val WIFI_WORKS ="wifiworks"
    val PROB_PATIENT_NAME ="patientName"
    val PATIENT_PHONE_NUMBER ="patientPhoneNumber"
    val VERIFICATION_CODE ="verificationCode"
    val CAREGIVER_RECEIVER ="caregiverReceiver"
    val CAREGIVER_REQUESTER ="caregiverRequestor"
    val BLE_CONNECT ="bleConnect"
    val DEVICES_CHANNEL ="QurbookBLE/method"
    val CARE_COORDINATOR_USER_ID ="careCoordinatorUserId"
    val PATIENT_NAME ="patientName"
    val PATIENT_ID ="patientId"
    val CARE_GIVER_NAME ="careGiverName"
    val ACTIVITY_TIME ="activityTime"
    val ACTIVITY_NAME ="activityName"
    val BP_CONNECT ="bpconnect"
    val BP_SCAN_CANCEL ="bpscancancel"
    val BP_ENABLE_CHECK ="bluetooth_enable_check"
    val LOCATION_SERVICE_CHECK ="location_service_check"
    val ENABLE_BACKGROUND_NOTIFICATION ="enablebackgroundnotification"
    val DISABLE_BACKGROUND_NOTIFICATION ="disablebackgroundnotification"
    val BP_LOCATION_CHECK ="bp_location_check"
    val BLE_SCAN_CANCEL ="bleScanCancel"
    val UID ="uid"
    val GET_CURRENT_LOCATION ="getCurrentLocation"
    val APPOINTMENT_DETAILS ="appointmentDetails"
    val IS_CARE_GIVER ="isCareGiver"
    val DELIVERED_DATE_TIME ="deliveredDateTime"
    val IS_FROM_CARE_COORDINATOR ="isFromCareCoordinator"
    val SENDER_PROFILE_PIC ="senderProfilePic"

    val APPOINTMENT_DATE="appointmentDate";
    val BOOKINGID="bookingId";
    val APPOINTMENTID="appointmentId";
    val STATUS="status";
    val MEETINGID="meetingId";
    val PAYMENTLINKVIAPUSH="paymentLinkViaPush";
    val CARTID="cartId";

    val CREATEDBY="createdBy";
    val CRITICAL_APP_STOPPED="⚠️ CRITICAL - App Stopped";
    val CRITICAL_APP_STOPPED_DESCRIPTION="The app must be running in the background to receive alerts. Tap to re-open the app";

    val PROP_UUID ="uid"

    val CLOSE_SHEELA_DIALOG = "closeSheelaDialog"
    val EVENT_TYPE = "eventType"
    val OTHERS = "others"
    val WRAPPERCALL = "wrapperCall"
    val NOTIFICATIONLISTID = "notificationListId"
    val APPOINTMENT_DETAIL = "appointmentDetail"

    val idSheela = "id"
    val eidSheela = "eid"
    val sayTextSheela = "saytext"

    val PATIENT_REFERRAL_ACCEPT="patientReferralAcceptToPatient"
    val PROP_ESTART ="estart"
    val IS_NOTIFICATION_PERMISSION_CHECK ="notification_permission_check"
    val PROP_DOSEMEAL ="dosemeal"

}

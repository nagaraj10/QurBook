
import Foundation
import CoreBluetooth

struct Constants {
    static let googlekey = "AIzaSyCQ26mjgJ8T00uCWigel-zWQKU6fkhsGX4"
    
    static let STT_CHANNEL = "flutter.native/voiceIntent"
    static let TTS_CHANNEL = "flutter.native/textToSpeech"
    
    static let STT_METHOD = "speakWithVoiceAssistant"
    static let TTS_METHOD = "textToSpeech"
    
    static let enUS = "en-US"
    static let Listening = "Listening..."
    
    static let speechToText = "Speech to Text channel entered";
    static let textToSpeech = "Text to Speech channel entered";
    static let unableToRecognition = "Unable to create a SFSpeechAudioBufferRecognitionRequest object";
    static let recogEntered = "recognitionRequest Entered";
    static let STT = "STT : ";
    static let TSS = "TTS : ";
    static let errorIs = "error is";
    static let reponseToRemoteNotificationMethodChannel =
        "flutter.native.QurBook/notificationResponse";
    static let notificationResponseMethod = "notificationResponse";
    static let devicesEventChannel = "QurbookBLE/stream"
    static let reminderMethodChannel = "flutter.native/reminder"
    static let addReminderMethod = "addReminder"
    static let iOSMethodChannel = "flutter.native/iOS"
    static let getWifiDetailsMethod = "getWifiDetails"
    static let removeReminderMethod = "removeReminder"
    static let removeAllReminderMethod = "removeAllReminder"
    static let navigateToRegimentMethod = "navigateToRegiment"
    static let listenToCallStatusMethod = "listenToCallStatus"
static let navigateToSheelaReminderMethod = "navigateToSheelaReminderMethod"
    static let title = "title";
    static let description = "description";
    static let notification = "notification";
    static let after = "remindin";
    static let importance = "importance";
    static let beepSound = "beep_beep.mp3";
    static let before = "remindbefore";
    struct paramaters {
        static let message = "message"
        static let isClose = "isClose"
    }
    
    static let appointmentDetailsMethodAndChannel = "appointmentDetails";
    static let closeMicMethod = "CloseMic";
    static let poServiceCBUUID = CBUUID(string: "49535343-fe7d-4ae5-8fa9-9fafd205e455")
    static let poMeasurementCharacteristicCBUUID = CBUUID(string: "49535343-1e4d-4bd9-ba61-23c647249616")
    static let BIT_PULSE:UInt8 = 0x40 //1 = pulse beep
    static let BIT_FINGER:UInt8 = 0x10 //0 = OK, 1 = no finger
    static let BIT_PLUSE_RATE_BIT7:UInt8 = 0x40 // is bit7 of pulse rate
    static let BIT_PLUSE_RATE_BIT0_6:UInt8 = 0x7F // need add BIT_PLUSE_RATE_BIT7, 0xFF = invarid
    static let BIT_SPO2:UInt8 = 0x7F // 0~100    0x7f = invalid
    static let BLEManuData = "kCBAdvDataManufacturerData";
    static let BLENameData = "kCBAdvDataLocalName";
    static let BLEAdvDataServiceUUIDs = "kCBAdvDataServiceUUIDs";
    static let QurhomeDefaultUI = "QurhomeDefaultUI";
    static let Mike = "Mike";
    static let WOWGOSPO2 = "GSH601";
    static let WOWGOBP = "GSH862";
    static let WOWGOBPB = "GSH_862B";
    static let WOWGOWT1 = "GSH-202";
    static let WOWGOWT2 = "GSH-231";
    static let WOWGOWT3 = "0202B-0001";
}

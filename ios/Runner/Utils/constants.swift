
import Foundation

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
    
    static let reminderMethodChannel = "flutter.native/reminder"
    static let addReminderMethod = "addReminder"
    static let iOSMethodChannel = "flutter.native/iOS"
    static let getWifiDetailsMethod = "getWifiDetails"
    static let removeReminderMethod = "removeReminder"
    static let removeAllReminderMethod = "removeAllReminder"
    static let navigateToRegimentMethod = "navigateToRegiment"
    static let listenToCallStatusMethod = "listenToCallStatus"

    static let title = "title";
    static let description = "description";
    static let notification = "notification";
    static let after = "remindin";
    static let before = "remindbefore";
    struct paramaters {
        static let message = "message"
        static let isClose = "isClose"
    }
    
}

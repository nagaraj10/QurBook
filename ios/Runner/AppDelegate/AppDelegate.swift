import UIKit
import Flutter
import GoogleMaps
import Speech
import AVFoundation
import Firebase
import IQKeyboardManagerSwift
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import CoreBluetooth
import BleManager
import GSH601_DeviceManager
import DB62M_DeviceManager
import LS202_DeviceManager
import LSBluetoothPlugin
import CallKit
import PushKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SFSpeechRecognizerDelegate {
    
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Language.instance.setlanguage()))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    var audioEngine = AVAudioEngine()
    
    var STT_Result : FlutterResult?
    var TTS_Result : FlutterResult?
    
    var STT_CHANNEL = Constants.STT_CHANNEL
    var TTS_CHANNEL = Constants.TTS_CHANNEL
    
    var STT_METHOD = Constants.STT_METHOD
    var TTS_METHOD = Constants.TTS_METHOD
    var STT_MicavailablityMethod = "validateMicAvailability"
    
    var detectionTimer : Timer?
    var message = ""
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let reminderChannel = Constants.reminderMethodChannel
    let addReminderMethod = Constants.addReminderMethod
    let snoozeReminderMethod = Constants.snoozeReminderMethod
    let removeReminderMethod = Constants.removeReminderMethod
    
    let notificationCenter = UNUserNotificationCenter.current()
    var listOfScheduledNotificaitons:[UNNotificationRequest] = []
    let showBothButtonsCat = "showBothButtonsCat"
    let showSingleButtonCat = "showSingleButtonCat"
    let showVCAcceptRejectedButtons = "showVCAcceptRejectedButtons"
    let planRenewButton = "planRenewButton"
    let escalateToCareCoordinatorButtons = "escalateToCareCoordinatorButtons"
    let showTransportationNotification = "transportationRequestAcceptDeclineButtons"
    let acceptDeclineButtonsCaregiver = "showAcceptDeclineButtonsCaregiver"
    let ChatCCAndViewrecordButtons = "showChatCCAndViewrecordButtons"
    let viewDetailsButton = "memberviewDetailsButtons"
    let showViewMemberAndCommunicationButtons = "showViewMemberAndCommunicationButtons"
    var navigationController: UINavigationController?
    var resultForMethodChannel : FlutterResult!
    var locationManager: CLLocationManager?
    var isQurhomeDefaultUI = false
    var ResponseNotificationChannel : FlutterMethodChannel!
    var ReponseAppLockMethodChannel : FlutterMethodChannel!
    var ReponsePushKitTokenMethodChannel : FlutterMethodChannel!
    var ResponseCallKitMethodChannel : FlutterMethodChannel!
    var ReminderMethodChannel : FlutterMethodChannel!
    var isFromKilledStateNotification = false
    var payloadResonse: UNNotificationResponse!
    var voipRegistry: PKPushRegistry!
    
    // CallKit components
    var pkPushPayload : PKPushPayload!
    var cxCallUDID: UUID!
    var cxCallProvider: CXProvider!
    var cxCallKitCallController: CXCallController!
    var flutterController : FlutterViewController!
    var isMuteCalledFromFlutter = false
    var isSplashScreenLaunched = false
    var isCallStarted = false

    //BLE
    var centralManager: CBCentralManager!
    var SPO2Manager : GoldenSPO2Manager!
    var BloodpressureManager : GoldenBloodpressureManager!
    var LS202DeviceManager : GoldenLS202DeviceManager!
    var eventSink: FlutterEventSink? = nil
    var selectedDevicesList : [SelectedDevices] = []
    var deviceSearched = false
    //Reminders
    var id = "";
    var title = "";
    var des = "";
    var dateComponent:DateComponents = DateComponents();
    var dateComponentBefore:DateComponents = DateComponents();
    var dateComponentAfter:DateComponents = DateComponents();
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 1
        // Google Api Key
        GMSServices.provideAPIKey(Constants.googlekey)
                
        // 1
        // Local Notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert,  .sound]
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute:  {
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert,  .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        receiveCallKitMethodFromNative()
        flutterController = window?.rootViewController as! FlutterViewController

        setUpReminders(messanger: flutterController.binaryMessenger)
        requestAuthorization();
        notificationCenter.getDeliveredNotifications { [weak self](data) in
            guard let self = self else { return }
            if(data.contains(where: { elem in
                return elem.request.identifier == "criticalappnotification"
            })){
                self.notificationCenter.removeDeliveredNotifications(withIdentifiers: ["criticalappnotification"])
            }
        }
        notificationCenter.getPendingNotificationRequests { [weak self](data) in
            guard let self = self else { return }
            self.listOfScheduledNotificaitons = data
        }
        IQKeyboardManager.shared.enable = true

        setUpNotificationButtons()
        setupTTSMethodChannels()
        setupBLEMethodChannels()

        if (ResponseNotificationChannel == nil){
            ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: flutterController.binaryMessenger)
        }
        ResponseNotificationChannel.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            if call.method == Constants.QurhomeDefaultUI{
                if let QurhomeDefault = call.arguments as? NSDictionary,let status = QurhomeDefault["status"] as? Bool{
                    self.isQurhomeDefaultUI = status
                }
            }
        }
        
        
        ResponseNotificationChannel.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            if call.method == Constants.IsAppLockChecked{
                if let QurhomeDefault = call.arguments as? NSDictionary,let status = QurhomeDefault["status"] as? Bool{
                    self.isSplashScreenLaunched = true

                    if(status == true && self.payloadResonse != nil){
                        self.isFromKilledStateNotification = false;
                        let data = self.payloadResonse.notification.request.content.userInfo
                        let alert = UIAlertController(title: nil, message: "Loading content", preferredStyle: .actionSheet)
                        self.navigationController?.children.first?.present(alert, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: data[Constants.type] as! String == Constants.call ? DispatchTime.now()+2 : DispatchTime.now()+3) {
                            alert.dismiss(animated: true)
                            self.responsdToNotificationTap(response: self.payloadResonse)
                            self.payloadResonse = nil
                        }
                    }
                }
            }
        }
        
        //        print("fcm token \(String(describing: Messaging.messaging().fcmToken))")
        GeneratedPluginRegistrant.register(with: self)
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController?.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // To check whether the app is launched from push notification or not from killed state
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            // Launched from push notification
            if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
                if let notificationType = userInfo[Constants.type] as? NSString {
                    isFromKilledStateNotification = true;
                    
                    if(notificationType as String == Constants.call){
                        // Received call notification
                        triggerAppLockMethod(isCallRecieved: true)
                    }else{
                        // Received normal notification(Not call)
                        triggerAppLockMethod(isCallRecieved: false)
                    }
                }
            }
        }else{
            // Create a Push kit
            initializePushKit()
            triggerAppLockMethod(isCallRecieved: false)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    func triggerAppLockMethod(isCallRecieved: Bool){
        let data = [ Constants.isCallRecieved : isCallRecieved]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) { [self] in
            if let controller = self.navigationController?.children.first as? FlutterViewController{
                if (self.ReponseAppLockMethodChannel == nil){
                    self.ReponseAppLockMethodChannel = FlutterMethodChannel.init(name: Constants.reponseToTriggerAppLockMethodChannel, binaryMessenger: controller.binaryMessenger)
                }
            }
            self.ReponseAppLockMethodChannel.invokeMethod(Constants.callAppLockFeatureMethod, arguments:data)
        }
    }
 
    override func applicationWillTerminate(_ application: UIApplication) {
        if(isQurhomeDefaultUI){
            var dateComponent:DateComponents = DateComponents();
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateFromString = Date()
            dateFromString = Calendar.current.date(byAdding: .second, value: 1, to: dateFromString) ?? Date()
            let strOfDateAndTime = dateFormatter.string(from: dateFromString)
            let strSplitDateTime = strOfDateAndTime.components(separatedBy: " ")
            let strDates = strSplitDateTime[0].components(separatedBy: "-")
            let strTime = strSplitDateTime[1].components(separatedBy: ":")
            if let year = Int(strDates[0]),let month = Int(strDates[1]),let day = Int(strDates[2]),let hour = Int(strTime[0]),let min = Int(strTime[1]),let sec = Int(strTime[2]){
                dateComponent.year = year
                dateComponent.month = month
                dateComponent.day = day
                dateComponent.hour = hour
                dateComponent.minute = min
                dateComponent.second = sec
                
            }
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "CRITICAL-App Stopped"
            notificationContent.body = "The app must be running in the background to receive alerts. Tap to re-open the app."
            notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: Constants.beepSound))
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: "criticalappnotification", content: notificationContent, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
            
        }
    }
}

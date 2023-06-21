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

//Incoming Call
import UIKit
import CallKit
import PushKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SFSpeechRecognizerDelegate, CXProviderDelegate {
    
    
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
    let removeReminderMethod = Constants.removeReminderMethod
    
    let notificationCenter = UNUserNotificationCenter.current()
    var listOfScheduledNotificaitons:[UNNotificationRequest] = []
    let showBothButtonsCat = "showBothButtonsCat"
    let showSingleButtonCat = "showSingleButtonCat"
    let planRenewButton = "planRenewButton"
    let escalateToCareCoordinatorButtons = "escalateToCareCoordinatorButtons"
    let showTransportationNotification = "transportationRequestAcceptDeclineButtons"
    let acceptDeclineButtonsCaregiver = "showAcceptDeclineButtonsCaregiver"
    let ChatCCAndViewrecordButtons = "showChatCCAndViewrecordButtons"
    let viewDetailsButton = "memberviewDetailsButtons"
    let showViewMemberAndCommunicationButtons = "showViewMemberAndCommunicationButtons"
    var centralManager: CBCentralManager!
    var poPeripheral: CBPeripheral!
    var weightPeripheral: CBPeripheral!
    var SPO2Manager : GoldenSPO2Manager!
    var BloodpressureManager : GoldenBloodpressureManager!
    var LS202DeviceManager : GoldenLS202DeviceManager!
    var navigationController: UINavigationController?
    var resultForMethodChannel : FlutterResult!
    var locationManager: CLLocationManager?
    var eventSink: FlutterEventSink? = nil
    var idForBP :UUID?
    var isQurhomeDefaultUI = false
    var ResponseNotificationChannel : FlutterMethodChannel!
    var ReponseAppLockMethodChannel : FlutterMethodChannel!
    var ReponsePushKitTokenMethodChannel : FlutterMethodChannel!
    var ResponseCallKitMethodChannel : FlutterMethodChannel!

    var ReminderMethodChannel : FlutterMethodChannel!
    var connectedWithWeighingscale = false
    
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
        // locationManager = CLLocationManager()
        // locationManager?.delegate = self
        // locationManager?.requestWhenInUseAuthorization()
        
        receiveCallKitMethodFromNative()
        
        flutterController = window?.rootViewController as! FlutterViewController
        
        // 2
        // Speech Recognization
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        setUpReminders(messanger: controller.binaryMessenger)
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
            //            print("total notifications scheduled \(data.count)")
            
        }
        //Add Action button the Notification
        IQKeyboardManager.shared.enable = true
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let declineAction = UNNotificationAction(identifier: "Dismiss", title: "Dismiss", options: [.destructive])
        let renewNowAction = UNNotificationAction(identifier: "Renew", title: "Renew", options: [.foreground])
        let esclateAction = UNNotificationAction(identifier: "Escalate", title: "Escalate", options: [.foreground])
        let callBackNowAction = UNNotificationAction(identifier: "Callback", title: "Call back", options: [.foreground])
        let rejectAction = UNNotificationAction(identifier: "Reject", title: "Reject", options: [.destructive])
        let acceptAction = UNNotificationAction(identifier: "Accept", title: "Accept", options: [.foreground])
        let chatwithCCAction = UNNotificationAction(identifier: "chatwithcc", title: "Chat with cc", options: [.foreground])
        let viewRecordAction = UNNotificationAction(identifier: "viewrecord", title: "View Record", options: [.foreground])
        let viewMemberAction = UNNotificationAction(identifier: "ViewMember", title: "View Member", options: [.foreground])
        let viewDetailsAction = UNNotificationAction(identifier: "ViewDetails", title: "View Details", options: [.foreground])
        let communicationsettingsAction = UNNotificationAction(identifier: "Communicationsettings", title: "Communication settings", options: [.foreground])
        let declineNewAction = UNNotificationAction(identifier: "Decline", title: "Decline", options: [])
        let showTransportationcategory = UNNotificationCategory(identifier: showTransportationNotification,
                                                             actions:  [acceptAction, declineNewAction],
                                                             intentIdentifiers: [],
                                                             options: [])
        
        let showBothButtonscategory = UNNotificationCategory(identifier: showBothButtonsCat,
                                                             actions:  [snoozeAction, declineAction],
                                                             intentIdentifiers: [],
                                                             options: [])
        let esclateButtonscategory = UNNotificationCategory(identifier: escalateToCareCoordinatorButtons,
                                                            actions:  [esclateAction],
                                                            intentIdentifiers: [],
                                                            options: [])
        let showViewMemberAndCommunicationButtonscategory = UNNotificationCategory(identifier: showViewMemberAndCommunicationButtons,
                                                                                   actions:  [viewMemberAction, communicationsettingsAction],
                                                                                   intentIdentifiers: [],
                                                                                   options: [])
        let showSingleButtonCategory = UNNotificationCategory(identifier: showSingleButtonCat,
                                                              actions:  [declineAction],
                                                              intentIdentifiers: [],
                                                              options: [])
        let planRenewButtonCategory = UNNotificationCategory(identifier: planRenewButton,
                                                             actions:  [renewNowAction,callBackNowAction],
                                                             intentIdentifiers: [],
                                                             options: [])
        let acceptRejectCargiverButtonCategory = UNNotificationCategory(identifier: acceptDeclineButtonsCaregiver,
                                                                        actions:  [acceptAction,rejectAction],
                                                                        intentIdentifiers: [],
                                                                        options: [])
        let chatCCAndViewrecordButtonsCategory = UNNotificationCategory(identifier: ChatCCAndViewrecordButtons,
                                                                        actions:  [chatwithCCAction,viewRecordAction],
                                                                        intentIdentifiers: [],
                                                                        options: [])
        let viewDetailButtonCategory = UNNotificationCategory(identifier: viewDetailsButton,
                                                              actions:  [viewDetailsAction],
                                                              intentIdentifiers: [],
                                                              options: [])
        notificationCenter.setNotificationCategories([showBothButtonscategory,
                                                      showSingleButtonCategory,
                                                      planRenewButtonCategory,
                                                      acceptRejectCargiverButtonCategory,
                                                      showViewMemberAndCommunicationButtonscategory,
                                                      esclateButtonscategory,
                                                      chatCCAndViewrecordButtonsCategory,
                                                      viewDetailButtonCategory,
                                                      showTransportationcategory])
        // 2 a)
        // Speech to Text
        let sttChannel = FlutterMethodChannel(name: STT_CHANNEL,
                                              binaryMessenger: controller.binaryMessenger)
        let evChannel =  FlutterEventChannel(name: Constants.devicesEventChannel, binaryMessenger: controller.binaryMessenger)
        evChannel.setStreamHandler(self)
        if (ResponseNotificationChannel == nil){
            ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
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
        let appointmentDetailsChannel =  FlutterMethodChannel(name: Constants.appointmentDetailsMethodAndChannel, binaryMessenger: controller.binaryMessenger)
        appointmentDetailsChannel.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            if call.method == Constants.appointmentDetailsMethodAndChannel{
                if let notifiationToShow = call.arguments as? NSDictionary{
                    self.scheduleAppointmentReminder(message: notifiationToShow)
                }
            }
        }
        sttChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            if call.method == self?.STT_METHOD  {
                print(Constants.speechToText)
                print(Constants.STT, result)
                self?.startLoadingVC()
                //                Loading.sharedInstance.showLoader()
                //                let mytapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(self?.myTapActions))
                //                mytapGestureRecog.numberOfTapsRequired = 1
                //                Loading.sharedInstance.bgBlurView.addGestureRecognizer(mytapGestureRecog)
                self?.STT_Result = result;
                do{
                    try self?.startRecording();
                }catch(let error){
                    print("\(Constants.errorIs) \(error.localizedDescription)")
                }
            }else if call.method == self?.STT_MicavailablityMethod{
                let audioSession = AVAudioSession.sharedInstance()
                result(!audioSession.isOtherAudioPlaying)
            }else if call.method == Constants.closeSheelaDialog{
                Loading.sharedInstance.hideLoader()
                self?.stopRecording()
                if let viewControllers = self?.navigationController?.visibleViewController as? SheelaAIVC {
                    viewControllers.dismiss(animated: true, completion: nil)
                }
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
        
        // 2  b)
        // Text to Speech
        let ttsChanne1 = FlutterMethodChannel(name: TTS_CHANNEL,
                                              binaryMessenger: controller.binaryMessenger)
        ttsChanne1.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard call.method == self?.TTS_METHOD else {
                result(FlutterMethodNotImplemented)
                return
            }
            print(Constants.textToSpeech)
            let argumentDic = call.arguments as! Dictionary<String, Any>
            let message = argumentDic[Constants.paramaters.message] as! String
            let isClose = argumentDic[Constants.paramaters.isClose] as! Bool
            print(Constants.TSS, message)
            self?.TTS_Result = result;
            self?.textToSpeech(messageToSpeak: message, isClose: isClose)
        })
        
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

            //Not launched from push notification
            triggerAppLockMethod(isCallRecieved: false)
            //            let alert = UIAlertController(title: nil, message: "Triggered", preferredStyle: .actionSheet)
            //            navigationController?.children.first?.present(alert, animated: true)
            
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func initializePushKit(){
        let mainQueue = DispatchQueue.main
//        voipRegistry = PKPushRegistry(queue: DispatchQueue(label: "voipQueue"))
        voipRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
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
    
    @objc func myTapActions(recognizer: UITapGestureRecognizer) {
        STT_Result?("");
        //        Loading.sharedInstance.hideLoader()
        stopRecording()
        if let controller = self.navigationController?.children.first as? FlutterViewController{
            let notificationChannel = FlutterMethodChannel.init(name: Constants.TTS_CHANNEL, binaryMessenger: controller.binaryMessenger)
            notificationChannel.invokeMethod(Constants.closeMicMethod,arguments: nil)
        }
        if let viewControllers = navigationController?.visibleViewController as? SheelaAIVC {
            viewControllers.dismiss(animated: true, completion: nil)
        }
        if let viewControllers = navigationController?.visibleViewController as? LoaderVC {
            viewControllers.dismiss(animated: false, completion: nil)
        }
    }
    
    // 2 a)
    // Speech to Text
    func startRecording() throws {
        // Reset
        audioEngine.reset()
        recognitionTask?.cancel()
        self.recognitionTask = nil
        // Initialization
        audioEngine = AVAudioEngine()
        recognitionTask = SFSpeechRecognitionTask()
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .mixWithOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError(Constants.unableToRecognition) }
        recognitionRequest.shouldReportPartialResults = true
        
        if #available(iOS 13, *) {
            if speechRecognizer.supportsOnDeviceRecognition ?? false{
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }
        print(recognitionRequest)
        print(Constants.recogEntered)
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { time in
            if(self.message.count == 0){
                if let controller = self.navigationController?.children.first as? FlutterViewController{
                    let notificationChannel = FlutterMethodChannel.init(name: Constants.TTS_CHANNEL, binaryMessenger: controller.binaryMessenger)
                    notificationChannel.invokeMethod(Constants.closeMicMethod,arguments: nil)
                }
                Loading.sharedInstance.hideLoader()
                self.stopRecording()
                self.detectionTimer?.invalidate()
                self.STT_Result!("")
            }else{
                Loading.sharedInstance.showLoader()
            }
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.message = result.bestTranscription.formattedString
                self.detectionTimer?.invalidate()
                if let viewControllers = self.navigationController?.visibleViewController as? LoaderVC {
                    viewControllers.dismiss(animated: false, completion: nil)
                    Loading.sharedInstance.showLoader()
                }
                print(result.bestTranscription.formattedString as Any)
                print(result.isFinal)
                if let timer = self.detectionTimer, timer.isValid, result.isFinal {
                    // pull out the best transcription...
                    print(result.bestTranscription.formattedString as Any)
                    print(result.isFinal)
                    timer.invalidate()
                    self.stopRecording()
                    if(self.message.count > 0){
                        if let controller = self.navigationController?.children.first as? FlutterViewController{
                            let notificationChannel = FlutterMethodChannel.init(name: Constants.TTS_CHANNEL, binaryMessenger: controller.binaryMessenger)
                            notificationChannel.invokeMethod(Constants.closeMicMethod, arguments: nil)
                        }
                        self.startTheVC(currentmessage: self.message)
                    }
                    self.message = "";
                }
                else {
                    self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                        //                    isFinal = true
                        Loading.sharedInstance.hideLoader()
                        print(self.message)
                        timer.invalidate()
                        self.stopRecording()
                        if(self.message.count > 0){
                            if let controller = self.navigationController?.children.first as? FlutterViewController{
                                let notificationChannel = FlutterMethodChannel.init(name: Constants.TTS_CHANNEL, binaryMessenger: controller.binaryMessenger)
                                notificationChannel.invokeMethod(Constants.closeMicMethod,arguments: nil)
                            }
                            self.startTheVC(currentmessage: self.message)
                        }
                        self.message = "";
                        
                    })
                }
            }
            
            if (error != nil){
                print(error?.localizedDescription as Any);
            }
        }
    }
    
    func startTheVC(currentmessage:String){
        let storyboard = UIStoryboard(name: "SheelaAI", bundle: nil)
        if let container = storyboard.instantiateViewController(withIdentifier: "SheelaAIVC") as? SheelaAIVC {
            container.message = currentmessage
            container.callback = { message in
                self.STT_Result!(message)
            }
            container.modalPresentationStyle = .overFullScreen
            navigationController?.present(container, animated: false)
        }
    }
    func startLoadingVC(){
        let storyboard = UIStoryboard(name: "SheelaAI", bundle: nil)
        if let container = storyboard.instantiateViewController(withIdentifier: "LoaderVC") as? LoaderVC {
            container.modalPresentationStyle = .overFullScreen
            let mytapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(myTapActions))
            mytapGestureRecog.numberOfTapsRequired = 1
            container.view.addGestureRecognizer(mytapGestureRecog)
            navigationController?.present(container, animated: false)
        }
    }
    // 2  b)
    // Text to Speech
    func textToSpeech(messageToSpeak: String, isClose:Bool){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
        }catch{
            
        }
        speechSynthesizer.delegate = self
        let speechUtterance = AVSpeechUtterance(string: messageToSpeak)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: Constants.enUS) // en-GB -> MAle , en-US -> Female
        speechUtterance.rate = 0.5
        //        speechUtterance.pitchMultiplier = 0.5
        //        speechUtterance.preUtteranceDelay = 0
        speechUtterance.volume = 1
        if (isClose){
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }else{
            speechSynthesizer.speak(speechUtterance)
        }
    }
    
    // 3
    // Stop Recording
    func stopRecording(){
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
        }catch(let error){
            print("\(Constants.errorIs) \(error.localizedDescription)")
        }
    }
    
    func setUpReminders(messanger:FlutterBinaryMessenger){
        let notifiationChannel = FlutterMethodChannel(name: reminderChannel, binaryMessenger: messanger)
        notifiationChannel.setMethodCallHandler {[weak self] (call, result) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            if call.method == self.addReminderMethod{
                let notificationArray = call.arguments as! NSArray
                if let notifiationToShow = notificationArray[0] as? NSDictionary{
                    notifiationToShow.setValue("Reminders", forKey: "NotificationType")
                    self.scheduleNotification(message: notifiationToShow)
                }
            }else if call.method == self.removeReminderMethod{
                if let  dataArray = call.arguments as? NSArray,let id = dataArray[0] as? String{
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
                }else if let data = call.arguments as? NSDictionary,let id = data["deliveredNotificationId"] as? String{
                    self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
                }
            }
            else if call.method == Constants.removeAllReminderMethod{
                self.notificationCenter.removeAllDeliveredNotifications()
                self.notificationCenter.removeAllPendingNotificationRequests()
                Messaging.messaging().deleteToken { (err) in
                    print(err?.localizedDescription)
                }
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }
    
    
    func scheduleAppointmentReminder(message: NSDictionary)  {
        print(message)
        if let _id =  message["eid"] as? String {
            id = _id
        }else{
            return
        }
        if let dateNotifiation = message["estart"] as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let dateFromString = dateFormatter.date(from: dateNotifiation)?.toLocalTime()
            var dateFromStringBefore:Date?
            if let dateToBeTriggered = dateFromString{
                dateFromStringBefore = Calendar.current.date(byAdding: .minute, value: -5, to: dateToBeTriggered) ?? dateToBeTriggered
                
            }
            
            if let dateForSchedule = dateFromStringBefore{
                let strOfDateAndTime = "\(dateForSchedule)"
                let strSplitDateTime = strOfDateAndTime.components(separatedBy: " ")
                let strDates = strSplitDateTime[0].components(separatedBy: "-")
                let strTime = strSplitDateTime[1].components(separatedBy: ":")
                if let year = Int(strDates[0]),let month = Int(strDates[1]),let day = Int(strDates[2]),let hour = Int(strTime[0]),let min = Int(strTime[1]),let sec = Int(strTime[2]){
                    dateComponentBefore.year = year
                    dateComponentBefore.month = month
                    dateComponentBefore.day = day
                    dateComponentBefore.hour = hour
                    dateComponentBefore.minute = min
                    dateComponentBefore.second = sec
                }
            }
        }else{
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Appointment confirmation"
        content.body = "Appointment confirmation"
        let identifier = id + "0000"
        content.userInfo = message as! [AnyHashable : Any]
        
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentBefore, repeats: false)
        let  request = UNNotificationRequest(identifier: identifier, content: content, trigger: dateTrigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    var id = "";
    var title = "";
    var des = "";
    var dateComponent:DateComponents = DateComponents();
    var dateComponentBefore:DateComponents = DateComponents();
    var dateComponentAfter:DateComponents = DateComponents();
    //Prepare New Notificaion with deatils and trigger
    func scheduleNotification(message: NSDictionary,snooze:Bool = false) {
        var before :Int = 0
        var after : Int = 0
        var importantNotification : Int = 0
        
        if let _id =  message["eid"] as? String {
            id = _id
        }else{
            return
        }
        if let _title = message[Constants.title] as? String { title = _title}
        if let _des = message[Constants.description] as? String {des = _des}
        if let _before = message[Constants.before] as? String ,let beforeInt = Int(_before){before = beforeInt}
        if let _after = message[Constants.after] as? String,let afterInt = Int(_after) {after = afterInt}
        if let _importants = message[Constants.importance] as? String,let importants = Int(_importants) {importantNotification = importants}
        if !snooze{
            if let dateNotifiation = message["estart"] as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var dateFromString = dateFormatter.date(from: dateNotifiation)?.toLocalTime()
                var dateFromStringAfter:Date?
                var dateFromStringBefore:Date?
                if let dateToBeTriggered = dateFromString{
                    if before > 0{
                        dateFromStringBefore = Calendar.current.date(byAdding: .minute, value: -before, to: dateToBeTriggered) ?? dateToBeTriggered
                    }
                    if after > 0{
                        dateFromStringAfter = Calendar.current.date(byAdding: .minute, value: after, to: dateToBeTriggered) ?? dateToBeTriggered
                    }
                }
                if let dateForSchedule = dateFromString{
                    let strOfDateAndTime = "\(dateForSchedule)"
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
                }
                if let dateForSchedule = dateFromStringAfter{
                    let strOfDateAndTime = "\(dateForSchedule)"
                    let strSplitDateTime = strOfDateAndTime.components(separatedBy: " ")
                    let strDates = strSplitDateTime[0].components(separatedBy: "-")
                    let strTime = strSplitDateTime[1].components(separatedBy: ":")
                    if let year = Int(strDates[0]),let month = Int(strDates[1]),let day = Int(strDates[2]),let hour = Int(strTime[0]),let min = Int(strTime[1]),let sec = Int(strTime[2]){
                        dateComponentAfter.year = year
                        dateComponentAfter.month = month
                        dateComponentAfter.day = day
                        dateComponentAfter.hour = hour
                        dateComponentAfter.minute = min
                        dateComponentAfter.second = sec
                    }
                }
                if let dateForSchedule = dateFromStringBefore{
                    let strOfDateAndTime = "\(dateForSchedule)"
                    let strSplitDateTime = strOfDateAndTime.components(separatedBy: " ")
                    let strDates = strSplitDateTime[0].components(separatedBy: "-")
                    let strTime = strSplitDateTime[1].components(separatedBy: ":")
                    if let year = Int(strDates[0]),let month = Int(strDates[1]),let day = Int(strDates[2]),let hour = Int(strTime[0]),let min = Int(strTime[1]),let sec = Int(strTime[2]){
                        dateComponentBefore.year = year
                        dateComponentBefore.month = month
                        dateComponentBefore.day = day
                        dateComponentBefore.hour = hour
                        dateComponentBefore.minute = min
                        dateComponentBefore.second = sec
                    }
                }
            }
            if let alreadyScheduled = message["alreadyScheduled"] as? Bool,alreadyScheduled{
                let ids = listOfScheduledNotificaitons.filter({$0.identifier == id})
                if ids.count > 0{
                    return
                }
            }
        }
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = des
        let identifier = id
        if(importantNotification == 2){
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: Constants.beepSound))
        }
        if snooze,let snoozcount = message["snoozeCount"] as? Int{
            if (snoozcount > 1){
                content.categoryIdentifier = showSingleButtonCat
            }else{
                content.categoryIdentifier = showBothButtonsCat
            }
            // identifier = id + "\(snoozcount)"
        }else{
            content.categoryIdentifier = showBothButtonsCat
        }
        content.userInfo = message as! [AnyHashable : Any]
        var request:UNNotificationRequest;
        if snooze{
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
            request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        }else{
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            request = UNNotificationRequest(identifier: identifier, content: content, trigger: dateTrigger)
        }
        //adding the notification
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:  { [self] in
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
                self.notificationCenter.getPendingNotificationRequests { data in
                    print("All pending notificaiton count = \(data.count)")
                }
            }
        });
        if after > 0,!snooze{
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = des
            let identifier = id + "11111"
            if(importantNotification == 2){
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: Constants.beepSound))
            }
            content.userInfo = message as! [AnyHashable : Any]
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentAfter, repeats: false)
            let  request = UNNotificationRequest(identifier: identifier, content: content, trigger: dateTrigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        if before > 0,!snooze{
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = des
            let identifier = id + "00000"
            if(importantNotification == 2){
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: Constants.beepSound))
            }
            content.userInfo = message as! [AnyHashable : Any]
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentBefore, repeats: false)
            let  request = UNNotificationRequest(identifier: identifier, content: content, trigger: dateTrigger)
            //adding the notification
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken
    }
    
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
    //Handle Notification Center Delegate methods
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        checkForCallListener(notification: notification)
        if let userInfo = notification.request.content.userInfo as? NSDictionary,let type = userInfo["activityname_orig"] as? String,type.lowercased() == "appointment",let controller = navigationController?.children.first as? FlutterViewController{
            print("Inside the notification")
            let notificationChannel = FlutterMethodChannel.init(name: Constants.appointmentDetailsMethodAndChannel, binaryMessenger: controller.binaryMessenger)
            
            notificationChannel.invokeMethod(Constants.appointmentDetailsMethodAndChannel, arguments: userInfo)
            completionHandler([])
            
        }else if let userInfo = notification.request.content.userInfo as? NSDictionary,
                 let type = userInfo["isSheela"] as? String,
                 let controller = navigationController?.children.first as? FlutterViewController,
                 UIApplication.shared.applicationState == .active{
            if(type.lowercased() == "true"){
                if (ResponseNotificationChannel == nil){
                    ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
                }
                ResponseNotificationChannel.invokeMethod(Constants.notificationResponseMethod, arguments: userInfo)
                completionHandler([])
            }else{
                completionHandler([.alert, .sound])
            }
        }else{
            if let userInfo = notification.request.content.userInfo as? NSDictionary,
               let type = userInfo["NotificationType"] as? String,
               type.lowercased() == "reminders",
               let eid = userInfo["eid"] as? String
                ,let controller = navigationController?.children.first as? FlutterViewController{
                let data =
                [ "eid" : eid]
                if (ResponseNotificationChannel == nil){
                    ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
                }
                ResponseNotificationChannel.invokeMethod(Constants.navigateToSheelaReminderMethod, arguments: data)
            }
            completionHandler([.alert, .sound])
        }
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    func checkForCallListener(notification:UNNotification){
        if let userInfo = notification.request.content.userInfo as? NSDictionary,let type = userInfo["type"] as? String,type.lowercased() == "call",let controller = navigationController?.children.first as? FlutterViewController{
            let data =
            [ "id" : notification.request.identifier,"meeting_id" : userInfo["meeting_id"]]
            if (ResponseNotificationChannel == nil){
                ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
            }
            ResponseNotificationChannel.invokeMethod(Constants.listenToCallStatusMethod, arguments: data)
        }
    }
    
    func responsdToNotificationTap(response : UNNotificationResponse){
        if let data = response.notification.request.content.userInfo as? NSDictionary,let controller = navigationController?.children.first as? FlutterViewController{
            if (data["eid"] as? String) != nil{
                if response.actionIdentifier == "Snooze" {
                    if let count = data["snoozeCount"] as? Int{
                        if count < 2{
                            var newData = response.notification.request.content.userInfo
                            newData["snoozeCount"] = count + 1
                            self.scheduleNotification(message:newData as NSDictionary, snooze: true)
                        }
                    }else{
                        var newData = response.notification.request.content.userInfo
                        newData["snoozeCount"] = 1
                        self.scheduleNotification(message:newData as NSDictionary, snooze: true)
                    }
                }else if response.actionIdentifier == "Dismiss"{
                }else{
                    var newData :NSDictionary
                    newData  = [
                        "eid" : data["eid"],
                        "estart" : data["estart"]
                    ]
                    
                    if(ReminderMethodChannel == nil){
                        ReminderMethodChannel = FlutterMethodChannel.init(name: Constants.reminderMethodChannel, binaryMessenger: controller.binaryMessenger)
                        
                    }
                    ReminderMethodChannel.invokeMethod(Constants.callLocalNotificationMethod, arguments: newData)
                }
            }
            else {
                var newData :NSDictionary
                if (response.actionIdentifier == "Renew" || response.actionIdentifier == "Callback"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else if (response.actionIdentifier == "Decline" || response.actionIdentifier == "Accept"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else if (response.actionIdentifier == "Reject" || response.actionIdentifier == "Accept"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else if (response.actionIdentifier == "chatwithcc" || response.actionIdentifier == "viewrecord"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else if (response.actionIdentifier == "Escalate" || response.actionIdentifier == "ViewDetails"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else if (response.actionIdentifier.lowercased() == "communicationsettings" || response.actionIdentifier.lowercased() == "viewmember"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else{
                    newData = data
                }
                if (ResponseNotificationChannel == nil){
                    ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
                    
                }
                ResponseNotificationChannel.invokeMethod(Constants.notificationResponseMethod, arguments:newData)
            }
        }
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        //        if(isFromKilledState == true){
        //            if (ResponseNotificationChannel == nil){
        //                var controller = navigationController?.children.first as? FlutterViewController;
        //                ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller!.binaryMessenger)
        //            }
        //            ResponseNotificationChannel.invokeMethod(Constants.notificationReceivedMethod, arguments:nil)
        //        }
        
        //        let appState =  UIApplication.shared.applicationState
        //        if( appState == .active){
        //            responsdToNotificationTap(response: response)
        //            completionHandler()
        //        }else{
        
        payloadResonse = nil
        if(isFromKilledStateNotification == false){
            let alert = UIAlertController(title: nil, message: "Loading content", preferredStyle: .actionSheet)
            navigationController?.children.first?.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
                alert.dismiss(animated: true)
                self.responsdToNotificationTap(response: response)
                completionHandler()
            }
        }else{
            payloadResonse = response;
        }
        
        //        }
    }
    
//    override func applicationDidBecomeActive(_ application: UIApplication) {
//        initializePushKit()
//    }
    
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

extension AppDelegate: AVSpeechSynthesizerDelegate,MessagingDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        TTS_Result!(1);
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
}





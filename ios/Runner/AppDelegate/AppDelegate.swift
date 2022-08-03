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
    let removeReminderMethod = Constants.removeReminderMethod
    
    let notificationCenter = UNUserNotificationCenter.current()
    var listOfScheduledNotificaitons:[UNNotificationRequest] = []
    let showBothButtonsCat = "showBothButtonsCat"
    let showSingleButtonCat = "showSingleButtonCat"
    let planRenewButton = "planRenewButton"
    let escalateToCareCoordinatorButtons = "escalateToCareCoordinatorButtons"
    
    let acceptDeclineButtonsCaregiver = "showAcceptDeclineButtonsCaregiver"
    let ChatCCAndViewrecordButtons = "showChatCCAndViewrecordButtons"
    let showViewMemberAndCommunicationButtons = "showViewMemberAndCommunicationButtons"
    var centralManager: CBCentralManager!
    var poPeripheral: CBPeripheral!
    var navigationController: UINavigationController?
    var resultForMethodChannel : FlutterResult!
    var locationManager: CLLocationManager?
    var eventSink: FlutterEventSink? = nil
    var idForBP :UUID?
    var isQurhomeDefaultUI = false
    var ResponseNotificationChannel : FlutterMethodChannel!
    
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
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:  {
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
        let communicationsettingsAction = UNNotificationAction(identifier: "Communicationsettings", title: "Communication settings", options: [.foreground])
        
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
        notificationCenter.setNotificationCategories([showBothButtonscategory,showSingleButtonCategory,planRenewButtonCategory,acceptRejectCargiverButtonCategory,showViewMemberAndCommunicationButtonscategory,esclateButtonscategory,chatCCAndViewrecordButtonsCategory])
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
                Loading.sharedInstance.showLoader()
                self?.STT_Result = result;
                do{
                    try self?.startRecording();
                }catch(let error){
                    print("\(Constants.errorIs) \(error.localizedDescription)")
                }
            }else if call.method == self?.STT_MicavailablityMethod{
                let audioSession = AVAudioSession.sharedInstance()
                result(!audioSession.isOtherAudioPlaying)
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
        //        print("fcm token \(String(describing: Messaging.messaging().fcmToken))")
        GeneratedPluginRegistrant.register(with: self)
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController?.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
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
        recognitionRequest.shouldReportPartialResults = false
        
        if #available(iOS 13, *) {
            if speechRecognizer.supportsOnDeviceRecognition ?? false{
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }
        print(recognitionRequest)
        print(Constants.recogEntered)
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                
                self.message = result.bestTranscription.formattedString
                self.detectionTimer?.invalidate()
                
                print(result.bestTranscription.formattedString as Any)
                print(result.isFinal)
                
                if let timer = self.detectionTimer, timer.isValid {
                    if result.isFinal {
                        // pull out the best transcription...
                        print(result.bestTranscription.formattedString as Any)
                        print(result.isFinal)
                        timer.invalidate()
                        self.stopRecording()
                        //self.startTheVC(currentmessage: self.message)
                        self.STT_Result?(self.message)
                        self.message = "";
                    }
                } else {
                    self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                        //                    isFinal = true
                        Loading.sharedInstance.hideLoader()
                        print(self.message)
                        timer.invalidate()
                        self.stopRecording()
                        self.STT_Result?(self.message)
                        //self.startTheVC(currentmessage: self.message)
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
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            self.notificationCenter.getPendingNotificationRequests { data in
                print("All pending notificaiton count = \(data.count)")
            }
        }
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
            notificationChannel.invokeMethod(Constants.appointmentDetailsMethodAndChannel, arguments: Constants.appointmentDetailsMethodAndChannel)
            completionHandler([])
            
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
                    let reminderChannel = FlutterMethodChannel.init(name: self.reminderChannel, binaryMessenger: controller.binaryMessenger)
                    reminderChannel.invokeMethod(Constants.navigateToRegimentMethod, arguments: nil)
                }
            }
            else {
                var newData :NSDictionary
                if (response.actionIdentifier == "Renew" || response.actionIdentifier == "Callback"){
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
                }else if (response.actionIdentifier == "Escalate"){
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
        //        let appState =  UIApplication.shared.applicationState
        //        if(appState == .inactive || appState == .active){
        //            responsdToNotificationTap(response: response)
        //            completionHandler()
        //        }else{
        let alert = UIAlertController(title: nil, message: "Loading content", preferredStyle: .actionSheet)
        navigationController?.children.first?.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            alert.dismiss(animated: true)
            self.responsdToNotificationTap(response: response)
            completionHandler()
        }
        
        //        }
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

extension AppDelegate:FlutterStreamHandler, CBCentralManagerDelegate, CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .resetting:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .unsupported:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .unauthorized:
            eventSink?("permissiondenied|no permission granted")
        case .poweredOff:
            eventSink?("enablebluetooth|please enable bluetooth")
        case .poweredOn:
            eventSink?("scanstarted|connection started")
            centralManager.scanForPeripherals(withServices: [])
        default:
            eventSink?("enablebluetooth|please enable bluetooth")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let name =  advertisementData[Constants.BLENameData] as? String, name.lowercased().contains("blesmart"){
            centralManager.stopScan()
            let tempMacId = String(name.suffix(12))
            let macID = tempMacId.inserting(reverse: false)
            OHQDeviceManager.shared().scanForDevices(with: OHQDeviceCategory.any) {[weak self] deviceInfoKeys in
                guard let self = self else { return  }
                OHQDeviceManager.shared().stopScan()
                self.idForBP = deviceInfoKeys[OHQDeviceInfoKey.identifierKey] as? UUID
                if (self.idForBP) != nil{
                    OHQDeviceManager.shared().startSession(withDevice: self.idForBP!, usingDataObserver: { dataType, data in
                        if let ArrayData =  data as? NSArray,ArrayData.count > 0,let lastObj = ArrayData.lastObject as? NSDictionary{
                            let lsOBj : [String:Any] = [
                                "BloodPressureMeasurementStatusKey" : lastObj["bloodPressureMeasurementStatus"],
                                "BloodPressureUnitKey" : lastObj["bloodPressureUnit"],
                                "DiastolicKey" : lastObj["diastolic"],
                                "MeanArterialPressureKey" : lastObj["meanArterialPressure"],
                                "PulseRateKey" : lastObj["pulseRate"],
                                "SystolicKey" : lastObj["systolic"],
                                // "timeStamp" : lastObj["timeStamp"],
                                "UserIndexKey" : lastObj["userIndex"]
                            ];
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: ["measurementRecords" : [lsOBj
                                                                                                                  ]], options: JSONSerialization.WritingOptions.prettyPrinted)
                                let jsonString = String(data: jsonData, encoding: .utf8)
                                self.eventSink?("measurement|" + (jsonString ?? ""))
                                if self.idForBP != nil {
                                    OHQDeviceManager.shared().cancelSession(withDevice: self.idForBP!)
                                    self.idForBP = nil
                                }
                            }
                            catch let err {
                                print(err)
                            }
                        }
                    }, connectionObserver: {[weak self] state in
                        guard let self = self else { return }
                        if (state == OHQConnectionState.connected){
                            self.eventSink?("macid|"+macID)
                            self.eventSink?("bleDeviceType|BP")
                        }
                    }, completion: { completionReason in
                        if (completionReason == OHQCompletionReason.busy || completionReason == OHQCompletionReason.poweredOff){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
                                print("restarted");
                                self.centralManager = CBCentralManager(delegate: self, queue: nil)
                                self.centralManager.scanForPeripherals(withServices: [])
                            }
                        }
                        
                    }, options: [
                        OHQSessionOptionKey.readMeasurementRecordsKey : true,
                        OHQSessionOptionKey.connectionWaitTimeKey : 60
                    ])
                }
            } completion: { completionReason in
                if (completionReason == OHQCompletionReason.busy || completionReason == OHQCompletionReason.poweredOff){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                        print("restarted");
                        self.centralManager = CBCentralManager(delegate: self, queue: nil)
                        self.centralManager.scanForPeripherals(withServices: [])
                    }
                }
            }
        }else if let newdata =  advertisementData[Constants.BLEManuData] as? Data,let serviceIdArray =  advertisementData[Constants.BLEAdvDataServiceUUIDs] as? NSArray,serviceIdArray.count > 0, let serviceId = serviceIdArray.firstObject as? CBUUID{
            if serviceId == Constants.poServiceCBUUID{
                let decodedString = newdata.hexEncodedString()
                let macID = decodedString.inserting()
                eventSink?("macid|"+macID)
                eventSink?("bleDeviceType|SPO2")
                poPeripheral = peripheral
                poPeripheral.delegate = self
                centralManager.stopScan()
                centralManager.connect(poPeripheral)
                
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        eventSink?("connected|connected successfully!!!")
        poPeripheral.discoverServices([Constants.poServiceCBUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case Constants.poMeasurementCharacteristicCBUUID:
            spoReading(from: characteristic,peripheral:peripheral)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func spoReading(from characteristic: CBCharacteristic, peripheral: CBPeripheral)  {
        guard let characteristicData = characteristic.value else { return  }
        var index = 0
        let byteArray = [UInt8](characteristicData)
        while(index<byteArray.count){
            let fingure = byteArray[index+2] & Constants.BIT_FINGER
            var pulse = byteArray[index+2] & Constants.BIT_PLUSE_RATE_BIT7 << 1
            pulse += byteArray[index+3] & Constants.BIT_PLUSE_RATE_BIT0_6
            let spo = byteArray[index+4] & Constants.BIT_SPO2
            if(fingure == 0 && spo < 101 && pulse != 127 && pulse != 255){
                let data : [String:Any] = [
                    "Status" : "Measurement",
                    "deviceType" : "SPO2",
                    "Data" : [
                        "SPO2" : String(describing: spo),
                        "Pulse" : String(describing: pulse)
                    ]
                ]
                if let serlized = data.jsonStringRepresentation{
                    print(serlized)
                    eventSink?("measurement|"+serlized)
                    eventSink = nil
                    centralManager.stopScan()
                    if( characteristic.isNotifying){
                        peripheral.setNotifyValue(false, for: characteristic)
                    }
                }
            }
            index += 5
        }
    }
    
    func onListen(withArguments arguments: Any?,
                  eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        centralManager = CBCentralManager(delegate: self, queue: nil)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        centralManager.stopScan()
        if idForBP != nil {
            OHQDeviceManager.shared().cancelSession(withDevice: idForBP!)
            idForBP = nil
        }
        return nil
    }
    
}



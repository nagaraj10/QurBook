import UIKit
import Flutter
import GoogleMaps
import Speech
import AVFoundation

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
            UNUserNotificationCenter.current().delegate = self
        }
        
        // 2
        // Speech Recognization
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        requestAuthorization();
        notificationCenter.getPendingNotificationRequests { [weak self](data) in
            guard let self = self else { return }
            self.listOfScheduledNotificaitons = data
            print(data.count)
        }
        //Add Action button the Notification
    
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let declineAction = UNNotificationAction(identifier: "Dismiss", title: "Dismiss", options: [.destructive])
        let showBothButtonscategory = UNNotificationCategory(identifier: showBothButtonsCat,
                                              actions:  [snoozeAction, declineAction],
                                              intentIdentifiers: [],
                                              options: [])
      
        let showSingleButtonCategory = UNNotificationCategory(identifier: showSingleButtonCat,
                                              actions:  [declineAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([showBothButtonscategory,showSingleButtonCategory])
        // 2 a)
        // Speech to Text
        let sttChannel = FlutterMethodChannel(name: STT_CHANNEL,
                                              binaryMessenger: controller.binaryMessenger)
        sttChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard call.method == self?.STT_METHOD else {
                result(FlutterMethodNotImplemented)
                return
            }
            print(Constants.speechToText)
            print(Constants.STT, result)
            Loading.sharedInstance.showLoader()
            self?.STT_Result = result;
            do{
                try self?.startRecording();
            }catch(let error){
                print("\(Constants.errorIs) \(error.localizedDescription)")
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
        setUpReminders(messanger: controller.binaryMessenger)
        GeneratedPluginRegistrant.register(with: self)
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
        recognitionRequest.shouldReportPartialResults = true
        
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
                        self.STT_Result!(result.bestTranscription.formattedString as Any);
                        self.message = "";
                        self.stopRecording()
                    }
                } else {
                    self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                        //                    isFinal = true
                        Loading.sharedInstance.hideLoader()
                        print(self.message)
                        timer.invalidate()
                        self.STT_Result!(self.message);
                        self.message = "";
                        self.stopRecording()
                    })
                }
            }
            
            if (error != nil){
                print(error?.localizedDescription as Any);
            }
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
                    self.scheduleNotification(message: notifiationToShow)
                }
            }else if call.method == self.removeReminderMethod,let dataArray = call.arguments as? NSArray,let id = dataArray[0] as? String{
                
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
            }
            else if call.method == Constants.removeAllReminderMethod{
                self.notificationCenter.removeAllDeliveredNotifications()
                self.notificationCenter.removeAllPendingNotificationRequests()
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }
    
    var id = "";
    var title = "";
    var des = "";
    var dateComponent:DateComponents = DateComponents();
    //Prepare New Notificaion with deatils and trigger
    func scheduleNotification(message: NSDictionary,snooze:Bool = false) {
        if let _id =  message["eid"] as? String {
            id = _id
        }else{
            return
        }
        if let _title = message[Constants.title] as? String { title = _title}
        if let _des = message[Constants.description] as? String {des = _des}
        
        if !snooze{
            if let dateNotifiation = message["estart"] as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var dateFromString = dateFormatter.date(from: dateNotifiation)?.toLocalTime()
                print(dateNotifiation)
                print(dateFromString as Any)
                if let dateToBeTriggered = dateFromString{
                    if let remindInStr = message["remindin"] as? String, let remindIn = Int(remindInStr){
                        dateFromString = Calendar.current.date(byAdding: .minute, value: -remindIn, to: dateToBeTriggered) ?? dateToBeTriggered
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
                print(dateComponent.description)
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
        }
    }
    //Handle Notification Center Delegate methods
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        //            if (response.actionIdentifier == "Accept") || (response.actionIdentifier == "Decline"){
        //
        //            }
        print(response.actionIdentifier)
        if response.actionIdentifier == "Snooze" {
            if let data = response.notification.request.content.userInfo as? NSDictionary{
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
            }
            
        }else if response.actionIdentifier == "Dismiss"{
            
        }else{
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let reminderChannel = FlutterMethodChannel.init(name: self.reminderChannel, binaryMessenger: controller.binaryMessenger)
            reminderChannel.invokeMethod(Constants.navigateToRegimentMethod, arguments: nil)
        }
        completionHandler()
    }
}

extension AppDelegate: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        TTS_Result!(1);
    }
}
extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

}

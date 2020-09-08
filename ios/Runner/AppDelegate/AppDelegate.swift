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
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        // 2
        // Speech Recognization
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        requestAuthorization();
        
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
            
            print(Constants.STT, result);
            
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
                    self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
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
}

extension AppDelegate: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        TTS_Result!(1);
    }
}

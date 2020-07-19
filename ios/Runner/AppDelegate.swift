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
    
    let audioEngine = AVAudioEngine()
    
    var STT_Result : FlutterResult?
    var TTS_Result : FlutterResult?
    
    var STT_CHANNEL = "flutter.native/voiceIntent"
    var TTS_CHANNEL = "flutter.native/textToSpeech"
    
    var STT_METHOD = "speakWithVoiceAssistant"
    var TTS_METHOD = "textToSpeech"
    
    var detectionTimer : Timer?
    var message = ""
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 1
        // Google Api Key
        GMSServices.provideAPIKey("AIzaSyCQ26mjgJ8T00uCWigel-zWQKU6fkhsGX4")
        
        // 2
        // Speech Recognization
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
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
            
            print("Speech to Text channel entered")
            
            print("STT : ", result);
            
//            self!.showLoading();
            Loading.sharedInstance.showLoader()
            
            self?.STT_Result = result;
            try! self?.startRecording();
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
            
            print("Text to Speech channel entered")
            
            let argumentDic = call.arguments as! Dictionary<String, Any>
            let message = argumentDic["message"] as! String
            let isClose = argumentDic["isClose"] as! Bool
            
            print("TTS : ", message)
            
            self?.TTS_Result = result;
            self?.textToSpeech(messageToSpeak: message, isClose: isClose)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // 2 a)
    // Speech to Text
    func startRecording() throws {
        
        speechRecognizer.delegate = self
        requestAuthorization(); // Request Authorization
        
        //        recognitionTask?.cancel()
        //        recognitionTask = nil
        //
        // Cancel the previous recognition task.
        //        if recognitionTask != nil {
        //            recognitionTask?.cancel()
        //            recognitionTask = nil
        //        }
        
        //        if  audioEngine.isRunning {
        recognitionRequest?.shouldReportPartialResults = false
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        //        }
        
        // 1
        // Audio session, to get information from the microphone.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let inputNode = audioEngine.inputNode
        
        // 2
        // The AudioBuffer
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 3
        // Force speech recognition to be on-device
        //        if #available(iOS 13, *) {
        //            recognitionRequest.requiresOnDeviceRecognition = true
        //        }
        
        // 4
        // Actually create the recognition task. We need to keep a pointer to it so we can stop it.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [unowned self] (result, error) in
            
            //            var isFinal = false
            
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }
            
            //            isFinal = result.isFinal
            self.message = result.bestTranscription.formattedString
            self.detectionTimer?.invalidate()
            
            print("Outside")
            print(result.bestTranscription.formattedString as Any)
            print(result.isFinal)
            
            if let timer = self.detectionTimer, timer.isValid {
                if result.isFinal {
                    // pull out the best transcription...
                    print("Inside")
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
                    print("Timer called")
                    Loading.sharedInstance.hideLoader()

                    print(self.message)
                    
                    timer.invalidate()
                    self.STT_Result!(self.message);
                    self.message = "";
                    self.stopRecording()
                })
            }
        })
        
        // 5
        // Configure the microphone.
        let micFormat = inputNode.inputFormat(forBus: 0)
        
        // 6
        // The buffer size tells us how much data should the microphone record before dumping it into the recognition request.
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: micFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    // 2  b)
    // Text to Speech
    func textToSpeech(messageToSpeak: String, isClose:Bool){
        do{
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride(rawValue: AVAudioSession.PortOverride.speaker.rawValue)!);
        }catch{
            
        }
        
        speechSynthesizer.delegate = self
        
        let speechUtterance = AVSpeechUtterance(string: messageToSpeak)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // en-GB -> MAle , en-US -> Female
        
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
    
    // 4
    // Stop Recording
    func showLoading(){
        let alert = UIAlertController(title: nil, message: "Listening...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // 5
    // Stop Recording
    func hideLoading(){
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
}

extension AppDelegate: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("all done")
        
        TTS_Result!(1);
    }
}

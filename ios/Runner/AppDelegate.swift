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
    
    var _result : FlutterResult?
    
    var STT_CHANNEL = "flutter.native/voiceIntent"
    var TTS_CHANNEL = "flutter.native/textToSpeech"
    
    var STT_METHOD = "speakWithVoiceAssistant"
    var TTS_METHOD = "textToSpeech"
    
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
            
            self?._result = result;
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
            
            print(message)
            
            self?.textToSpeech(messageToSpeak: message)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // 2 a)
    // Speech to Text
    func startRecording() throws {
        
        speechRecognizer.delegate = self
        requestAuthorization(); // Request Authorization
        
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
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if(result?.bestTranscription.formattedString != nil){
                print(result?.bestTranscription.formattedString);
                self._result!(result?.bestTranscription.formattedString);
            }
            
            if(result?.isFinal != nil)
            {  isFinal = (result?.isFinal)!}
            
            if isFinal || error != nil {
                let command = result?.bestTranscription.formattedString
                
                if command != nil {
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    
                    self.audioEngine.stop()
                    
                    self.recognitionRequest?.endAudio()
                    
                }
                
            }
        })
        let micFormat = inputNode.inputFormat(forBus: 0)

//        let recordingFormat = inputNode.outputFormat(forBus: 0)
    
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: micFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    // 2  b)
    // Text to Speech
    func textToSpeech(messageToSpeak: String){
        do{
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride(rawValue: AVAudioSession.PortOverride.speaker.rawValue)!);
        }catch{

        }
                    
        let speechUtterance = AVSpeechUtterance(string: messageToSpeak)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        speechUtterance.rate = 0.5
        //        speechUtterance.pitchMultiplier = 0.5
        //        speechUtterance.preUtteranceDelay = 0
        speechUtterance.volume = 1
        
        let speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.speak(speechUtterance)
    }
}

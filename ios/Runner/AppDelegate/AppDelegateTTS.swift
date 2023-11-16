//
//  AppDelegateTTS.swift
//  Runner
//
//  Created by Venkatesh on 28/06/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter
import AVFAudio
import Speech
import AVFoundation

extension AppDelegate : AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        TTS_Result!(1);
    }
    
    
    func setupTTSMethodChannels(){
        // 2 a)
        // Speech to Text
        let sttChannel = FlutterMethodChannel(name: STT_CHANNEL,
                                              binaryMessenger: flutterController.binaryMessenger)
        sttChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            if call.method == self?.STT_METHOD  {
                print(Constants.speechToText)
                print(Constants.STT, result)
                if let argu = call.arguments as? NSDictionary,let langCode = argu["langcode"] as? String {
                    let locale = Language().checkIfTheLocaleIsSupported(locale: langCode)
                    self?.speechRecognizer = SFSpeechRecognizer(locale: locale)!
                }
                self?.startLoadingVC()
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
                                              binaryMessenger: flutterController.binaryMessenger)
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
    }
    
    @objc func myTapActions(recognizer: UITapGestureRecognizer) {
        STT_Result?("");
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
            if speechRecognizer.supportsOnDeviceRecognition {
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
        speechUtterance.voice = AVSpeechSynthesisVoice(language: Constants.enUS)
        speechUtterance.rate = 0.5
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
}

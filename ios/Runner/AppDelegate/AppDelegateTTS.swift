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
    
    func setupTTSMethodChannels(){
        // 2 a)
        // Speech to Text
        let sttChannel = FlutterMethodChannel(name: STT_CHANNEL,
                                              binaryMessenger: flutterController.binaryMessenger)
        sttChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            if call.method == self?.STT_MicavailablityMethod {
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
}

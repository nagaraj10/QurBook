//
//  AppDelegateCKE.swift
//  Runner
//
//  Created by Venkatesh on 28/06/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import UIKit
import CallKit
import PushKit
import Foundation
import AVFAudio
import FirebaseFirestore
import Flutter

extension AppDelegate : PKPushRegistryDelegate,CXProviderDelegate {
    
    func initializePushKit(){
        let mainQueue = DispatchQueue.main
        voipRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    // CALLKIT DELEGATES
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        print("TOKEN:", pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
        triggerPushKitTokenMethod(token: pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if type == .voIP {
            if(cxCallUDID == nil){
                pkPushPayload = payload
                triggerCallKit(payload: payload)
            }
        }
    }
    
    // What happens when the user accepts the call by pressing the incoming call button? You should implement the method below and call the fulfill method if the call is successful.
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
        
        if var payloadDict = pkPushPayload.dictionaryPayload as? Dictionary<String, Any>, let controller = navigationController?.children.first as? FlutterViewController {
            
            payloadDict["status"] = "Accept";
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
                self.configurAudioSession()
            }
            
            isCallStarted = true
            
            let alert = UIAlertController(title: nil, message: "Loading content", preferredStyle: .actionSheet)
            navigationController?.children.first?.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: isSplashScreenLaunched ?  DispatchTime.now() : DispatchTime.now() + 4) {
                alert.dismiss(animated: true)
                
                if (self.ResponseNotificationChannel == nil){
                    self.ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: self.flutterController.binaryMessenger)
                    
                }
                self.ResponseNotificationChannel.invokeMethod(Constants.notificationResponseMethod, arguments:payloadDict)
            }
        }
        return
    }
    
    // What happens when the user taps the reject button? Call the fail method if the call is unsuccessful. It checks the call based on the UUID. It uses the network to connect to the end call method you provide.
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        //  let update = CXCallUpdate()
        //
        //  // Set the remoteHandle, so you can call from System Call History
        //  update.remoteHandle = CXHandle(type: .generic, value: yourHandle)
        //  cxCallProvider.reportCall(with: uuid, updated: update)
        action.fulfill()
        
        if var payloadDict = pkPushPayload.dictionaryPayload as? Dictionary<String, Any>, let controller = navigationController?.children.first as? FlutterViewController {
            
            isCallStarted = false
            
            payloadDict["status"] = "Decline";
            
            //            let alert = UIAlertController(title: nil, message: "Loading content", preferredStyle: .actionSheet)
            //            navigationController?.children.first?.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                //                alert.dismiss(animated: true)
                if (self.ResponseNotificationChannel == nil){
                    self.ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
                }
                self.ResponseNotificationChannel.invokeMethod(Constants.notificationResponseMethod, arguments:payloadDict)
                self.cxCallUDID = nil
            }
        }
        
        return
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        
        if(self.isMuteCalledFromFlutter == false){
            if(flutterController != nil){
                if (ResponseCallKitMethodChannel == nil){
                    ResponseCallKitMethodChannel = FlutterMethodChannel.init(name: Constants.reponseToCallKitMethodChannel, binaryMessenger: flutterController.binaryMessenger)
                    
                }
                let newData  = ["Status": action.isMuted]
                
                ResponseCallKitMethodChannel.invokeMethod(Constants.IsCallMuted, arguments:newData)
            }
        }else{
            self.isMuteCalledFromFlutter = false
        }
        
        action.fulfill()
        
        //        configurAudioSession()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        //        configurAudioSession()
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        
    }
}

extension AppDelegate {
    
    func triggerCallKit(payload: PKPushPayload){
        if let payloadDict = payload.dictionaryPayload as? Dictionary<String, Any>,
           let callerName =  payloadDict["username"] as? String,
           let callType =  payloadDict["callType"] as? String{
            
            //  1: Create an incoming call update object. This object stores different types of information about the caller. You can use it in setting whether the call has a video.
            let cxCallUpdate = CXCallUpdate()
            cxCallUpdate.remoteHandle = CXHandle(type: .generic, value: callerName)
            
            //  2: Create and set configurations about how the calling application should behave
            if #available(iOS 14.0, *) {
                let cxCallConfig = CallKit.CXProviderConfiguration()
                let iconMaskImage = #imageLiteral(resourceName: "callkitLogo")
                cxCallConfig.iconTemplateImageData = iconMaskImage.pngData()
                cxCallConfig.includesCallsInRecents = false;
                cxCallConfig.supportedHandleTypes = [.generic]
                cxCallConfig.supportsVideo = callType == "audio" ? false : true;
                cxCallConfig.maximumCallGroups = 1 // To disable the add call button
                cxCallConfig.maximumCallsPerCallGroup = 1 // To disable the add call button
                // Provide a custom ringtone
                cxCallConfig.ringtoneSound = "iPHONE RINGTONE.aiff";
                
                cxCallUpdate.hasVideo = callType == "audio" ? false : true;
                cxCallUpdate.supportsGrouping = false; // To disable the add call button
                cxCallUpdate.supportsUngrouping = false; // To disable the add call button
                cxCallUpdate.supportsHolding = false; // To disable the add call button
                cxCallUpdate.supportsDTMF = false
                
                // 3: Create a CXProvider instance and set its delegate
                cxCallProvider = CXProvider(configuration: cxCallConfig)
                cxCallProvider.setDelegate(self, queue: nil)
                
                //  4. Post local notification to the user that there is an incoming call. Add the helper method below `reportIncomingCall` to show the full-screen UI. It must contain `UUID()` that helps to identify the caller using a random identifier. You should also provide the `CXCallUpdate` that comprises metadata information about the incoming call.
                cxCallKitCallController = CXCallController()
                
                configurAudioSession()
                
                cxCallUDID = UUID()
                if(isSplashScreenLaunched == true){
                    callLogListener()
                }else{
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
//                        self.callLogListener()
//                    }
                }
                
                cxCallProvider.reportNewIncomingCall(with: cxCallUDID, update: cxCallUpdate, completion: { error in
                    if(error == nil) {
                        //                        self.configurAudioSession()
                    }
                })
            } else {
                //  Fallback on earlier versions
            }
        }
    }
    
    func receiveCallKitMethodFromNative(){
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        if (ResponseCallKitMethodChannel == nil){
            ResponseCallKitMethodChannel = FlutterMethodChannel.init(name: Constants.reponseToCallKitMethodChannel, binaryMessenger: controller.binaryMessenger)
        }
        
        ResponseCallKitMethodChannel.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            // 1
            // Use this to notify CallKit the call is disconnected
            if call.method == Constants.IsCallEnded{
                if let QurhomeDefault = call.arguments as? NSDictionary,let status = QurhomeDefault["status"] as? Bool{
                    if(status == true){
                        // End the call
                        self.endCall()
                        //                    self.cxCallProvider.reportCall(with: self.cxCallUDID, endedAt: Date(), reason: .remoteEnded)
                    }
                }
            }
            
            // 2
            // Mute the call
            if call.method == Constants.IsCallMuted{
                if let QurhomeDefault = call.arguments as? NSDictionary,let status = QurhomeDefault["status"] as? Bool{
                    self.isMuteCalledFromFlutter = true
                    // Mute the call
                    self.muteTheCall(isMuted: status)
                }
            }
        }
    }
    
    func triggerPushKitTokenMethod(token: String){
        let data = [ Constants.token : token];
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) { [self] in
            if let controller = self.navigationController?.children.first as? FlutterViewController{
                if (self.ReponsePushKitTokenMethodChannel == nil){
                    self.ReponsePushKitTokenMethodChannel = FlutterMethodChannel.init(name: Constants.reponseToTriggerPushKitTokenMethodChannel, binaryMessenger: controller.binaryMessenger)
                }
            }
            self.ReponsePushKitTokenMethodChannel.invokeMethod(Constants.pushKitTokenMethod, arguments:data)
        }
    }
    
    func endCall() {
//        isCallStarted = false
        
        if let uuid = cxCallUDID , let cxCallKitCallController {
            let endCallAction = CXEndCallAction(call: uuid)
            let callTransaction = CXTransaction()
            callTransaction.addAction(endCallAction)
            //requestCall
            cxCallKitCallController.request(callTransaction)  { error in
                DispatchQueue.main.async { [self] in
                    if let error = error {
//                        NSLog("CallEnded transaction request failed: \(error.localizedDescription)")
                        return
                    }
//                    NSLog("CallEnded transaction request successful")
                    self.cxCallUDID = nil
                }
            }
        }
    }
    
    // Mute or unmute from the app. This is to sync the CallKit UI with app UI
    func muteTheCall(isMuted: Bool) {
        if let uuid = cxCallUDID{
            let muteAction = CXSetMutedCallAction(call: uuid, muted: isMuted)
            let transaction = CXTransaction(action: muteAction)
            
            cxCallKitCallController.request(transaction)  { error in
                DispatchQueue.main.async {
                    if let error = error {
//                        NSLog("SetMutedCallAction transaction request failed: \(error.localizedDescription)")
                        return
                    }
//                    NSLog("SetMutedCallAction transaction request successful")
                }
            }
        }
    }
    
    func configurAudioSession(){
        let session = AVAudioSession.sharedInstance()
        do{
            //            try session.setCategory(AVAudioSession.Category.playAndRecord, options: [.duckOthers,.allowBluetooth])
            try session.setMode(.default)
            try session.setActive(true)
            try session.setPreferredSampleRate(44100.0)
            try session.setPreferredIOBufferDuration(0.005)
        }catch{
//            print("Error configuring AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    func callLogListener(){
        // It's to dismiss the callkitUI
        if let payloadDict = pkPushPayload.dictionaryPayload as? Dictionary<String, Any>,
           let meetingID =  payloadDict["meeting_id"] as? String {
            
            let db = Firestore.firestore()
            db.collection("call_log").document(meetingID).addSnapshotListener({ listenerSnapshot, error in

                if(self.cxCallUDID == nil) {return}
                
                if let error = error{
                    print("CALLKIT Error:", error.localizedDescription)
                    return
                }

                guard let data = listenerSnapshot?.data() else {
                    if self.isCallStarted {
                        self.endCall()
                        self.isCallStarted = false
                    }
                    return
                }
                if !data.isEmpty {
                    if let callStatus = data["call_status"] as? String, callStatus == "call_ended_by_user" {
                        self.endCall()
                    }
                }
            })
        }
    }
}

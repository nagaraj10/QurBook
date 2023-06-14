//
//  AppDelegate+VoIPNotification.swift
//  Runner
//
//  Created by Senthil on 15/05/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import Foundation
import PushKit
import CallKit

extension AppDelegate : PKPushRegistryDelegate {
    
    // CALLKIT DELEGATES
    func providerDidReset(_ provider: CXProvider) {
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("Successfully registered for notifications!")
        print("TOKEN:", pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
        
        triggerPushKitTokenMethod(token: pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if type == .voIP {
            triggerCallKit(payload: payload)
        }
        //        if type == .voIP {
        //                 if application.applicationState == .active {
        //                     var message = "VOIP PUSH from Admin"
        //                     if let alertMessage = payload.dictionaryPayload["alertMessage"] as? String {
        //                         message = alertMessage
        //                     }
        //                     message = "VOIP: " + message
        //                     delegate?.notificationsProvider(self, didReceive: [message])
        //                     completion()
        //                 }
        //             }
        
        //        let payloadDict = payload.dictionaryPayload as! Dictionary<String, Any>
        //        as! Dictionary<String, Any>
        //        let name = payloadDict["name"]! as Any
        //        let userId = payloadDict["userID"]! as Any
        
        // Responses
        //        {
        //            "isWeb": true,
        //            "meetingId": 1303758,
        //            "type": call,
        //            "doctorPicture": https: //dwtg3mk9sjz8epmqfo.vsolgmi.com/api/file-guard/fileData/profilePicture64a43ea4-c6d1-4bd7-8ad9-b0395a547643,
        //                "rawTitle": ,
        //            "isCaregiver": true,
        //            "doctorId": 64 a43ea4 - c6d1 - 4 bd7 - 8 ad9 - b0395a547643,
        //            "externalLink": ,
        //            "meeting_id": 1303758,
        //            "pushNotificationType": call,
        //            "callType": audio,
        //            "sound": ping.aiff,
        //            "aps": {
        //                alert = "Incoming Audio call";
        //                badge = 3;
        //                sound = "ping.aiff";
        //            },
        //            "body": Incoming Audio call,
        //            "userName": Lex Appointment,
        //            "patientName": Aaaaaaa Babu,
        //            "patientId": 0 c0fd9e0 - 8398 - 4 bd7 - b33f - 36e431 b7c923,
        //            "rawBody": ,
        //            "username": Lex Appointment,
        //            "priority": high,
        //            "notificationListId": a28ce4f7 - b43c - 4592 - 8 da7 - d868a4530eb9,
        //            "title": Lex Appointment,
        //            "patientPicture": https: //dwtg3mk9sjz8epmqfo.vsolgmi.com/api/file-guard/fileData/profilePicture/0c0fd9e0-8398-4bd7-b33f-36e431b7c923
        //        }
    }
    
    // What happens when the user accepts the call by pressing the incoming call button? You should implement the method below and call the fulfill method if the call is successful.
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
        return
    }
    
    // What happens when the user taps the reject button? Call the fail method if the call is unsuccessful. It checks the call based on the UUID. It uses the network to connect to the end call method you provide.
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fail()
        return
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
}

extension AppDelegate {
    func triggerCallKit(payload: PKPushPayload){
        if let payloadDict = payload.dictionaryPayload as? Dictionary<String, Any>,
           let callerName =  payloadDict["patientName"] as? String,
           let callType =  payloadDict["callType"] as? String{
            
            //  1: Create an incoming call update object. This object stores different types of information about the caller. You can use it in setting whether the call has a video.
            let update = CXCallUpdate()
            
            //  Specify the type of information to display about the caller during an incoming call. The different types of information available include `.generic`. For example, you could use the caller's name for the generic type. During an incoming call, the name displays to the other user. Other available information types are emails and phone numbers.
            update.remoteHandle = CXHandle(type: .generic, value: callerName)
//            update.remoteHandle = CXHandle(type: .emailAddress, value: "senthil@gmail.com")
//            update.remoteHandle = CXHandle(type: .phoneNumber, value: "a+35846599990")
            
            //  2: Create and set configurations about how the calling application should behave
            if #available(iOS 14.0, *) {
                let config = CallKit.CXProviderConfiguration()
//                config.iconTemplateImageData = UIImage(named: "")!.pngData()
                config.includesCallsInRecents = false;
                config.supportsVideo = callType == "audio" ? false : true;
                update.hasVideo = callType == "audio" ? false : true;
                
                // Provide a custom ringtone
                config.ringtoneSound = "iPHONE RINGTONE.aiff";
                
                // 3: Create a CXProvider instance and set its delegate
                let provider = CXProvider(configuration: config)
                provider.setDelegate(self, queue: nil)
                
                //  4. Post local notification to the user that there is an incoming call. When using CallKit, you do not need to rely on only displaying incoming calls using the local notification API because it helps to show incoming calls to users using the native full-screen incoming call UI on iOS. Add the helper method below `reportIncomingCall` to show the full-screen UI. It must contain `UUID()` that helps to identify the caller using a random identifier. You should also provide the `CXCallUpdate` that comprises metadata information about the incoming call. You can also check for errors to see if everything works fine.
                provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
                
            } else {
                //  Fallback on earlier versions
            }
        }
    }
}


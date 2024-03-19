//
//  AppDelegateNE.swift
//  Runner
//
//  Created by Venkatesh on 28/06/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter

extension AppDelegate {
    
    func setUpReminders(messanger:FlutterBinaryMessenger){
        let notifiationChannel = FlutterMethodChannel(name: reminderChannel, binaryMessenger: messanger)
        notifiationChannel.setMethodCallHandler {[weak self] (call, result) in
            guard let self = self else{
                result(FlutterMethodNotImplemented)
                return
            }
            if call.method == self.removeReminderMethod {
                if let  dataArray = call.arguments as? NSArray,let id = dataArray[0] as? String{
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
                }else if let data = call.arguments as? NSDictionary,let id = data["deliveredNotificationId"] as? String{
                    self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
                }
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
        }
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
                    //it is already handled
                }else if response.actionIdentifier == "Dismiss"{
                    //it is already handled
                }else{
                    var newData :NSDictionary
                    newData  = [
                        "eid" : data["eid"],
                        "estart" : data["estart"],
                        "dosemeal": data["dosemeal"]
                    ]
                    
                    if(ReminderMethodChannel == nil){
                        ReminderMethodChannel = FlutterMethodChannel.init(name: Constants.reminderMethodChannel, binaryMessenger: controller.binaryMessenger)
                    }
                    ReminderMethodChannel.invokeMethod(Constants.callLocalNotificationMethod, arguments: newData)
                }
            }
        }
    }
}

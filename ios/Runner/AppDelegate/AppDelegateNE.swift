//
//  AppDelegateNE.swift
//  Runner
//
//  Created by Venkatesh on 28/06/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter
import Firebase

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
    
    //Add Action button the Notification
    func setUpNotificationButtons(){
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
        let viewDetailsAction = UNNotificationAction(identifier: "ViewDetails", title: "View Details", options: [.foreground])
        let communicationsettingsAction = UNNotificationAction(identifier: "Communicationsettings", title: "Communication settings", options: [.foreground])
        let declineNewAction = UNNotificationAction(identifier: "Decline", title: "Decline", options: [])
        let showTransportationcategory = UNNotificationCategory(identifier: showTransportationNotification,
                                                                actions:  [acceptAction, declineNewAction],
                                                                intentIdentifiers: [],
                                                                options: [])
        
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
        let viewDetailButtonCategory = UNNotificationCategory(identifier: viewDetailsButton,
                                                              actions:  [viewDetailsAction],
                                                              intentIdentifiers: [],
                                                              options: [])
        notificationCenter.setNotificationCategories([showBothButtonscategory,
                                                      showSingleButtonCategory,
                                                      planRenewButtonCategory,
                                                      acceptRejectCargiverButtonCategory,
                                                      showViewMemberAndCommunicationButtonscategory,
                                                      esclateButtonscategory,
                                                      chatCCAndViewrecordButtonsCategory,
                                                      viewDetailButtonCategory,
                                                      showTransportationcategory])
        
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
            }
            else if call.method == self.snoozeReminderMethod {
                if let notificationArray = call.arguments as? NSArray,
                   let notifiationToShow = notificationArray[0] as? NSDictionary {
                    notifiationToShow.setValue("Reminders", forKey: "NotificationType")
                    self.scheduleNotification(message: notifiationToShow, snooze: true)
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
                        result("success")
                    }
                }
            }
            else if call.method == self.removeReminderMethod {
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
                    print(err?.localizedDescription as Any)
                }
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }
    
    
    
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
        if snooze {
            var timeInterval: Double = Double((message["snoozeTime"] as? String) ?? "300") ?? 300
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        }else{
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            request = UNNotificationRequest(identifier: identifier, content: content, trigger: dateTrigger)
        }
        //adding the notification
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:  { [self] in
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        });
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
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:  { [self] in
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            });
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
         if let userInfo = notification.request.content.userInfo as? NSDictionary,
                 let type = userInfo["isSheela"] as? String,
                 let controller = navigationController?.children.first as? FlutterViewController,
                 UIApplication.shared.applicationState == .active{
            if(type.lowercased() == "true"){
                if (ResponseNotificationChannel == nil){
                    ResponseNotificationChannel = FlutterMethodChannel.init(name: Constants.reponseToRemoteNotificationMethodChannel, binaryMessenger: controller.binaryMessenger)
                }
                ResponseNotificationChannel.invokeMethod(Constants.notificationResponseMethod, arguments: userInfo)
                completionHandler([])
            }else{
                completionHandler([.alert, .sound])
            }
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
            } else {
                var newData :NSDictionary
                if (response.actionIdentifier == "Renew" || response.actionIdentifier == "Callback"){
                    newData  = [
                        "action" : response.actionIdentifier,
                        "data" : data
                    ]
                }else if (response.actionIdentifier == "Decline" || response.actionIdentifier == "Accept"){
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
                }else if (response.actionIdentifier == "Escalate" || response.actionIdentifier == "ViewDetails"){
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
        if let data = response.notification.request.content.userInfo as? NSDictionary{
            if (data["eid"] as? String) != nil {
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
                }
            }
        }
        
        payloadResonse = nil
        if(isFromKilledStateNotification == false){
            let alert = UIAlertController(title: nil, message: "Loading content", preferredStyle: .actionSheet)
            navigationController?.children.first?.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
                alert.dismiss(animated: true)
                self.responsdToNotificationTap(response: response)
                completionHandler()
            }
        }else{
            payloadResonse = response;
        }
    }
}

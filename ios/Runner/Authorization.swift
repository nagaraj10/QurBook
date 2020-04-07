//
//  Authorization.swift
//  SpeechToText
//
//  Created by claudio Cavalli on 17/01/2019.
//  Copyright © 2019 claudio Cavalli. All rights reserved.
//

import UIKit
import Speech

extension AppDelegate{
    
  func requestAuthorization(){
    SFSpeechRecognizer.requestAuthorization { authStatus in
//        OperationQueue.main.addOperation {
//            switch authStatus {
//            case .authorized:
//
//            case .denied:
//
//            case .restricted:
//
//            case .notDetermined:
//            }
//        }
    }
  }
    
}

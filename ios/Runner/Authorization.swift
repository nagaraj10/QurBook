
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

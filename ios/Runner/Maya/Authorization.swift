
import UIKit
import Speech

extension AppDelegate{
    
  func requestAuthorization(){
    SFSpeechRecognizer.requestAuthorization { authStatus in
    }
  }
    
}

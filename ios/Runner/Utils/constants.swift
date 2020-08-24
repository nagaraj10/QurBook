//
//  constants.swift
//  Runner
//
//  Created by Senthil on 24/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

struct Constants {
    static let googlekey = "AIzaSyCQ26mjgJ8T00uCWigel-zWQKU6fkhsGX4"
    
    static let STT_CHANNEL = "flutter.native/voiceIntent"
    static let TTS_CHANNEL = "flutter.native/textToSpeech"
    
    static let STT_METHOD = "speakWithVoiceAssistant"
    static let TTS_METHOD = "textToSpeech"
    
    static let enUS = "en-US"
    static let Listening = "Listening..."
    
    struct paramaters {
        static let message = "message"
        static let isClose = "isClose"
    }
    
}

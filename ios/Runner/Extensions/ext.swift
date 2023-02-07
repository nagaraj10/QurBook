//
//  ext.swift
//  Runner
//
//  Created by Venkatesh on 16/05/22.
//  Copyright © 2022 The Chromium Authors. All rights reserved.
//

import Foundation
import UIKit
extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}

extension Data{
    func hexEncodedString() -> String {
        let hexDigits = Array("0123456789abcdef".utf16)
        var hexChars = [UTF16.CodeUnit]()
        hexChars.reserveCapacity(count * 2)
        
        for byte in self {
            let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
            hexChars.insert(hexDigits[index2], at: 0)
            hexChars.insert(hexDigits[index1], at: 0)
        }
        return String(utf16CodeUnits: hexChars, count: hexChars.count)
    }
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

extension String {
    func inserting(reverse:Bool = true) -> String {
        var result: String = ""
        let characters = Array(self)
        var sepCar:Array<String> = []
        var count = 0
        stride(from: 0, to: characters.count, by: 2).forEach {
            count += 1
            if (reverse){
                if ($0+2 < characters.count) && (count <= 6){
                    sepCar.append(String(characters[$0..<min($0+2, characters.count)]))
                }
            }else{
                if ($0+2 <= characters.count) && (count <= 6){
                    sepCar.append(String(characters[$0..<min($0+2, characters.count)]))
                }
            }
            
        }
        if (reverse){
            sepCar = sepCar.reversed()
        }
        result = sepCar.joined(separator: ":").uppercased()
        print(result)
        return result
    }
}

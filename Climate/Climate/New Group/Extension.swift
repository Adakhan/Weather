//
//  Extension.swift
//  Climate
//
//  Created by Adakhanau on 13/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import Foundation

extension Int {
    
    func toWeekday(_ offset: Int) -> String {
        return unixTimeToWeekday(unixTime: Double(self), offset: offset)
    }
    
    func toStr() -> String {
        if self < 0 {
            return "-\(self) °C"
        }
        if self > 0 {
            return "+\(self) °C"
        }
        return "\(self) °C"
    }
    
    
    
    func unixTimeToWeekday(unixTime: Double, timeZone: String = "Kazakhstan/Almaty", offset: Int) -> String {
        if(timeZone == "" || unixTime == 0.0) {
            return ""
        } else {
            let time = Date(timeIntervalSince1970: unixTime)
            var cal = Calendar(identifier: .gregorian)
            if let tz = TimeZone(identifier: timeZone) {
                cal.timeZone = tz
            }
            // Get the weekday for the given timezone.
            // Add the offset
            // Subtract 1 to convert from 1-7 to 0-6
            // Normalize to 0-6 using % 7
            let weekday = (cal.component(.weekday, from: time) + offset - 1) % 7
            
            // Get the weekday name for the user's locale
            return Calendar.current.weekdaySymbols[weekday]
        }
    }
    
}

extension Double {
    func toSelcius() -> Int {
        return Int(self) - 273
    }
}

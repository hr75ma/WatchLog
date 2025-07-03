//
//  DateManipulation.swift
//  WatchLog
//
//  Created by Marcus Hörning on 03.07.25.
//

import Foundation


struct DateManipulation {
    
    static func getYear(from: Date) -> String {
     return String(Calendar.current.component(.year, from: from))
   }

    static func getMonth(from: Date) -> String {
     return from.formatted(.dateTime.month(.wide))
   }

    static func getWeekDay(from: Date) -> String {
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd. EEEE"  // OR "dd-MM-yyyy"

     return dateFormatter.string(from: from)
   }

    static func getTime(from: Date) -> String {
     let dateStyle = Date.FormatStyle.dateTime
     return from.formatted(
       dateStyle.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits))
   }
    
}



 


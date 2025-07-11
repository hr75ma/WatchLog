//
//  CallIn.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.06.25.
//

import Foundation

struct CallInType {
    enum CallInTypeShort: CaseIterable, Codable {
        case EMERGENCY
        case REGULAR
        case RADIO
    }

    static let callInTypes: [CallInTypeShort: String] = [
        CallInTypeShort.EMERGENCY: "Notruf",
        CallInTypeShort.REGULAR: "Amtsleitung",
        CallInTypeShort.RADIO: "Funk",
    ]

//    var sortedByValues: [ProcessTypeShort:String] {
//        get {
//            ProcessTypes.processTypes.sorted { (first, second) -> Bool in
//                return first.value < second.value }
//        }
//    }
}

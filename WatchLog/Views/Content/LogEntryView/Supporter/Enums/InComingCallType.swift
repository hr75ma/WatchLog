//
//  InComingCallType.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.06.25.
//

import Foundation
import SwiftUI

enum InComingCallType: String, CaseIterable, Identifiable, Codable {
    case emergency = "Notruf"
    case regular = "Amtsleitung"
    case radio = "Funk"
    
    
    var localized: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
    
    var id: InComingCallType {self}
}

//enum InComingCallType: String, CaseIterable, Identifiable, Codable {
//    case emergency
//    case regular
//    case radio
//    
//    
//    var localized: LocalizedStringKey {
//        switch self {
//            case .emergency:
//             "Notruf"
//        case .regular:
//             "Amtsleitung"
//        case .radio:
//             "Funk"
//        }
//    }
//    
//    var id: InComingCallType {self}
//}


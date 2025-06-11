//
//  ProcessTypes.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI

enum ProcessTypeShort: Codable {
    case VU
    case RUHE
    case UNKNOWN
}


struct ProcessTypes {
    
   static let processTypes: [ProcessTypeShort:String] = [ProcessTypeShort.UNKNOWN: "", ProcessTypeShort.VU: "Verkehrsunfall", ProcessTypeShort.RUHE: "Ruhestörung"]
    
    
}

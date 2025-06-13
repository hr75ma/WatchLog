//
//  ProcessTypes.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//
//import OrderedCollections
import SwiftUI




struct ProcessType {
    
    enum ProcessTypeShort: Codable {
        case VU
        case VUW
        case RUHE
        case KV
        case STRE
        case TIER
        case ALDI
        case VERD
        case GESB
        case TRUNK
        case UNKNOWN
    }
    
    static let processTypes: [ProcessTypeShort: String]  = [
    ProcessTypeShort.UNKNOWN: "Sonstiges",
    ProcessTypeShort.VU: "Verkehrsunfall",
    ProcessTypeShort.VUW: "Wildunfall",
    ProcessTypeShort.RUHE: "Ruhestörung",
    ProcessTypeShort.STRE: "Streitgkeiten",
    ProcessTypeShort.TIER: "Tier",
    ProcessTypeShort.ALDI: "Diebstahl",
    ProcessTypeShort.VERD: "Verdacht",
    ProcessTypeShort.GESB: "GESB",
    ProcessTypeShort.TRUNK: "316",
    ProcessTypeShort.KV: "Körperverletzung",
    ]

    
    
//    var sortedByValues: [ProcessTypeShort:String] {
//        get {
//            ProcessTypes.processTypes.sorted { (first, second) -> Bool in
//                return first.value < second.value }
//        }
//    }
    
    
}

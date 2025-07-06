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
        case ALAR
        case BETR
        case BRAN
        case ED
        case CCB
        case DAUF
        case GEFV
        case LADI
        case VKKO
        case RAND
        case SABA
        case VERM
        case SUIV
        case TES
        case UNKNOWN
    }
    
    static let processTypes: [ProcessTypeShort: String]  = [
    ProcessTypeShort.UNKNOWN: "Sonstiges",
    ProcessTypeShort.VU: "Verkehrsunfall",
    ProcessTypeShort.VUW: "Wildunfall",
    ProcessTypeShort.RUHE: "Ruhestörung",
    ProcessTypeShort.STRE: "Streitigkeiten",
    ProcessTypeShort.TIER: "Tier",
    ProcessTypeShort.ALDI: "Diebstahl",
    ProcessTypeShort.VERD: "Verdacht",
    ProcessTypeShort.GESB: "GESB",
    ProcessTypeShort.TRUNK: "316",
    ProcessTypeShort.ALAR: "Alarm",
    ProcessTypeShort.BETR: "Betrug",
    ProcessTypeShort.BRAN: "Brand",
    ProcessTypeShort.ED: "Einbruch",
    ProcessTypeShort.CCB: "Call-Center-Betrug",
    ProcessTypeShort.GEFV: "Gefahrenstelle",
    ProcessTypeShort.DAUF: "Diebstahl an KfZ",
    ProcessTypeShort.KV: "Körperverletzung",
    ProcessTypeShort.LADI: "Ladendiebstahl",
    ProcessTypeShort.VKKO: "Verkehrskontrolle",
    ProcessTypeShort.RAND: "Randalierer",
    ProcessTypeShort.SABA: "Sachbeschädigung",
    ProcessTypeShort.VERM: "Vermisste",
    ProcessTypeShort.SUIV: "Suizidversuch",
    ProcessTypeShort.TES: "Todesermittlung",
    
    
    ]

    
    
//    var sortedByValues: [ProcessTypeShort:String] {
//        get {
//            ProcessTypes.processTypes.sorted { (first, second) -> Bool in
//                return first.value < second.value }
//        }
//    }
    
    
}

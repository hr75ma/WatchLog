//
//  ProcessTypes.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//
// import OrderedCollections
import SwiftUI
import Foundation

enum ProcessingType: String, CaseIterable, Identifiable, Codable {
    case UNKNOWN = "Sonstiges"
    case VU = "Verkehrsunfall"
    case VUW = "Wildunfall"
    case RUHE = "Ruhestörung"
    case STRE = "Streitigkeiten"
    case TIER = "Tier"
    case ALDI = "Diebstahl"
    case VERD = "Verdacht"
    case GESB = "GESB"
    case TRUNK = "316"
    case ALAR = "Alarm"
    case BETR = "Betrug"
    case BRAN = "Brand"
    case ED = "Einbruch"
    case CCB = "Call-Center-Betrug"
    case GEFV = "Gefahrenstelle"
    case DAUF = "Diebstahl an KfZ"
    case KV = "Körperverletzung"
    case LADI = "Ladendiebstahl"
    case VKKO = "Verkehrskontrolle"
    case RAND = "Randalierer"
    case SABA = "Sachbeschädigung"
    case VERM = "Vermisste"
    case SUIV = "Suizidversuch"
    case TES = "Todesermittlung"
    
    var localized: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
    
    var id: ProcessingType {self}
}


enum EventTyping: String, CaseIterable, Identifiable, Codable {
    case UNKNOWN
    case VU
    case VUW
    case RUHE
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
    case GEFV
    case DAUF
    case KV
    case LADI
    case VKKO
    case RAND
    case VERM
    case TES
    
    var localized: LocalizedStringKey {
        
        switch self {
        case .UNKNOWN:
            "Sonstiges"
        case .VU:
            "Verkehrsunfall"
        case .VUW:
            "Wildunfall"
        case .RUHE:
            "Ruhestörung"
        case .STRE:
            "Streitigkeiten"
        case .TIER:
            "Tiereinsatz"
        case .ALDI:
            "Diebstahl"
        case .VERD:
            "Verdacht"
        case .GESB:
            "GESB"
        case .TRUNK:
            "316"
        case .ALAR:
            "Alarm"
        case .BETR:
            "Betrug"
        case .BRAN:
            "Brand"
        case .ED:
            "Einbruch"
        case .CCB:
            "Call-Center-Betrug"
        case .GEFV:
            "Gefahrenstelle"
        case .DAUF:
            "Diebstahl an KfZ"
        case .KV:
            "Körperverletzung"
        case .LADI:
            "Ladendiebstahl"
        case .VKKO:
            "Verkehrskontrolle"
        case .RAND:
            "Randalierer"
        case .VERM:
            "Vermisstenfall"
        case .TES:
            "Todesermittlung"
        }
    }
    
    var id: EventTyping {self}
}



























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

    static let processTypes: [ProcessTypeShort: String] = [
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

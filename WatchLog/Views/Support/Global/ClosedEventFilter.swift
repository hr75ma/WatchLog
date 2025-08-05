//
//  ClosedEventFilter.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.08.25.
//

import Foundation
import SwiftUI

enum ClosedEventFilterType: String, CaseIterable, Identifiable, Codable {
    case all = "alle"
    case none = "keine"
    case last24h = "letzte 24 Stunden"
    
    
    var localized: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
    
    var id: ClosedEventFilterType { self }
    
    
    }


@Observable
final class ClosedEventFilter {
    
    public var closedFilter: ClosedEventFilterType = .last24h
    
    public init() {}
}

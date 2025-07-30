//
//  WatchLog.swift
//  WatchLog
//
//  Created by Marcus Hörning on 31.05.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class WatchLogBook: Identifiable, Hashable {
    #Unique<WatchLogBook>([\.id])
    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookYears: [WatchLogBookYear]? = []

    init(LogDate: Date) {
        id = UUID()
    }

    init() {
        id = UUID()
    }

    var logYearsSorted: [WatchLogBookYear] {
        get {
            watchLogBookYears?.sorted(by: { $0.logDate > $1.logDate }) ?? []
        }
        set {
            watchLogBookYears = newValue
        }
    }
}

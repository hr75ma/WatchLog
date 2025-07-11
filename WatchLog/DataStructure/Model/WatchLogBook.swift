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
    #Unique<WatchLogBook>([\.uuid])
    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookYears: [WatchLogBookYear]? = []

    init(LogDate: Date) {
        uuid = UUID()
    }

    init() {
        uuid = UUID()
    }

    var logYearsSorted: [WatchLogBookYear] {
        get {
            watchLogBookYears?.sorted(by: { $0.LogDate > $1.LogDate }) ?? []
        }
        set {
            watchLogBookYears = newValue
        }
    }
}

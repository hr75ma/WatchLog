//
//  WatchLogBookMonth.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class WatchLogBookMonth: Identifiable, Hashable {
    #Unique<WatchLogBookMonth>([\.id, \.logDate])

    var logDate: Date
    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookDays: [WatchLogBookDay]? = []

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookYear.watchLogBookMonths) var watchLogBookYear: WatchLogBookYear?

    init(LogDate: Date, year: WatchLogBookYear) {
        self.logDate = LogDate
        id = UUID()
        watchLogBookYear = year
    }

    init() {
        id = UUID()
        logDate = Date()
        watchLogBookYear = WatchLogBookYear()
    }

    var logDaysSorted: [WatchLogBookDay] {
        get {
            watchLogBookDays?.sorted(by: { $0.logDate < $1.logDate }) ?? []
        }
        set {
            watchLogBookDays = newValue
        }
    }
}

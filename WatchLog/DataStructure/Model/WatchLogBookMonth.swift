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
    #Unique<WatchLogBookMonth>([\.uuid, \.LogDate])

    var LogDate: Date
    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookDays: [WatchLogBookDay]? = []

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookYear.watchLogBookMonths) var watchLogBookYear: WatchLogBookYear?

    init(LogDate: Date, year: WatchLogBookYear) {
        self.LogDate = LogDate
        uuid = UUID()
        watchLogBookYear = year
    }

    init() {
        uuid = UUID()
        LogDate = Date()
        watchLogBookYear = WatchLogBookYear()
    }

    var logDaysSorted: [WatchLogBookDay] {
        get {
            watchLogBookDays?.sorted(by: { $0.LogDate < $1.LogDate }) ?? []
        }
        set {
            watchLogBookDays = newValue
        }
    }
}

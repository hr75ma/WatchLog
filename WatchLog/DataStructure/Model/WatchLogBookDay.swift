//
//  WatchLogBookDay.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class WatchLogBookDay: Identifiable, Hashable {
    #Unique<WatchLogBookDay>([\.uuid, \.logDate])
    var logDate: Date

    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookEntries: [WatchLogBookEntry]? = []

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookMonth.watchLogBookDays) var watchLogBookMonth: WatchLogBookMonth?

    init(LogDate: Date, month: WatchLogBookMonth) {
        self.logDate = LogDate
        uuid = UUID()
        watchLogBookMonth = month
    }

    init() {
        logDate = .now
        uuid = UUID()
        watchLogBookMonth = WatchLogBookMonth()
    }

    var logEntriesSorted: [WatchLogBookEntry] {
        get {
            watchLogBookEntries?.sorted(by: { $0.logDate < $1.logDate }) ?? []
        }
        set {
            watchLogBookEntries = newValue
        }
    }

    func addLogEntry(_ entry: WatchLogBookEntry) {
        watchLogBookEntries?.append(entry)
        watchLogBookEntries?.sort { $0.logDate < $1.logDate }
    }
}

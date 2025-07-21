//
//  WatchLogBookYear.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class WatchLogBookYear: Identifiable, Hashable {
    #Unique<WatchLogBookYear>([\.id, \.logDate])
    var logDate: Date
    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookMonths: [WatchLogBookMonth]? = []

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBook.watchLogBookYears) var watchLogBook: WatchLogBook?

    init(LogDate: Date, logBook: WatchLogBook) {
        self.logDate = LogDate
        id = UUID()
        watchLogBook = logBook
    }

    init() {
        logDate = .now
        id = UUID()
        watchLogBook = WatchLogBook()
    }

    var logMonthSorted: [WatchLogBookMonth] {
        get {
            watchLogBookMonths?.sorted(by: { $0.logDate < $1.logDate }) ?? []
        }
        set {
            watchLogBookMonths = newValue
        }
    }
}

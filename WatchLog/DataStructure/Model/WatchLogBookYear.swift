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
    #Unique<WatchLogBookYear>([\.uuid, \.LogDate])
    var LogDate: Date
    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .cascade) var watchLogBookMonths: [WatchLogBookMonth]? = []

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBook.watchLogBookYears) var watchLogBook: WatchLogBook?

    init(LogDate: Date, logBook: WatchLogBook) {
        self.LogDate = LogDate
        uuid = UUID()
        watchLogBook = logBook
    }

    init() {
        LogDate = .now
        uuid = UUID()
        watchLogBook = WatchLogBook()
    }

    var logMonthSorted: [WatchLogBookMonth] {
        get {
            watchLogBookMonths?.sorted(by: { $0.LogDate < $1.LogDate }) ?? []
        }
        set {
            watchLogBookMonths = newValue
        }
    }
}

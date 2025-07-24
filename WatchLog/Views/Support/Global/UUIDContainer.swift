//
//  UUIDContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import Foundation
import SwiftUI

@Observable
final class LogEntryUUIDContainer:  Equatable, Identifiable {
    public var id: UUID
    public var logEntryUUID: UUID
    public var logEntryBookDay: WatchLogBookDay
    public var logEntryBookMonthID: UUID?
    public var logEntryBookYearID: UUID?
    
    init(id: UUID) {
        self.id = id
        logEntryUUID = UUID()
        logEntryBookDay = .init()
    }

    init() {
        id = UUID()
        logEntryUUID = UUID()
        logEntryBookDay = .init()
    }
    
    init(logEntryUUID: UUID, logBookDay: WatchLogBookDay) {
        self.id = UUID()
        self.logEntryUUID = logEntryUUID
        self.logEntryBookDay = logBookDay
        self.logEntryBookMonthID = logBookDay.watchLogBookMonth?.id
        self.logEntryBookYearID = logBookDay.watchLogBookMonth?.watchLogBookYear?.id
    }
    
//    func setToNil() {
//        self.logEntryUUID = nil
//        self.logEntryBookDay = nil
//    }
    
    static func == (lhs: LogEntryUUIDContainer, rhs: LogEntryUUIDContainer) -> Bool {
        return lhs.logEntryUUID == rhs.logEntryUUID && lhs.logEntryBookDay.id == rhs.logEntryBookDay.id && lhs.logEntryBookDay.watchLogBookEntries == rhs.logEntryBookDay.watchLogBookEntries
    }
}
